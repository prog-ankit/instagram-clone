import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final String text;
  final Color btnColor;
  final Color txtColor;
  final Color borderColor;
  const FollowButton(
      {super.key,
      this.function,
      required this.btnColor,
      required this.text,
      required this.txtColor,
      required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30.0),
      child: TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
            color: btnColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          height: 35,
          width: MediaQuery.of(context).size.width * 0.5,
          child: Text(
            text,
            style: TextStyle(color: txtColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
