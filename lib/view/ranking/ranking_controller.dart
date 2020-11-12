import 'package:flutterjackpot/controller/base_model.dart';
import 'package:flutterjackpot/main.dart';
import 'package:flutterjackpot/utils/common/common_toast.dart';
import 'package:flutterjackpot/utils/url_utils.dart';
import 'package:flutterjackpot/view/ranking/ranking_model.dart';

class TopRankerController extends BaseModel {
  Future<List<TopRankerRecord>> topRankerAPI() async {
    onNotify(status: Status.LOADING, message: "Loading");

    try {
      dynamic response = await net.getWithDio(url: UrlGetTop100Ranker);

      if (response["status"] == 1) {
        TopRanker model = TopRanker.fromJson(response);

        onNotify(status: Status.SUCCESS, message: response['message']);
        return model.topRankerRecords;
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
