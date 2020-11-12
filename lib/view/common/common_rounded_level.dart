import 'package:flutter/material.dart';
import 'package:flutterjackpot/main.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';

Widget roundLevel() {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: blackColor,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(36.0),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Container(
            width: 55.0,
            height: 55.0,
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.all(Radius.circular(12.0)),
              image: new DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/jackpot_app_icon.png"),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                userRecord.name != null ? "@${userRecord.name}" : "",
                style: TextStyle(
                  color: whiteColor,
                ),
              ),
              Row(
                children: <Widget>[
                  Image.asset(
                    "assets/red_heart.png",
                    height: 30.0,
                    width: 30.0,
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Container(
                    width: 60.0,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      border: Border.all(
                        color: blackColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(36.0),
                    ),
                    child: Text(
                      spinDetails.theHeart,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Image.asset(
                    "assets/coins.png",
                    height: 30.0,
                    width: 30.0,
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Container(
                    width: 60.0,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      border: Border.all(
                        color: blackColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(36.0),
                    ),
                    child: Text(
                      "0",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Level 1",
                style: TextStyle(color: whiteColor),
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Image.asset(
                        "assets/bomb.png",
                        height: 25.0,
                        width: 25.0,
                      ),
                      SizedBox(
                        width: 8.0,
                        height: 3.0,
                      ),
                      Container(
                        width: 40.0,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border.all(
                            color: blackColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(36.0),
                        ),
                        child: Text(
                          spinDetails.theBomb,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          "assets/player2.png",
                          height: 25.0,
                          width: 25.0,
                        ),
                        SizedBox(
                          width: 8.0,
                          height: 3.0,
                        ),
                        Container(
                          width: 40.0,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            border: Border.all(
                              color: blackColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(36.0),
                          ),
                          child: Text(
                            spinDetails.thePlayer,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Image.asset(
                        "assets/clock.png",
                        height: 25.0,
                        width: 25.0,
                      ),
                      SizedBox(
                        width: 8.0,
                        height: 3.0,
                      ),
                      Container(
                        width: 40.0,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border.all(
                            color: blackColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(36.0),
                        ),
                        child: Text(
                          spinDetails.theTime,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
