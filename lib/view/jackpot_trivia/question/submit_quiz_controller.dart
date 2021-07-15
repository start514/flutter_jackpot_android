import 'dart:convert';

import 'package:flutterjackpot/controller/base_model.dart';
import 'package:flutterjackpot/main.dart';
import 'package:flutterjackpot/utils/url_utils.dart';
import 'package:flutterjackpot/view/jackpot_trivia/get_quiz_model.dart';
import 'package:flutterjackpot/view/jackpot_trivia/question/questions_model.dart';
import 'package:flutterjackpot/view/jackpot_trivia/question/submit_quiz_model.dart';
import 'package:intl/intl.dart';

class SubmitQuizController extends BaseModel {
  Future<SubmitQuiz?> submitQuiz(
      List<Record> list, Quiz quiz, int bonus) async {
    onNotify(status: Status.LOADING, message: "Loading");

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyy-MM-dd hh:mm').format(now);

    print(" DATETIME ======= $formattedDate");

    try {
      final List<Record> records = [];
      list.forEach((element) {
        if (element.finalSelectAnswerIsTrue) {
          records.add(element);
        }
      });

      String value = json.encode(
        List<dynamic>.from(records.map((x) => x.toSubmit())),
      );

      Map<String, String?> body = {
        "quiz_id": quiz.id,
        "user_id": userRecord!.userID,
        "date_time": formattedDate,
        "bonus": bonus.toString(),
        "records": value,
      };

      dynamic response = await net.postWithDio(url: UrlSubmitQuiz, body: body);

      if (response['status'] == 1) {
        SubmitQuiz model = SubmitQuiz.fromJson(response);

        onNotify(status: Status.SUCCESS, message: response['message']);
        return model;
      } else {
        onNotify(status: Status.FAILED, message: response['message']);
      }
    } catch (error, gg) {
      print("CATCH ERROR : $error $gg");
      onNotify(status: Status.FAILED, message: handleError(error));
    }
    return null;
  }
}
