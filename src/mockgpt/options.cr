require "option_parser"

homePath = Path.home.join "mocker.json"
exePath = Path[File.dirname Process.executable_path.not_nil!].join "mocker.json"
confPath = File.exists?(exePath) ? exePath : homePath
if File.file?(confPath)
  mocker = JSON.parse(File.read(confPath))
  Mocker.host = mocker["host"].as_s if mocker["host"]?
  Mocker.port = mocker["port"].as_i if mocker["port"]?
  Mocker.model = mocker["model"].as_s if mocker["model"]?
  Mocker.gpt = mocker["gpt"].as_s if mocker["gpt"]?
end

OptionParser.parse do |parser|
  parser.banner = "Usage: #{Mocker.executable} <subcommand>/<options> <arguments>"
  parser.on("config", "Display the configuration in effect") do
    parser.on("-h", "--help", "Show config help") do
      puts CONFIG_HELP
      exit
    end
    parser.on("init", "Generate the configuration file") do
      Config.init confPath
      exit
    end
    parser.on("rm", "Reset a configuration to the default value") do
      parser.unknown_args do |args, _|
        Config.remove(confPath, args)
        exit
      end
    end
    parser.unknown_args do |args, _|
      if args.size > 2
        STDERR.puts "Too many arguments: #{args}", parser
        exit 1
      end
      case args[0]? || "all"
      when "all"
        Config.display
      when "host", "model", "gpt"
        if args[1]?
          Config.set confPath, args[0], args[1]
        else
          Config.display args[0]
        end
      when "port"
        if args[1]?
          Config.set confPath, args[0], args[1].to_u16? || abort "Invalid port: #{args[1]}"
        else
          Config.display args[0]
        end
      else
        STDERR.puts "Undefined option: #{args[0]}", CONFIG_HELP
      end
      exit
    end
  end
  parser.on("upgrade", "Upgrade to the latest version") do
    url = "https://github.com/yanecc/MockGPT/tags"
    pattern = /href="\/yanecc\/MockGPT\/releases\/tag\/([0-9.]+)"/
    latestVersion = Utils.getLatestVersion(url, pattern)
    if latestVersion == VERSION
      puts "Already up to date."
    else
      Commands.upgrade if Utils.confirmUpgrade latestVersion
    end
    exit
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
    exit 1
  end
end
