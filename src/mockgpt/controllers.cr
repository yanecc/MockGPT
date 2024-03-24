class MockGPT < Grip::Controllers::Http
  def connect(context : Context)
    context
      .put_status(HTTP::Status::OK)
      .halt
  end

  def ollama(context : Context)
    params = context.fetch_json_params
    params["model"] = Mocker.model
    presetUri = URI.parse "http://#{ENV["OLLAMA_HOST"]}"
    url = URI.new scheme: presetUri.scheme || "http", host: presetUri.host || "localhost", port: presetUri.port || 11434
    agent = HTTP::Client.new url
    agent.connect_timeout = 5
    print " POST ".colorize.bright.on_blue, "|            #{url}/api/chat | "
    currentTime = Time.local.to_unix
    if params["stream"]?
      print "stream | "
      begin
        agent.post(path: "/api/chat", body: params.to_json) do |response|
          # context.send_resp response.body_io.try &.gets_to_end

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
            "model"   => Mocker.gpt,
          }
          context
            .send_resp("data: #{leadChunk.to_json}\n\n")
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
              "model"   => Mocker.gpt,
            }
            context
              .send_resp("data: #{transformedChunk.to_json}\n\n")
              .response.flush
          end
          puts " Done ".colorize.bright.on_green
          context.send_resp "data: [DONE]"
        end
      rescue
        puts " Fail ".colorize.bright.on_red
        context
          .put_status(HTTP::Status::BAD_REQUEST)
          .halt
      end
    else
      print "normal | "
      begin
        plainRequest = PlainRequest.from_json(params.to_json)
        plainResponse = agent.post(path: "/api/chat", body: plainRequest.to_json)
        respJson = JSON.parse plainResponse.body
        gptResponse = PlainResponse.new(
          created: currentTime,
          choices: [
            Choice.new(
              message: Message.new(
                role: respJson["message"]["role"].as_s,
                content: respJson["message"]["content"].as_s,
              ),
            ),
          ],
          usage: Usage.new(
            prompt_tokens: respJson["prompt_eval_count"].as_i,
            completion_tokens: respJson["eval_count"].as_i,
            total_tokens: respJson["prompt_eval_count"].as_i + respJson["eval_count"].as_i,
          ),
        )
        puts " Done ".colorize.bright.on_green
        context.send_resp gptResponse.to_json
      rescue
        puts " Fail ".colorize.bright.on_red
        context
          .put_status(HTTP::Status::BAD_REQUEST)
          .halt
      end
    end
  end
end
