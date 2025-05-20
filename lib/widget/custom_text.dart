import 'package:flutter/material.dart';
import 'package:trip/core/constant/assets.dart';

class CustomText extends StatelessWidget {
  final String text;

  final double fontSize;

  final FontWeight fontWeight;

  final Color? color;
  final TextDecoration? decoration;
  final TextAlign? textAlign;
  final String fontFamily;
  final Alignment? alignment;
  final TextOverflow? textOverflow;

  const CustomText({
    super.key,
    this.text = '',
    this.fontSize = 18,
    this.color,
    this.fontWeight = FontWeight.w500,
    this.decoration,
    this.textAlign,
    this.fontFamily = Assets.fontMontserrat,
    this.alignment,
    this.textOverflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: textOverflow,
    
      style: TextStyle(
        decoration: decoration,
        height: 1.3,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        color: color,
        
      ),
    );
  }
}
