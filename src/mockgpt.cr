require "grip"
require "uri"
require "json"
require "colorize"
require "option_parser"

module Mocker
  class_property ip : String = "localhost"
  class_property port : Int32 = 3000
  class_property model : String = "llama2-chinese"
end

confPath = File.exists?("#{Path.home}/mocker.json") ? "#{Path.home}/mocker.json" : "#{File.dirname Process.executable_path.not_nil!}/mocker.json"
if File.file?(confPath)
  mocker = JSON.parse(File.read(confPath))
  Mocker.ip = mocker["ip"].as_s if mocker["ip"]?
  Mocker.port = mocker["port"].as_i if mocker["port"]?
  Mocker.model = mocker["model"].as_s if mocker["model"]?
end

OptionParser.parse do |parser|
  parser.banner = "Usage: mockgpt [arguments]"
  parser.on("-b HOST", "--binding HOST", "Bind to the specified IP") { |_host| Mocker.ip = _host }
  parser.on("-p PORT", "--port PORT", "Run on the specified port") { |_port| Mocker.port = _port.to_i }
  parser.on("-m MODEL", "--mocker MODEL", "Employ the specified model") { |_model| Mocker.model = _model }
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

class MockGPT < Grip::Controllers::Http
  def ollama(context : Context)
    params = context.fetch_json_params
    params["model"] = Mocker.model
    presetUri = URI.parse "http://#{ENV["OLLAMA_HOST"]}"
    url = URI.new scheme: presetUri.scheme || "http", host: presetUri.host || "localhost", port: presetUri.port || 11434
    agent = HTTP::Client.new url
    agent.connect_timeout = 5
    print " POST ".colorize.bright.on_blue, "|                #{url}/api/chat | "
    begin
      agent.post(path: "/api/chat", body: params.to_json) do |response|
        # context.send_resp response.body_io.try &.gets_to_end

        currentTime = Time.local.to_unix

        leadChunk = {
          "choices" => [
            {
              "delta" => {
                "role"    => "assistant",
                "content" => "",
              },
              "index"         => 0,
              "finish_reason" => nil,
            },
          ],
          "created" => currentTime,
          "id"      => "chatcmpl",
          "object"  => "chat.completion.chunk",
          "model"   => "gpt-4",
        }
        context.send_resp("data: #{leadChunk.to_json}\n\n")
          .response.flush

        # response.body_io.each_line.skip(1).each do |line|
        response.body_io.each_line do |line|
          chunk = JSON.parse line

          transformedChunk = {
            "choices" => [
              {
                "delta" => {
                  "content" => chunk["message"]["content"].as_s,
                },
                "index"         => 0,
                "finish_reason" => chunk["done"].as_bool ? "stop" : nil,
              },
            ],
            "created" => currentTime,
            "id"      => "chatcmpl",
            "object"  => "chat.completion.chunk",
            "model"   => "gpt-4",
          }
          context.send_resp("data: #{transformedChunk.to_json}\n\n")
            .response.flush
        end
        puts " Done ".colorize.bright.on_green
      end
    rescue
      puts " Fail ".colorize.bright.on_red
    end
    context.send_resp "data: [DONE]"
  end
end

class CrossOriginResourceSharing
  include HTTP::Handler

  def call(context : HTTP::Server::Context)
    context.response.headers.add "Server", "Grip/v2"
    context.response.headers.add "Access-Control-Allow-Origin", "*"
    context.response.headers.add "Access-Control-Allow-Headers", "*"
    context.response.headers.add "Access-Control-Allow-Credentials", "true"
    context.response.headers.add "Content-Type", "text/event-stream; charset=utf-8"
    context.response.headers.add "Cache-Control", "no-cache"
    context.response.headers.add "X-Accel-Buffering", "no"

    if context.request.method != "POST"
      context.response.headers.add "Access-Control-Allow-Methods", "POST"

      return context.put_status(HTTP::Status::METHOD_NOT_ALLOWED)
    end

    call_next(context)
  end
end

class Application < Grip::Application
  def initialize(@host : String, @port : Int32)
    super(environment: "production", serve_static: false)

    router.insert(1, CrossOriginResourceSharing.new)

    post "/v1/chat/completions", MockGPT, as: :ollama
  end

  getter host : String
  getter port : Int32
  getter reuse_port : Bool = true
  getter fallthrough : Bool = true
  getter directory_listing : Bool = false
end

mockgpt = Application.new(Mocker.ip, Mocker.port)
mockgpt.run
