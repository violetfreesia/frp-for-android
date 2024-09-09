import 'package:flutter/services.dart';

const platform = MethodChannel("ACTION_HANDLER");

Future<Map> readConfig() async {
  return await platform.invokeMethod("ReadConfig");
}

Future<Map> readLog() async {
  return await platform.invokeMethod("ReadLog");
}

Future<Map> clearLog() async {
  return await platform.invokeMethod("ClearLog");
}

Future<Map> saveConfig(String config) async {
  return await platform.invokeMethod("SaveConfig", {"content": config});
}

Future<Map> frpcController(String type) async {
  return await platform.invokeMethod("FRP", {"type": type});
}
