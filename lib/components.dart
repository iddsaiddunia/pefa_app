import 'package:flutter/material.dart';

import 'color_themes.dart';

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
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
      margin: EdgeInsets.symmetric(vertical: 5),
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

class CustomeIconButton extends StatelessWidget {
  final String title;
  final Function() ontap;
  final IconData icon;
  const CustomeIconButton({
    super.key,
    required this.title,
    required this.ontap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          color: color.primaryColor,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}