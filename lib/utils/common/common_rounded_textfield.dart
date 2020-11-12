import 'package:flutter/material.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';

class RoundedTextField extends StatelessWidget {
  final double topRight;
  final double bottomRight;
  final double topLeft;
  final double bottomLeft;
  final String hintText;

//  final String labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool enabled;
  final GestureTapCallback onTap;

  RoundedTextField({
    this.topRight,
    this.bottomRight,
    this.hintText,
//    this.labelText,
    this.keyboardType,
    this.obscureText,
    this.controller,
    this.onTap,
    this.enabled,
    this.topLeft,
    this.bottomLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Container(
            width: double.infinity,
            child: Material(
              elevation: 2.0,
              color: blackColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    left: 15.0, right: 10.0, top: 5.0, bottom: 5.0),
                child: TextFormField(
                  style: TextStyle(
                    color: whiteColor,
                  ),
                  controller: controller,
                  obscureText: obscureText != null ? obscureText : false,
                  onTap: onTap,
                  enabled: enabled,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: TextStyle(color: greyColor, fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ),
        /*  Padding(
          padding: EdgeInsets.only(right: 15.0, bottom: 15.0),
          child: Text(
            labelText,
            style: TextStyle(fontSize: 16, color: Color(0xFF999A9A)),
          ),
        ),*/
      ],
    );
  }
}
