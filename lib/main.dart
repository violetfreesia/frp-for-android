import 'package:flutter/material.dart';
import 'package:frp/routes/config_route.dart';
import 'package:frp/routes/home_route.dart';
import 'package:frp/routes/log_route.dart';
import 'package:frp/widgets/page_layout.dart';

const colorSeed = Color.fromARGB(255, 255, 195, 107);

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: colorSeed),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: colorSeed,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const PageLayout(
              title: 'Fast Reverse Proxy',
              body: HomeRoute(),
              showLogo: true,
            ),
        '/config': (context) => const ConfigRoute(),
        '/log': (context) => const LogRoute(),
      },
    );
  }
}
