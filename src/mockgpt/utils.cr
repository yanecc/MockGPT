module Utils
  extend self

  def getLatestVersion(url : String, pattern : Regex) : String
    response = HTTP::Client.get(url)
    if response.status_code == 200
      {% if compare_versions(Crystal::VERSION, "1.9.0") >= 0 %}
        return response.body.to_s.match!(pattern)[1]
      {% else %}
        return response.body.to_s.match(pattern).try &.[1] || raise("Failed to match available versions.")
      {% end %}
    else
      puts "Failed to get latest version: #{response.status_message}"
      exit(1)
    end
  end

  def download(url, dest)
    HTTP::Client.get(url) do |response|
      if response.status.redirection?
        if location = response.headers["location"]?
          url = location
          Log.debug { "Redirected to #{url}" }
        else
          abort "Got status #{response.status_code}, but no location was sent."
        end
        download(url, dest)
      else
        File.write(dest, response.body_io.gets_to_end)
      end
    end
  end

  def confirmUpgrade(version : String) : Bool
    puts "New version available: v#{version}"
    print "Upgrade to the latest version? (y/N) "
    answer = gets.not_nil!.chomp.downcase

    answer == "y"
  end
end
