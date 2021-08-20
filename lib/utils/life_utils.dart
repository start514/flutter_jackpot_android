import 'dart:math';

import 'package:flutterjackpot/utils/common/shared_preferences.dart';
import 'package:intl/intl.dart';

const LIFE_GENERATION_PERIOD = 900;
const LIFE_DEFAULT = 7;

class LifeClass {
  static int life = LIFE_DEFAULT;
  static DateTime? lastConsumeDate;
  static void showVideoAdd(
      {required void afterVideoEnd(), required bool isSpin}) async {}
  static int getLife() {
    if (lastConsumeDate == null) return life;
    Duration diff = DateTime.now().difference(lastConsumeDate!);
    int generatedLife = (diff.inSeconds / LIFE_GENERATION_PERIOD).floor();
    return min(life + generatedLife, LIFE_DEFAULT);
  }

  static String calcWaitTimer() {
    if (lastConsumeDate == null || getLife() == LIFE_DEFAULT) return "FULL";
    Duration diff = DateTime.now().difference(lastConsumeDate!);
    int wait = diff.inSeconds % LIFE_GENERATION_PERIOD;
    wait = LIFE_GENERATION_PERIOD - wait;
    int hour = (wait / 3600).floor();
    int min = ((wait % 3600) / 60).floor();
    int sec = wait % 60;
    return DateFormat("IN 0$hour:mm:ss")
        .format(new DateTime(2000, 1, 1, hour, min, sec));
  }

  static void init() {
    Preferences.getString(Preferences.pfKConsumableIdLife).then((value) {
      if (value != null && value != "") {
        life = int.parse(value);
      }
    });
    Preferences.getString(Preferences.pfKLastLifeConsumeDate).then((value) {
      if (value != null && value != "") {
        lastConsumeDate = DateTime.parse(value);
      }
    });
  }

  static Future<bool> consumeLife() async {
    int currentLife = getLife();
    if (currentLife == 0) {
      return false;
    }
    currentLife--;
    await Preferences.setString(
        Preferences.pfKConsumableIdLife, currentLife.toString());
    await Preferences.setString(
        Preferences.pfKLastLifeConsumeDate, DateTime.now().toIso8601String());
    life = currentLife;
    lastConsumeDate = DateTime.now();
    return true;
  }

  static Future<void> restoreLife() async {
    int currentLife = LIFE_DEFAULT;
    await Preferences.setString(
        Preferences.pfKConsumableIdLife, currentLife.toString());
    await Preferences.setString(
        Preferences.pfKLastLifeConsumeDate, DateTime.now().toIso8601String());
    life = currentLife;
    lastConsumeDate = DateTime.now();
  }
}
