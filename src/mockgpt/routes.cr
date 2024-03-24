class Application < Grip::Application
  def initialize(@host : String, @port : Int32)
    super(environment: "production", serve_static: false)

    router.insert(1, CrossOriginResourceSharing.new)

    post "/v1/chat/completions", MockGPT, as: :ollama
    options "/v1/chat/completions", MockGPT, as: :connect
  end

  getter host : String
  getter port : Int32
  getter reuse_port : Bool = true
  getter fallthrough : Bool = true
  getter directory_listing : Bool = false
end
