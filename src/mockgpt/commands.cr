module Commands
  extend self

  def upgrade
    exePath = Process.executable_path.not_nil!
    exeName = File.basename exePath
    tempPath = File.join(File.dirname(exePath), ".#{exeName}")

    {% if flag?(:windows) && flag?(:x86_64) %}
      File.rename(exePath, tempPath)
      batchPath = File.join(File.dirname(exePath), ".upgrade.bat")
      url = "https://github.com/yanecc/MockGPT/releases/latest/download/mockgpt-windows-x86_64.exe"

      wait_channel = Channel(Nil).new
      Process.on_terminate do |reason|
        case reason
        when .interrupted?
          File.rename(tempPath, exePath)
          {% if compare_versions(Crystal::VERSION, "1.5.0") >= 0 %}
            File.delete? batchPath
          {% else %}
            File.delete batchPath if File.exists? batchPath
          {% end %}
          wait_channel.close
        end
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
        wait_channel.receive
        Process.exec("cmd.exe", ["/C", batchPath])
      else
        {% if compare_versions(Crystal::VERSION, "1.5.0") >= 0 %}
          File.delete? exePath
        {% else %}
          File.delete exePath if File.exists? exePath
        {% end %}
        File.rename(tempPath, exePath)
        puts "Upgrade failed. Please try again."
        exit 1
      end
    {% else %}
      url = "https://github.com/yanecc/MockGPT/releases/latest/download/mockgpt-"
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
      else
        {% if compare_versions(Crystal::VERSION, "1.5.0") >= 0 %}
          File.delete? tempPath
        {% else %}
          File.delete tempPath if File.exists? tempPath
        {% end %}
      end
    {% end %}
  end
end
