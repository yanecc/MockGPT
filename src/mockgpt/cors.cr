class CrossOriginResourceSharing
  include HTTP::Handler

  def call(context : HTTP::Server::Context)
    context.response.headers.add "Server", "Grip/v3"
    context.response.headers.add "Access-Control-Allow-Origin", "*"
    context.response.headers.add "Access-Control-Allow-Headers", "*"
    context.response.headers.add "Access-Control-Allow-Credentials", "true"
    context.response.headers.add "Content-Type", "text/event-stream; charset=utf-8"
    context.response.headers.add "Cache-Control", "no-cache"
    context.response.headers.add "X-Accel-Buffering", "no"

    unless context.request.method.in? ["POST", "OPTIONS"]
      context.response.headers.add "Access-Control-Allow-Methods", "POST"

      return context.put_status(HTTP::Status::METHOD_NOT_ALLOWED)
    end

    call_next(context)
  end
end
