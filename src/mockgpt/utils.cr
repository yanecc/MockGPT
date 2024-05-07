module Utils
  extend self

  def getLatestVersion(url : String, pattern : Regex) : String
    response = HTTP::Client.get(url)
    if response.status_code == 200
      response.body.to_s.match!(pattern)[1]
    else
      puts "Failed to get latest version: #{response.status_code}"
      exit(1)
    end
  end

  def download(url, dest)
    HTTP::Client.get(url) do |response|
      # Check for a redirect
      if response.status.redirection?
        # Get a new URL
        if location = response.headers["location"]?
          url = location
          Log.debug { "Redirected to #{url}" }
        else
          abort "Got status #{response.status_code}, but no location was sent"
        end
        download(url, dest)
      else
        File.write(dest, response.body_io.gets_to_end)
      end
    end
  end

  def confirmUpgrade(version : String) : Bool
    puts "New version available: v#{version}"
    print "Upgrade to the latest version? (Y/n) "
    answer = gets.not_nil!.chomp.downcase

    answer == "y"
  end
end
