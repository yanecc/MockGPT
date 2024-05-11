module Utils
  extend self

  def getLatestVersion(url : String, pattern : Regex) : String
    response = HTTP::Client.get(url)
    if response.status_code == 200
      return response.body.to_s.match(pattern).try &.[1] || abort "Failed to match available versions."
    else
      abort "Failed to get latest version: #{response.status_message}"
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
    answer = gets.try &.chomp.downcase

    answer == "y"
  end
end
