import 'package:flutterjackpot/controller/base_model.dart';
import 'package:flutterjackpot/main.dart';
import 'package:flutterjackpot/utils/url_utils.dart';
import 'package:flutterjackpot/view/trivia_streak/get_streak_model.dart';
import 'package:flutterjackpot/view/trivia_streak/submit_streak_model.dart';

class TriviaStreakController extends BaseModel {
  Future<GetStreak?> getStreak({String? userID}) async {
    onNotify(status: Status.LOADING, message: "Loading");

    try {
      Map<String, dynamic> body = {
        "user_id": userID != null ? userID : "0",
      };
      dynamic response = await net.getWithDio(url: UrlGetStreak, body: body);

      if (response['status'] == 1) {
        GetStreak model = GetStreak.fromJson(response);

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

  Future<SubmitStreakResponse?> submitStreak(
      {String? userID, int? score}) async {
    onNotify(status: Status.LOADING, message: "Loading");

    try {
      Map<String, dynamic> body = {
        "user_id": userID != null ? userID : "0",
        "score": score != null ? score : 0,
      };
      dynamic response = await net.getWithDio(url: UrlSubmitStreak, body: body);

      if (response['status'] == 1) {
        SubmitStreakResponse model = SubmitStreakResponse.fromJson(response);

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

  Future<void> continueStreak(String? userID, int originalScore) async {
    onNotify(status: Status.LOADING, message: "Loading");

    try {
      Map<String, dynamic> body = {
        "user_id": userID != null ? userID : "0",
        "score": originalScore,
      };
      dynamic response =
          await net.getWithDio(url: UrlContinueStreak, body: body);

      if (response['status'] == 1) {
        onNotify(status: Status.SUCCESS, message: response['message']);
        return;
      } else {
        onNotify(status: Status.FAILED, message: response['message']);
      }
    } catch (error, gg) {
      print("CATCH ERROR : $error $gg");
      onNotify(status: Status.FAILED, message: handleError(error));
    }
  }
}
