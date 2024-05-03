import 'package:flutter/material.dart';
import 'package:frp/platform/platform.dart';
import 'package:frp/widgets/block_button.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  @override
  State<StatefulWidget> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  var isRunning = false;

  _HomeRouteState() {
    frpcController("status").then((value) {
      setState(() {
        isRunning = value["data"] == 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ListView(children: [
        BlockButton(
          title: isRunning ? "运行中" : "未启动",
          subtitle: isRunning ? "点击停止" : "点击启动",
          icon: Icons.power_settings_new,
          isActive: isRunning,
          onPressed: () async {
            if (isRunning) {
              var res = await frpcController("stop");
              if (res["success"]) {
                setState(() {
                  isRunning = false;
                });
              }
            } else {
              var res = await frpcController("start");
              if (res["success"]) {
                setState(() {
                  isRunning = true;
                });
              }
            }
          },
        ),
        BlockButton(
          title: "配置",
          subtitle: "点击编辑",
          icon: Icons.settings,
          onPressed: () => Navigator.pushNamed(context, '/config'),
        ),
        BlockButton(
          title: "日志",
          icon: Icons.format_list_bulleted,
          onPressed: () => Navigator.pushNamed(context, '/log'),
        ),
        BlockButton(
          title: "关于",
          icon: Icons.info,
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => const AlertDialog(
                    icon: Image(
                      image: AssetImage("images/logo.png"),
                    ),
                    title: Text("Fast Reverse Proxy"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("version: 1.0.0"),
                        Text("frp version: 0.57.0"),
                        Text("author: violetfreesia"),
                        Text("UI Ref: Clash Meta For Android"),
                        Text("Function Ref: AceDroidx/frp-Android"),
                      ],
                    )));
          },
        ),
      ]),
    );
  }
}
