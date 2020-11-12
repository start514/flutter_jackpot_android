import 'dart:convert';

import 'package:flutterjackpot/controller/base_model.dart';
import 'package:flutterjackpot/main.dart';
import 'package:flutterjackpot/utils/common/common_toast.dart';
import 'package:flutterjackpot/utils/common/shared_preferences.dart';
import 'package:flutterjackpot/utils/url_utils.dart';
import 'package:flutterjackpot/view/login_signUp/login_signup_model.dart';

class SendSpinRewardController extends BaseModel {
  Future<bool> sendSpinRewardAPI({String item, String count}) async {
    onNotify(status: Status.LOADING, message: "Loading");

    try {
      Map<String, dynamic> body = {
        "price_type": item,
        "count": count,
        "user_id": userRecord.userID,
      };
      dynamic response =
          await net.postWithDio(url: UrlAddSpinPrice, body: body);

      if (response["status"] == 1) {
        LoginSignUpModel model = LoginSignUpModel.fromJson(response);
        userRecord = model.userRecord;
        spinDetails = model.userRecord.loginSpinDetails;

        await Preferences.setString(
          Preferences.pfUserLogin,
          json.encode(response),
        );

        onNotify(status: Status.SUCCESS, message: response['message']);
        return true;
      } else {
        Common.showErrorToastMsg(response['message']);
        onNotify(status: Status.FAILED, message: response['message']);
      }
    } catch (error, st) {
      print(st);
      onNotify(status: Status.FAILED, message: handleError(error));
      print("SPIN CATCH ERROR : $error");
    }
    return false;
  }
}
