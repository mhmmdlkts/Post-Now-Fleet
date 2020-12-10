import 'package:flutter/material.dart';
import 'package:post_now_fleet/decoration/my_colors.dart';

class CustomButton1 extends StatelessWidget {
  Color color;
  final bool isActive;
  final Color textColor;
  final double borderRadius;
  final double margin;
  final double padding;
  final VoidCallback onTap;
  final String text;
  final IconData icon;

  CustomButton1({this.isActive = true, this.color, this.textColor = Colors.white, this.borderRadius = 10,  this.margin = 10,  this.padding = 10, this.onTap, this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    if (color == null)
      color = primaryBlue;
    BorderRadius radius = BorderRadius.all(Radius.circular(borderRadius));
    return Container(
      margin: EdgeInsets.all(margin),
      child: Material(
        borderRadius: radius,
        color: color.withOpacity(isActive?1:0.5),
        child: InkWell(
          borderRadius: radius,
          onTap: isActive?onTap:null,
          child: Container(
            padding: EdgeInsets.all(padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon==null?Container():Row(
                  children: [
                    Icon(icon, color: textColor,),
                    Container(width: 10,),
                  ],
                ),
                Text(text, style: TextStyle(color: textColor),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}