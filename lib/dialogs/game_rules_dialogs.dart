import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_categories_controller.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_trivia_categories_model.dart';

class GameRulesDialog extends StatefulWidget {
  final List<Categories> categories;

  GameRulesDialog(this.categories);

  @override
  _GameRulesDialogState createState() =>
      _GameRulesDialogState();
}

class _GameRulesDialogState extends State<GameRulesDialog> {

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
        height: 350.0,
        margin: EdgeInsets.all(17.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Game rules 👇\nApple is NOT a sponsor or in any way affiliated with any of Trivia Stax’s promotions.\n\nTHERE IS NO PURCHASE, PAYMENT, OR WAGER OF ANY TYPE REQUIRED TO PLAY OR WIN IN ANY OF OUR QUIZZES! ALL PLAY IS FREE!\n\nGame Rules\n-Quizzes have 10 questions each with 15 seconds to answer each question.\n-Faster answers equal higher scores.\n-Bonus points for 6 or more correct answers.\n-Each quiz has its own official end date.\n-When a quiz officially ends the user in first place will win the prize. In the event of a tie it will be split amongst those users.\n-Any malfunctions or detectable cheating will void any rewards or prizes.\n-Quizzes will be active anywhere from 1 through 4 weeks. \n-Quizzes end at 11:59 CMT on the listed official end date. Winners can be found in the winners section of the app after a Quiz has ended.\n-Users May contact us for any questions, comments, or concerns at support@trivstax.com",
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
