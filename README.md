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

The release page provides a standalone MockGPT program for Windows and Linux platforms, x86_64 architecture, statically compiled. For other platforms, you will need to install the Crystal language environment and compile it yourself.

``` shell
git clone https://github.com/18183883296/MockGPT
shards install
shards build -Dpreview_mt --production
```

# MockGPT Configuration

Configuration can be modified through a configuration file or runtime parameters.<br>
Priority: runtime parameters > configuration file > default configuration.

## Profiles

The configuration file mocker.json can be placed in the user's home directory or the program's runtime directory.

``` json
{
    "ip": "localhost",
    "port": 3000,
    "model": "llama2-chinese"
}
```

The default configuration above is used if no parameters are provided.

## Options

```
-b HOST, --binding HOST          Bind to the specified IP
-p PORT, --port PORT             Run on the specified port
-m MODEL, --mocker MODEL         Employ the specified model
-h, --help                       Show this help
```

`-b`：Bind to the specified IP<br>
`-p`：Run on the specified port<br>
`-m`：Employ the specified model (Full name)<br>
`-h`：Show this help

# Usage

1. Start Ollama and MockGPT services.
2. Set the request address in the AI application to http://<mocker_ip>:<mocker_port>. (Models and API keys can be set arbitrarily or left blank).

# Welcome to Contribute

- If you have large models that can be used for free in the long term, please let me know. Support for these models may be considered to enhance this project in the future.
- If you find that MockGPT cannot be applied to a specific AI application that supports OpenAI GPT, please leave a comment to inform me.
- Currently known to be compatible with the following AI applications . If you discover more, feel free to leave a comment to add to the list.
  - NextChat
  - Chatbox
  - TTime
  - 划词翻译 (Browser extension)
  
Note: When using with Google Chrome browser extensions, you need to go to `chrome://flags`, enable the `Insecure origins treated as secure` option, and add the local listening address.