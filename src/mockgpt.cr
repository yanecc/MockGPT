require "grip"
require "./mockgpt/*"

mockgpt = Application.new(Mocker.host, Mocker.port)
mockgpt.run
