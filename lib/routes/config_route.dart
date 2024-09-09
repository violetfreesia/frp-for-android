import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:frp/platform/platform.dart';
import 'package:highlight/highlight.dart';

class ConfigRoute extends StatefulWidget {
  const ConfigRoute({super.key});

  @override
  State<StatefulWidget> createState() => _ConfigRouteState();
}

const defaultConfig = """
serverAddr = "your server"
serverPort = 3000
#auth.token = "xxx"
dnsServer = "114.114.114.114"
#natHoleStunServer = "stun.voip.aebc.com:3478"
#natHoleStunServer = "stun.miwifi.com:3478"

[[visitors]]
name = "cellphone"
type = "xtcp"
# 要访问的 P2P 代理的名称
serverName = "xxx"
secretKey = "xxx"
# 绑定本地端口以访问远程服务
bindAddr = "0.0.0.0"
bindPort = 6000
# 如果需要自动保持隧道打开，将其设置为 true
keepTunnelOpen = true
""";

class _ConfigRouteState extends State<ConfigRoute> {
  var controller = CodeController(
    text: "", // Initial code
    language: Mode(
        aliases: ["toml"],
        case_insensitive: true,
        contains: [
          Mode(className: "comment", begin: ";", end: "\$"),
          Mode(className: "comment", begin: "#", end: "\$"),
          Mode(className: "section", begin: "\\[+", end: "\\]+"),
          Mode(
              className: "attr",
              begin: "^[a-zA-Z0-9_]+",
              end: "=",
              excludeEnd: true),
          Mode(className: "string", begin: "\"", end: "\"", relevance: 0),
          Mode(className: "string", begin: "'", end: "'", relevance: 0)
        ]),
  );

  _ConfigRouteState() {
    readConfig().then((value) {
      setState(() {
        controller.text = value["data"] == '' ? defaultConfig : value["data"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Brightness currentBrightness = Theme.of(context).colorScheme.brightness;
    var codeTheme = currentBrightness == Brightness.dark
        ? atomOneDarkTheme
        : atomOneLightTheme;
    TextStyle? root = codeTheme['root'];

    return Scaffold(
      backgroundColor: root?.backgroundColor,
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("配置")),
      body: CodeTheme(
        data: CodeThemeData(styles: codeTheme),
        child: SingleChildScrollView(
          child: CodeField(
            controller: controller,
            minLines: 20,
            gutterStyle: const GutterStyle(
              textAlign: TextAlign.left,
              margin: 0,
              showErrors: false,
              showFoldingHandles: false,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          saveConfig(controller.fullText).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: value["success"]
                    ? Colors.green
                    : Theme.of(context).colorScheme.error,

                content: value["success"]
                    ? const Text("保存成功")
                    : Text("保存失败: ${value["message"]}"),
              ),
            );
          });
        },
      ),
    );
  }
}
