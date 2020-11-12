import 'package:flutterjackpot/controller/base_model.dart';
import 'package:flutterjackpot/main.dart';
import 'package:flutterjackpot/models/winner_score_model.dart';
import 'package:flutterjackpot/utils/common/common_toast.dart';
import 'package:flutterjackpot/utils/url_utils.dart';

class WinnerScoreController extends BaseModel {
  Future<WinnerScore> getWinnerScoreAPI() async {
    onNotify(status: Status.LOADING, message: "Loading");

    try {
      dynamic response = await net.getWithDio(url: UrlGetWinnerScore);

      if (response["status"] == 1) {
        WinnerScore model = WinnerScore.fromJson(response);

        onNotify(status: Status.SUCCESS, message: response['message']);
        return model;
      } else {
        Common.showErrorToastMsg(response['message']);
        onNotify(status: Status.FAILED, message: response['message']);
      }
    } catch (error, st) {
      print(st);
      onNotify(status: Status.FAILED, message: handleError(error));
      print("CATCH ERROR : $error");
    }
    return null;
  }
}
