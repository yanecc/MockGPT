require "grip"
require "uri"
require "json"
require "colorize"
require "option_parser"
require "./mockgpt/*"
require "./mockgpt/struct/*"

module Mocker
  class_property host : String = "localhost"
  class_property port : Int32 = 3000
  class_property model : String = "llama3"
  class_property gpt : String = "gpt-4"
end

homePath = "#{Path.home}/mocker.json"
exePath = "#{File.dirname Process.executable_path.not_nil!}/mocker.json"
confPath = File.exists?(exePath) ? exePath : homePath
if File.file?(confPath)
  mocker = JSON.parse(File.read(confPath))
  Mocker.host = mocker["host"].as_s if mocker["host"]?
  Mocker.port = mocker["port"].as_i if mocker["port"]?
  Mocker.model = mocker["model"].as_s if mocker["model"]?
  Mocker.gpt = mocker["gpt"].as_s if mocker["gpt"]?
end

OptionParser.parse do |parser|
  parser.banner = "Usage: mockgpt <subcommand>/<options> <arguments>"
  parser.on("config", "Display the configuration in effect") do
    parser.on("-h", "--help", "Show config help") do
      puts CONFIG_HELP
      exit
    end
    parser.unknown_args do |args, options|
      if args.size > 2
        STDERR.puts "Too many arguments: #{args}", parser
        exit(1)
      end
      case args[0]? || "all"
      when "all"
        puts "Host \t: #{Mocker.host}"
        puts "Port \t: #{Mocker.port}"
        puts "Model\t: #{Mocker.model}"
        puts "GPT  \t: #{Mocker.gpt}"
      when "host"
        puts Mocker.host
      when "port"
        puts Mocker.port
      when "model"
        puts Mocker.model
      when "gpt"
        puts Mocker.gpt
      when "init"
        puts "Config file initialized."
      when "rm"
        args[1]? && case args[1]
        when "host"
          puts Mocker.host
        when "port"
          puts Mocker.port
        when "model"
          puts Mocker.model
        when "gpt"
          puts Mocker.gpt
        else
          STDERR.puts "Undefined option: #{args[1]}", parser
        end
      else
        STDERR.puts "Undefined option: #{args[1]}", parser
      end

      exit
    end
  end
  parser.on("version", "Print the version") do
    puts COMMANDS_VERSION
    exit
  end
  parser.on("-b HOST", "--binding HOST", "Bind to the specified host") { |_host| Mocker.host = _host }
  parser.on("-p PORT", "--port PORT", "Run on the specified port") { |_port| Mocker.port = _port.to_i }
  parser.on("-m MODEL", "--mocker MODEL", "Employ the specified model") { |_model| Mocker.model = _model }
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end
  parser.on("-v", "--version", "Print the version") do
    puts COMMANDS_VERSION
    exit
  end
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

mockgpt = Application.new(Mocker.host, Mocker.port)
mockgpt.run
