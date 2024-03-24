record Dialog, role : String, content : String do
  include JSON::Serializable
end

struct PlainRequest
  include JSON::Serializable

  property model : String = Mocker.model
  property stream : Bool = false
  property messages : Array(Dialog)
end
