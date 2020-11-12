import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';

class CarBrandDialog extends StatefulWidget {
  @override
  _CarBrandDialogState createState() => _CarBrandDialogState();
}

class _CarBrandDialogState extends State<CarBrandDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22.0),
      ),
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(""),
            ],
          ),
        ),
      ),
    );
  }
}
