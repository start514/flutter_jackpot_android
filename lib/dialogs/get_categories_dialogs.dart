import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_categories_controller.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_trivia_categories_model.dart';

class GetCategoriesDialog extends StatefulWidget {
  final List<Categories>? categories;

  GetCategoriesDialog(this.categories);

  @override
  _GetCategoriesDialogState createState() =>
      _GetCategoriesDialogState();
}

class _GetCategoriesDialogState extends State<GetCategoriesDialog> {
  JackpotCategoriesAndQuizController jackpotCategoriesAndQuizController =
      new JackpotCategoriesAndQuizController();

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.categories!.length,
                itemBuilder: (context, index) {
                  Categories _categories = widget.categories![index];

                  return InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: AutoSizeText(
                        _categories.name!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      _getCategoriesByQuiz(_categories.id);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getCategoriesByQuiz(String? id) {
    Navigator.pop(context, id);
  }
}
