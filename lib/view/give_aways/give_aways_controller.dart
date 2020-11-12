import 'package:flutterjackpot/controller/base_model.dart';
import 'package:flutterjackpot/main.dart';
import 'package:flutterjackpot/utils/common/common_toast.dart';
import 'package:flutterjackpot/utils/url_utils.dart';
import 'package:flutterjackpot/view/give_aways/give_aways_model_class.dart';
import 'package:flutterjackpot/view/give_aways/giveaways_details_model.dart';

class GiveAWaysController extends BaseModel {
  Future<List<GiveAWaysRecord>> getAWays(categoryID) async {
    onNotify(status: Status.LOADING, message: "Loading");

    try {
      Map<String, dynamic> body = {
        "category_id": categoryID != null ? categoryID : "0",
      };

      dynamic response = await net.getWithDio(url: UrlGetGiveaways, body: body);

      if (response['status'] == 1) {
        GiveAWaysModel model = GiveAWaysModel.fromJson(response);

        onNotify(status: Status.SUCCESS, message: response['message']);

        return model.giveAWaysRecord;
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

  Future<List<GiveAWaysDetailsModelRecord>> getGiveAWaysDetails(
      {GiveAWaysRecord giveAWaysRecord}) async {
    onNotify(status: Status.LOADING, message: "Loading");

    try {
      Map<String, dynamic> body = {
        "user_id": userRecord.userID,
        "giveaways_id": giveAWaysRecord.id,
      };

      dynamic response =
          await net.getWithDio(url: UrlGetGiveawayDetails, body: body);

      if (response['status'] == 1) {
        GiveAWaysDetailsModel model = GiveAWaysDetailsModel.fromJson(response);

        onNotify(status: Status.SUCCESS, message: response['message']);

        return model.giveADetailsModelRecord;
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

  Future<bool> submitfreeEntryGiveaway({String giveaway_id}) async {
    onNotify(status: Status.LOADING, message: "Loading");

    try {
      Map<String, String> body = {
        "giveaway_id": giveaway_id,
        "user_id": userRecord.userID,
      };

      dynamic response =
      await net.getWithDio(url: UrlfreeEntryGiveaway, body: body);

      if (response["status"] == 1) {
        onNotify(status: Status.SUCCESS, message: response['message']);
        return true;
      } else {
        Common.showErrorToastMsg(response['message']);
        onNotify(status: Status.FAILED, message: response['message']);
      }
    } catch (error, gg) {
      print("CATCH ERROR : $error $gg");
      onNotify(status: Status.FAILED, message: handleError(error));
    }
    return null;
  }
}
