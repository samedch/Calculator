import 'package:flutter/material.dart';

class ButtonInfo {
  late String label;
  late Color fontColor;
  late Color backColor;

  ButtonInfo(this.label, this.fontColor, this.backColor);
}

class MyButton extends StatefulWidget {
  String label;
  Color fontColor;
  Color backColor;
  final VoidCallback? onClick;

  MyButton(
      {super.key,
      required this.label,
      required this.fontColor,
      required this.backColor,
      this.onClick});

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClick,
      child: Container(
        decoration: BoxDecoration(
            color: widget.backColor,
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: Center(
          child: Text(
            widget.label,
            style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: widget.fontColor),
          ),
        ),
      ),
    );
  }
}
