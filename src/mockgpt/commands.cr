module Commands
  extend self

  def upgrade
    exePath = Process.executable_path.not_nil!
    exeName = File.basename exePath
    tempPath = File.join(File.dirname(exePath), ".#{exeName}")

    {% if flag?(:windows) && flag?(:x86_64) %}
      File.rename(exePath, tempPath)
      batchPath = File.join(File.dirname(exePath), ".upgrade.bat")
      url = "https://github.com/yanecc/MockGPT/releases/download/latest/mockgpt-windows-x86_64.exe"
      Process.on_terminate do |reason|
        if reason.interrupted?
          File.rename(tempPath, exePath)
          {% if compare_versions(Crystal::VERSION, "1.5.0") >= 0 %}
            File.delete? batchPath
          {% else %}
            File.delete batchPath if File.exists? batchPath
          {% end %}
          STDERR.puts "Upgrade interrupted. Please try again."
        else
          STDERR.puts "Upgrade failed. Please try again."
        end
        exit 1
      end

      Utils.download(url, exePath)

      if File.executable?(exePath)
        batchContent = <<-BATCH
        @echo off
        :Repeat
        del "#{tempPath}"
        if exist "#{tempPath}" goto Repeat
        del "#{batchPath}"
        BATCH
        File.write(batchPath, batchContent)
        Process.new("cmd.exe", ["/C", batchPath])
        puts "Upgrade succeeded!"
      else
        File.rename(tempPath, exePath)
        STDERR.puts "Upgrade failed. Please try again."
        exit 1
      end
    {% else %}
      url = "https://github.com/yanecc/MockGPT/releases/download/latest/mockgpt-"
      {% if flag?(:darwin) %}
        url += "macos-universal"
      {% elsif flag?(:freebsd) && flag?(:x86_64) %}
        url += "freebsd-x86_64"
      {% elsif flag?(:openbsd) && flag?(:x86_64) %}
        url += "openbsd-x86_64"
      {% elsif flag?(:linux) && flag?(:aarch64) %}
        url += "linux-arm64"
      {% elsif flag?(:linux) && flag?(:x86_64) %}
        url += "linux-x86_64"
      {% else %}
        abort "No pre-built binary available for your platform."
      {% end %}
      Utils.download(url, tempPath)
      File.chmod(tempPath, 0o755)

      if File.executable?(tempPath)
        File.rename(tempPath, exePath)
        puts "Upgrade succeeded!"
      else
        {% if compare_versions(Crystal::VERSION, "1.5.0") >= 0 %}
          File.delete? tempPath
        {% else %}
          File.delete tempPath if File.exists? tempPath
        {% end %}
        STDERR.puts "Upgrade failed. Please try again."
        exit 1
      end
    {% end %}
  end
end
