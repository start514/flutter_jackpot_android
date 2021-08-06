import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_categories_controller.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_trivia_categories_model.dart';

class StreakRulesDialog extends StatefulWidget {
  StreakRulesDialog();

  @override
  _StreakRulesDialogState createState() =>
      _StreakRulesDialogState();
}

class _StreakRulesDialogState extends State<StreakRulesDialog> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        // height: 350.0,
        margin: EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "THERE IS NO PURCHASE, PAYMENT, OR WAGER OF ANY TYPE REQUIRED TO PLAY OR WIN IN ANY OF OUR CONTESTS!\n\nCONTEST RUNS MONTHLY FROM 12:01 ON THE FIRST DAY OF THE MONTH AND RUNS UNTIL 11:59 PM THE LAST DAY OF THE MONTH.\n\nUSER STARTS WITH 5 ENTRIES DAILY, ENTRY RENEWS EVERY 2 HRS\nPICK A CATEGORY AND ANSWER QUESTION WITHIN 10 SECONDS.\nCORRECT ANSWER ADDS +1 TO YOUR CURRENT STREAK.\nWRONG ANSWERS RESET YOUR STREAK TO ZERO.\n1ST 2ND & 3RD HIGHEST STREAKS WIN THE CASH PRIZES.\nIN THE EVENT OF A TIE JACKPOT WILL BE SPLIT EVENLY.\nA USER CAN ONLY WIN 1 OF THE 3 PLACED JACKPOTS.\nTHERE ARE NO POWERUPS IN TRIVIA STREAK.\n\nANY MALFUNCTIONS, DETECTABLE CHEATING, OR BOT ACTIVITY WILL VOID USERS WIN AND COULD RESULT IN A BANNED ACCOUNT.\n\nA USER WHO MISSES A QUESTION WILL HAVE UP TO 3 CHANCES TO “SAVE THEIR STREAK” BY PURCHASING A REDO AFTER AN INCORRECT ANSWER. NO MORE THAN 3 REDO’S CAN BE PURCHASED WITHIN 1 STREAK.\n\nSTREAK DOES NOT HAVE TO BE CURRENT TO WIN. IF USERS BEST STREAK RETAINS THE LEAD THAT USER WILL WIN THE JACKPOT.\n\nWINNERS WILL RECEIVE A CONFIRMATION EMAIL WITHIN 24 HOURS OF CONTEST END DATE!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: blackColor,
                    fontSize: 16,
                  ),         
                ),    
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _getCategoriesByQuiz(String id) {
    Navigator.pop(context, id);
  }
}
