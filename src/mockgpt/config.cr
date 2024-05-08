require "colorize"

module Mocker
  class_property host : String = "localhost"
  class_property port : Int32 = 3000
  class_property model : String = "llama3"
  class_property gpt : String = "gpt-4"
  class_property executable = Path[Process.executable_path.not_nil!].stem
end

module Config
  extend self

  def init(path : Path)
    config = self.parse
    if File.exists? path
      puts "Config file already exists at #{path}"
    else
      File.write(path, config.to_pretty_json)
      puts "Config file created at #{path}"
    end
  end

  def parse
    return {
      "host"  => Mocker.host,
      "port"  => Mocker.port,
      "model" => Mocker.model,
      "gpt"   => Mocker.gpt,
    }
  end

  def parse(path : Path)
    if File.file? path
      configHash = Hash(String, String | Int32).from_json File.read(path)
    else
      self.parse
    end
  end

  def display
    puts "Host \t: #{Mocker.host}"
    puts "Port \t: #{Mocker.port}"
    puts "Model\t: #{Mocker.model}"
    puts "GPT  \t: #{Mocker.gpt}"
  end

  def display(key : String)
    config = self.parse
    puts "#{key} \t: #{config[key]}"
  end

  def remove(path : Path, keys : Array(String))
    config = self.parse path
    if File.exists? path
      File.write(path, config.reject!(keys).to_pretty_json)
      puts "#{keys} got reset."
    else
      puts "Please create a config file first.", ">> #{Mocker.executable} config init".colorize.bright.light_cyan
    end
  end

  def set(path : Path, key : String, value : String | Int32)
    config = self.parse path
    if File.exists? path
      config[key] = value
      File.write(path, config.to_pretty_json)
      puts "#{key} got set to #{value}."
    else
      puts "Please create a config file first.", ">> #{Mocker.executable} config init".colorize.bright.light_cyan
    end
  end
end
