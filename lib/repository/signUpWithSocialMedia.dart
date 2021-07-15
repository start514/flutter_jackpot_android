import 'dart:convert';
import 'package:flutterjackpot/utils/common/shared_preferences.dart';
import 'package:flutterjackpot/utils/url_utils.dart';
import 'package:flutterjackpot/view/login_signUp/login_signup_model.dart';
import '../main.dart';

/* ---------- check login validation api  -------------- */
class LoginWithSocialRepository {
  static Future<bool> loginWithSocial(
      {String? name, String? emailId, String? token, required bool isFbSignUp}) async {
    print('Login with social details func. call');

    Map<String, dynamic> body = {};
    if (isFbSignUp) {
      body.addAll({
        "name": name,
        "email": emailId,
        "fb_token": token,
      });
    } else {
      body.addAll({
        "name": name,
        "email": emailId,
        "email_token": token,
      });
    }
    dynamic result =
        await net.postWithDio(url: UrlSignUpWithSocial, body: body);

    if (result["status"] == 1) {
      LoginSignUpModel model = LoginSignUpModel.fromJson(result);
      userRecord = model.userRecord;
      spinDetails = model.userRecord!.loginSpinDetails;

      await Preferences.setString(
        Preferences.pfUserLogin,
        json.encode(result),
      );
      return true;
    } else {
      return false;
    }
  }
}
