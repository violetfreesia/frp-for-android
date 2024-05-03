import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:frp/platform/platform.dart';

class LogRoute extends StatefulWidget {
  const LogRoute({super.key});

  @override
  State<StatefulWidget> createState() => _LogRouteState();
}

class _LogRouteState extends State<LogRoute> {
  var controller = CodeController(
    text: "", // Initial code
  );

  _LogRouteState() {
    readLog().then((value) {
      if (value["success"]) {
        setState(() {
          controller.text = value["data"];
        });
      }
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
          title: const Text("日志")),
      body: CodeTheme(
        data: CodeThemeData(styles: codeTheme),
        child: SingleChildScrollView(
          child: CodeField(
            controller: controller,
            minLines: 20,
            readOnly: true,
            gutterStyle: const GutterStyle(
                margin: 0,
                width: 65,
                textAlign: TextAlign.left,
                showErrors: false,
                showFoldingHandles: false),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "clear",
            child: const Icon(Icons.clear_all),
            onPressed: () {
              clearLog().then((value) {
                if (value["success"]) {
                  setState(() {
                    controller.text = value["data"];
                  });
                }
              });
            },
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: FloatingActionButton(
              heroTag: "refresh",
              child: const Icon(Icons.refresh),
              onPressed: () {
                readLog().then((value) {
                  if (value["success"]) {
                    setState(() {
                      controller.text = value["data"];
                    });
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
