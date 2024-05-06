[![Crystal CI](https://github.com/yanecc/MockGPT/actions/workflows/Crystal%20CI.yml/badge.svg)](https://github.com/yanecc/MockGPT/actions/workflows/Crystal%20CI.yml)
[![Build for release](https://github.com/yanecc/MockGPT/actions/workflows/Build%20for%20release.yml/badge.svg)](https://github.com/yanecc/MockGPT/actions/workflows/Build%20for%20release.yml)

# 项目说明

围绕OpenAI GPT建立的AI应用越来越多，这些应用提供对话、翻译、Copilot等服务。

[Ollama](https://github.com/ollama/ollama)有着非常多能够在用户个人电脑部署的开源大模型，可用于聊天或编程。<br>
值得高兴的是，Ollama为这些模型提供了相同的API接口<br>
开源意味着免费和离线使用，这就为本项目的存在提供了可能

MockGPT在用户本机将应用软件向OpenAI GPT发起的请求，转移到Ollama，并以OpenAI GPT的响应格式返回给应用，从而达到模仿OpenAI GPT的目的，可以用于交谈对话、AI翻译、编程辅助、作文等，现已支持常规请求和流式请求。

如果MockGPT帮到了你，请点亮右上角的Star！

# 预先要求

Ollama及至少一个大模型

# 安装

快速安装（需要root权限）:

``` shell
# Linux arm64
sudo curl -L -o /usr/bin/mockgpt https://github.com/yanecc/MockGPT/releases/latest/download/mockgpt-linux-arm64
sudo chmod +x /usr/bin/mockgpt
# Linux x86_64
sudo curl -L -o /usr/bin/mockgpt https://github.com/yanecc/MockGPT/releases/latest/download/mockgpt-linux-x86_64
sudo chmod +x /usr/bin/mockgpt
# macOS arm64/x86_64
sudo curl -L -o /usr/bin/mockgpt https://github.com/yanecc/MockGPT/releases/latest/download/mockgpt-macos-universal
sudo chmod +x /usr/bin/mockgpt
# FreeBSD x86_64
sudo fetch -o /usr/bin/mockgpt https://github.com/yanecc/MockGPT/releases/latest/download/mockgpt-freebsd-x86_64
sudo chmod +x /usr/bin/mockgpt
```

[发布页面](https://github.com/yanecc/MockGPT/releases/latest)为主流平台提供了静态编译的MockGPT程序和发行包，若在其他平台使用，首先查看[Build for release](https://github.com/yanecc/MockGPT/actions/workflows/Build%20for%20release.yml)，那里可能有每月构建的版本，若没有则需要安装Crystal语言环境自行编译。

``` shell
git clone https://github.com/yanecc/MockGPT
shards install
shards build --production --release --no-debug
```

# MockGPT配置

可以通过配置文件或运行时参数修改配置

优先级：<br>
1. 运行时参数
2. 程序同目录的配置文件
3. 用户家目录的配置文件
4. 默认配置

## 配置文件

可以将配置文件`mocker.json`放在用户主目录或程序运行目录下。

``` json
{
    "ip": "localhost",
    "port": 3000,
    "model": "llama3"
    "gpt": "gpt-4"
}
```

以上为无参数运行时的默认配置

## 运行时参数

```
-b HOST, --binding HOST          Bind to the specified IP
-p PORT, --port PORT             Run on the specified port
-m MODEL, --mocker MODEL         Employ the specified model
-h, --help                       Show this help
```

`-b`：MockGPT监听的IP地址<br>
`-p`：MockGPT监听的端口号<br>
`-m`：MockGPT请求的模型**全称**<br>
`-h`：使用帮助

# 使用方法

1. 启动Ollama及MockGPT服务
2. 在AI应用将请求地址设置为http://<mocker_ip>:<mocker_port>
（模型和API key可以任意设置或留空）

## 星图

[![Stargazers over time](https://starchart.cc/18183883296/MockGPT.svg?variant=adaptive)](https://starchart.cc/18183883296/MockGPT)

# 欢迎提出建议

- 如果有能够长期免费使用的大模型，请告诉我，后续会考虑支持以完善这个项目
- 如果你发现MockGPT无法应用到某个支持OpenAI GPT的AI应用，请留言告诉我
- 目前已知适配下列AI应用，如果你发现了更多，欢迎留言补充
  - NextChat
  - Chatbox
  - TTime
  - 划词翻译（浏览器插件）

注：在谷歌浏览器插件中使用，需进入`chrome://flags`，启用`Insecure origins treated as secure`一项，添加本地监听地址