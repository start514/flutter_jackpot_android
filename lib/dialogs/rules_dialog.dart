import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/view/give_aways/giveaways_details_model.dart';

class RulesDialog extends StatefulWidget {
  final GiveAWaysDetailsModelRecord? details;

  RulesDialog({this.details});

  @override
  _RulesDialogState createState() => _RulesDialogState();
}

class _RulesDialogState extends State<RulesDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        height: 220.0,
        margin: EdgeInsets.all(17.0),
        child: Center(
          child: SingleChildScrollView(
            child: Html(
              data: "${widget.details!.rules}",
              style: {
                "html": Style(
                  textAlign: TextAlign.center,
                  color: blackColor,
                  fontSize: FontSize(16.0),
                  fontWeight: FontWeight.bold,
                ),
              },
            ),
          ),
        ),
      ),
    );
  }
}
