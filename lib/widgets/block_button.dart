import 'package:flutter/material.dart';

class BlockButton extends StatelessWidget {
  const BlockButton(
      {super.key,
      required this.title,
      required this.icon,
      this.subtitle,
      this.isActive,
      this.showBgc,
      this.onPressed});

  final bool? showBgc;
  final bool? isActive;
  final String title;
  final String? subtitle;
  final IconData icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    var titleBox = [
      Text(title, style: const TextStyle(fontSize: 20)),
    ];
    if (subtitle != null) {
      titleBox.add(Text(subtitle!, style: const TextStyle(fontSize: 15)));
    }
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: FractionallySizedBox(
        widthFactor: 1,
        child: ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
              fixedSize: const MaterialStatePropertyAll(Size(0, 100)),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
              elevation: const MaterialStatePropertyAll(0),
              backgroundColor: (showBgc ?? true)
                  ? MaterialStatePropertyAll((isActive ?? false)
                      ? Theme.of(context).colorScheme.inversePrimary
                      : Theme.of(context).focusColor)
                  : null,
            ),
            child: Row(
              children: [
                Icon(icon, size: 40),
                Container(
                    padding: const EdgeInsets.only(left: 15),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: titleBox,
                      ),
                    ))
              ],
            )),
      ),
    );
  }
}
