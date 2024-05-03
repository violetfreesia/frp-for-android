import 'package:flutter/material.dart';

import '../routes/home_route.dart';

class PageLayout extends StatelessWidget {
  const PageLayout(
      {super.key, required this.title, required this.body, this.showLogo});

  final String title;
  final Widget body;
  final bool? showLogo;

  @override
  Widget build(BuildContext context) {
    Widget titleWidget = Text(title);
    if (showLogo ?? false) {
      titleWidget = Row(
        children: [
          const Image(
            image: AssetImage("images/logo.png"),
            width: 36,
          ),
          Container(margin: const EdgeInsets.only(left: 10), child: titleWidget)
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: titleWidget),
      body: body,
    );
  }
}
