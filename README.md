# 项目说明

围绕OpenAI GPT建立的AI应用越来越多，这些应用提供对话、翻译、Copilot等服务。

Ollama有着非常多能够在用户个人电脑部署的开源大模型，可用于聊天或编程。<br>
值得高兴的是，Ollama为这些模型提供了相同的API接口<br>
开源意味着免费和离线使用，这就为本项目的存在提供了可能

MockGPT在用户本机将应用软件向OpenAI GPT发起的请求，转移到Ollama，并以OpenAI GPT的响应格式返回给应用，从而达到模仿OpenAI GPT的目的，可以用于交谈对话、AI翻译、编程辅助、作文等。

如果MockGPT帮到了你，请点亮右上角的Star！

# 预先要求

Ollama及至少一个大模型

# 安装

发布页面提供了适用于Windows和Linux平台、x86_64架构、静态编译的MockGPT独立程序，若在其他平台使用，需要安装Crystal语言环境自行编译。

``` shell
git clone https://github.com/18183883296/MockGPT
shards install
shards build -Dpreview_mt --production
```

# MockGPT配置

可以通过配置文件或运行时参数修改配置<br>
优先级：运行时参数 > 配置文件 > 默认配置

## 配置文件

可以将配置文件`mocker.json`放在用户主目录或程序运行目录下。

``` json
{
	"ip": "localhost",
	"port": 3000,
	"model": "llama2-chinese"
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

# 欢迎提出建议

1. 如果有能够长期免费使用的大模型，请告诉我，后续会考虑支持以完善这个项目
2. 目前已知适配NextChat、Chatbox、TTime等AI应用，如果你发现了更多，欢迎留言补充
3. 如果你发现MockGPT无法应用到某个支持OpenAI GPT的AI应用，请留言告诉我
