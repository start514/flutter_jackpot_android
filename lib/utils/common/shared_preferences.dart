import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static final String pfUserLogin = "login";
  static final String pfTapSpin = "spin";
  static final String pfKConsumableId = "KConsumableId";
  static final String pfKConsumableIdNoads = "KConsumableIdNoads";
  static final String pfkConsumableIdPowerUpOne = "kConsumableIdPowerUpOne";
  static final String pfkConsumableIdPowerUpTwo = "kConsumableIdPowerUpTwo";
  static final String pfkConsumableIdPowerUpThree = "kConsumableIdPowerUpThree";
  static final String pfKConsumableIdLife = "KConsumableIdLife";
  static final String pfKLastLifeConsumeDate = "KLastLifeConsumeDate";
  static final String pfKStreakCategories = "KStreakCategories";
  static final String pfKStreakCategoriesTime = "KStreakCategoriesTime";
  static final String pfKStreakCategoryLock = "KStreakCategoryLock";
  static final String pfKStreakCategorySecondRow = "KStreakCategorySecondRow";
  static final String pfKStreakCategorySecondRowDate =
      "KStreakCategorySecondRowDate";
  static final String pfKStreakADShuffleCount = "KStreakADShuffleCount";
  static final String pfKStreakADShuffleDate = "KStreakADShuffleDate";

  static Future<bool> setString(String key, String data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, data);
  }

  static Future<String?> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}
