require "grip"
require "uri"
require "json"
require "colorize"
require "option_parser"
require "./mockgpt/*"
require "./mockgpt/struct/*"

module Mocker
  class_property ip : String = "localhost"
  class_property port : Int32 = 3000
  class_property model : String = "llama2-chinese"
  class_property gpt : String = "gpt-4"
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

mockgpt = Application.new(Mocker.ip, Mocker.port)
mockgpt.run
