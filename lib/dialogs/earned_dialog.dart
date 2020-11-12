import 'package:flutter/material.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/view/give_aways/giveaways_details_model.dart';

class EarnedDialog extends StatefulWidget {
  final GiveAWaysDetailsModelRecord details;
  final bool isEntry;

  EarnedDialog({this.details, this.isEntry});

  @override
  _EarnedDialogState createState() => _EarnedDialogState();
}

class _EarnedDialogState extends State<EarnedDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: blackColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: blackColor,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          height: 250.0,
          decoration: BoxDecoration(
            color: blackColor,
            border: Border.all(
              color: greenColor,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Congratulations",
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Text(
                  "You have earned",
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 22.0),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border.all(
                      color: greenColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(36.0),
                  ),
                  child: Text(
                    widget.isEntry
                        ? "1 ENTRIES"
                        : "${widget.details.task[0].entry} ENTRIES",
                    style: TextStyle(
                      fontSize: 16,
                      color: blackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: RaisedButton(
                          color: greenColor,
                          textColor: blackColor,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: blackColor),
                            borderRadius: BorderRadius.circular(29.5),
                          ),
                          child: Text(
                            "Done",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: RaisedButton(
                          color: greenColor,
                          textColor: blackColor,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: blackColor),
                            borderRadius: BorderRadius.circular(29.5),
                          ),
                          child: Text(
                            "Enter again!",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
