VERSION = "1.2.2"

COMMANDS_VERSION = <<-VERSION
MockGPT v#{VERSION}

GitHub:  \t https://github.com/yanecc/mockgpt
Codeberg:\t https://codeberg.org/sunrise/mockgpt
VERSION

CONFIG_HELP = <<-CONFIG
Usage: mockgpt config [rm] <name> <value>

Example:
  mockgpt config [all]
  mockgpt config init
  mockgpt config port
  mockgpt config port 8080
  mockgpt config rm port gpt

Options:
  all         \t Display all configurations, same as mockgpt config
  init        \t Generate the configuration file if not exist
  rm          \t Reset a configuration to the default value
  -h, --help  \t Show this help for config
CONFIG
