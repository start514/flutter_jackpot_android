import 'package:flutterjackpot/controller/base_model.dart';
import 'package:flutterjackpot/utils/common/common_toast.dart';
import 'package:flutterjackpot/utils/url_utils.dart';

import '../../main.dart';
import 'winners_model.dart';

class WinnerImagesController extends BaseModel {
  Future<GetWinnersImagesModel> getWinnerImagesAPI() async {
    onNotify(status: Status.LOADING, message: "Loading");

    try {
      dynamic response = await net.getWithDio(url: UrlGetWinnersImages);

      if (response["status"] == 1) {
        GetWinnersImagesModel model = GetWinnersImagesModel.fromJson(response);

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
