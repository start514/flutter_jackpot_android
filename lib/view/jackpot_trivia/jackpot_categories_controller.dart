import 'package:flutterjackpot/controller/base_model.dart';
import 'package:flutterjackpot/main.dart';
import 'package:flutterjackpot/utils/url_utils.dart';
import 'package:flutterjackpot/view/jackpot_trivia/get_quiz_model.dart';
import 'package:flutterjackpot/view/jackpot_trivia/jackpot_trivia_categories_model.dart';

class JackpotCategoriesAndQuizController extends BaseModel {
  Future<List<Categories>> getCategories() async {
    onNotify(status: Status.LOADING, message: "Loading");

    try {
      dynamic response = await net.getWithDio(url: UrlGetCategories);

      if (response['status'] == 1) {
        JackpotTriviaCategories model =
            JackpotTriviaCategories.fromJson(response);

        onNotify(status: Status.SUCCESS, message: response['message']);

        return model.categories;
      } else {
        onNotify(status: Status.FAILED, message: response['message']);
      }
    } catch (error, gg) {
      print("CATCH ERROR : $error $gg");
      onNotify(status: Status.FAILED, message: handleError(error));
    }
    return null;
  }

//==============================================================================

  Future<List<Quiz>> getQuiz({String categoryID}) async {
    onNotify(status: Status.LOADING, message: "Loading");

    try {
      Map<String, dynamic> body = {
        "category_id": categoryID != null ? categoryID : "0",
      };

      dynamic response = await net.getWithDio(url: UrlGetQuiz, body: body);

      if (response['status'] == 1) {
        GetQuiz model = GetQuiz.fromJson(response);

        onNotify(status: Status.SUCCESS, message: response['message']);

        return model.quiz;
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
