import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  final title;
  const InputBox({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black26),
        borderRadius: BorderRadius.all(Radius.circular(10),),
      ),
      child: TextField(
        decoration: InputDecoration(
            hintText: title,
            hintStyle: TextStyle(fontSize: 14),
            border: InputBorder.none
        ),
      ),
    );
  }
}