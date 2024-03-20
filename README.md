# Description

With the increasing number of AI applications built around OpenAI GPT, these applications provide services such as dialogue, translation, Copilot, and more.

Ollama has a variety of open-source large models that can be deployed on a user's personal computer for chatting or programming purposes. It is worth noting that Ollama provides the same API interface for these models. Being open-source means they can be used for free and offline, which makes the existence of this project possible.

MockGPT acts as an intermediary on the user's local machine, forwarding requests from application software to OpenAI GPT to Ollama, and returning responses to the application in the format of OpenAI GPT, achieving the goal of mimicking OpenAI GPT. It can be used for conversational dialogue, AI translation, programming assistance, essay writing, and more.

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

Configuration can be modified through a configuration file or runtime parameters.
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

`-b`：Bind to the specified IP
`-p`：Run on the specified port
`-m`：Employ the specified model (Full name)
`-h`：Show this help

# Usage

1. Start Ollama and MockGPT services.
2. Set the request address in the AI application to http://<mocker_ip>:<mocker_port>. (Models and API keys can be set arbitrarily or left blank).

# Welcome to Contribute

1. If you have large models that can be used for free in the long term, please let me know. Support for these models may be considered to enhance this project in the future.
2. Currently known to be compatible with AI applications such as NextChat, Chatbox, TTime, and more. If you discover more, feel free to leave a comment to add to the list.
3. If you find that MockGPT cannot be applied to a specific AI application that supports OpenAI GPT, please leave a comment to inform me.
