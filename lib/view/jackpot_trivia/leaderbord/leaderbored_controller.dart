import 'package:flutterjackpot/controller/base_model.dart';
import 'package:flutterjackpot/main.dart';
import 'package:flutterjackpot/utils/url_utils.dart';
import 'package:flutterjackpot/view/jackpot_trivia/get_quiz_model.dart';
import 'package:flutterjackpot/view/jackpot_trivia/leaderbord/leaderbord_model.dart';

class GetLeaderBordController extends BaseModel {
  Future<List<LeaderBordRecord>> getLeaderBordAPI(Quiz quiz) async {
    onNotify(status: Status.LOADING, message: "Loading");

    try {
      Map<String, String> body = {
        "quiz_id": quiz.id,
      };

      dynamic response =
          await net.getWithDio(url: UrlGetLeaderBoard, body: body);

      if (response['status'] == 1) {
        LeaderBordModel model = LeaderBordModel.fromJson(response);

        onNotify(status: Status.SUCCESS, message: response['message']);
        return model.leaderBordRecord;
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
