require "grip"
require "./mockgpt/*"
require "./mockgpt/struct/*"

mockgpt = Application.new(Mocker.host, Mocker.port)
mockgpt.run
