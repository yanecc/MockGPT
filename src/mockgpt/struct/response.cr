struct PlainResponse
  include JSON::Serializable

  def initialize(@created, @choices, @usage)
  end

  @id : String = "chatcmpl"

  @object : String = "chat.completion"

  @model : String = Mocker.gpt

  property created : Int64

  property choices : Array(Choice)

  property usage : Usage
end

struct Choice
  include JSON::Serializable

  def initialize(@message)
  end

  property message : Message

  @index : Int32 = 0

  @finish_reason : String = "stop"
end

struct Message
  include JSON::Serializable

  def initialize(@role, @content)
  end

  property role : String

  property content : String
end

struct Usage
  include JSON::Serializable

  def initialize(@prompt_tokens, @completion_tokens, @total_tokens)
  end

  property prompt_tokens : Int32

  property completion_tokens : Int32

  property total_tokens : Int32
end
