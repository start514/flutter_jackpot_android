import 'package:flutterjackpot/controller/base_model.dart';
import 'package:flutterjackpot/main.dart';
import 'package:flutterjackpot/utils/url_utils.dart';

class SendSpinRewardController extends BaseModel {
  Future<bool> addFreebie({int? type}) async {
    onNotify(status: Status.LOADING, message: "Loading");

    try {
      Map<String, dynamic> body = {
        "type": type,
        "user_id": userRecord!.userID,
      };
      dynamic response = await net.getWithDio(url: UrlAddFreebie, body: body);

      if (response == true) {
        return true;
      } else {}
    } catch (error, st) {
      print(st);
    }
    return false;
  }
}
