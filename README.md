[![Crystal CI](https://github.com/yanecc/MockGPT/actions/workflows/Crystal%20CI.yml/badge.svg)](https://github.com/yanecc/MockGPT/actions/workflows/Crystal%20CI.yml)
[![Build for release](https://github.com/yanecc/MockGPT/actions/workflows/Build%20for%20release.yml/badge.svg)](https://github.com/yanecc/MockGPT/actions/workflows/Build%20for%20release.yml)

# Description

With the increasing number of AI applications built around OpenAI GPT, these applications provide services such as dialogue, translation, Copilot, and more.

[Ollama](https://github.com/ollama/ollama) has a variety of open-source large models that can be deployed on a user's personal computer for chatting or programming purposes.<br>
It is worth noting that Ollama provides the same API interface for these models.<br>
Open-source means they can be used for free and offline, which makes the existence of this project possible.

MockGPT acts as an intermediary on the user's local machine, forwarding requests from application software to OpenAI GPT to Ollama, and returning responses to the application in the format of OpenAI GPT, achieving the goal of mimicking OpenAI GPT. It can be used for conversational dialogue, AI translation, programming assistance, essay writing, and more. Default and streaming requests are now supported.


If the project helps you, please light up the star in the upper right!

# Requirement

Ollama and at least one large model pulled.

# Installation

Quick start on Linux, macOS, FreeBSD and OpenBSD (root required):

``` shell
# Windows x86_64
curl -L -o mockgpt.exe https://github.com/yanecc/MockGPT/releases/download/latest/mockgpt-windows-x86_64.exe
# OpenBSD x86_64
sudo pkg_add curl
sudo curl -L -o /usr/local/bin/mockgpt https://github.com/yanecc/MockGPT/releases/download/latest/mockgpt-openbsd-x86_64
sudo chmod +x /usr/local/bin/mockgpt
# FreeBSD x86_64
sudo fetch -o /usr/local/bin/mockgpt https://github.com/yanecc/MockGPT/releases/download/latest/mockgpt-freebsd-x86_64
sudo chmod +x /usr/local/bin/mockgpt
# macOS arm64/x86_64
sudo curl -L -o /usr/bin/mockgpt https://github.com/yanecc/MockGPT/releases/download/latest/mockgpt-macos-universal
sudo chmod +x /usr/bin/mockgpt
# Linux arm64
sudo curl -L -o /usr/local/bin/mockgpt https://github.com/yanecc/MockGPT/releases/download/latest/mockgpt-linux-arm64
sudo chmod +x /usr/local/bin/mockgpt
# Linux x86_64
sudo curl -L -o /usr/local/bin/mockgpt https://github.com/yanecc/MockGPT/releases/download/latest/mockgpt-linux-x86_64
sudo chmod +x /usr/local/bin/mockgpt
```

The [releases page](https://github.com/yanecc/MockGPT/releases/latest) provides statically compiled release packages for main platforms. For other platforms and architectures, check [Build for release](https://github.com/yanecc/MockGPT/actions/workflows/Build%20for%20release.yml) first, you may find monthly built products from the artifacts, or will have to install the Crystal language environment and compile it yourself otherwise.

``` shell
git clone https://github.com/yanecc/MockGPT
cd MockGPT
shards build --production --release --no-debug
```

# MockGPT Configuration

Configuration can be modified through a configuration file or runtime parameters.

Priority:<br>
1. runtime parameters
2. configuration file in program directory
3. configuration file in user home directory
4. default configuration

## Profiles

The configuration file mocker.json can be placed in the user's home directory or the program's runtime directory.

``` json
{
    "ip": "localhost",
    "port": 3000,
    "model": "llama3"
    "gpt": "gpt-4"
}
```

The default configuration above is used if no parameters are provided.

## Subcommands

```
Usage: mockgpt <subcommand>/<options> <arguments>

config                           Display the configuration in effect
upgrade                          Upgrade to the latest version
version                          Print the version
```

## Options

```
-b HOST, --binding HOST          Bind to the specified host
-p PORT, --port PORT             Run on the specified port
-m MODEL, --mocker MODEL         Employ the specified model
-h, --help                       Show this help
-v, --version                    Print the version
```

`-b`: Bind to the specified IP<br>
`-p`: Run on the specified port<br>
`-m`: Employ the specified model (Full name)<br>
`-h`: Show this help<br>
`-v`: Print MockGPT's version

## Config subcommand

```
Usage: mockgpt config [rm] <name> <value>

Example:
  mockgpt config [all]
  mockgpt config init
  mockgpt config port
  mockgpt config port 8080
  mockgpt config rm port gpt

Options:
  rm                             Reset a configuration to the default value
  all                            Display all configurations, same as mockgpt config
  init                           Initialize the configuration file if not exist
  -h, --help                     Show this help for config
```

The config subcommand provides functions to display, modify, and delete (reset) configurations, making it easy to modify the configuration file. It is recommended to run `mockgpt config init` before starting the service for the first time, which will generate the configuration file mocker.json in the user's home directory. You could move the file to the program directory if you want to keep it there.

# Usage

1. Start Ollama and MockGPT services.
2. Set the request address in the AI application to http://<mocker_ip>:<mocker_port>. (Models and API keys can be set arbitrarily or left blank).

# Stargazers over time

[![Stargazers over time](https://starchart.cc/18183883296/MockGPT.svg?variant=adaptive)](https://starchart.cc/18183883296/MockGPT)

# Welcome to Contribute

- If you have large models that can be used for free in the long term, please let me know. Support for these models may be considered to enhance this project in the future.
- If you find that MockGPT cannot be applied to a specific AI application that supports OpenAI GPT, please leave a comment to inform me.
- Currently known to be compatible with the following AI applications . If you discover more, feel free to leave a comment to add to the list.
  - NextChat
  - Chatbox
  - TTime
  - 划词翻译 (Browser extension)
  
Note: When using with Google Chrome browser extensions, you need to go to `chrome://flags`, enable the `Insecure origins treated as secure` option, and add the local listening address.