import 'package:flutter/material.dart';
import 'package:flutterjackpot/main.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';

Widget roundLevel() {
  return Column(children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          userRecord!.name != null ? "${userRecord!.name}" : "",
          style: TextStyle(
              fontSize: 28, color: whiteColor, fontWeight: FontWeight.bold),
        ),
        Text(
          "Points-765,876",
          style: TextStyle(
              fontSize: 28, color: whiteColor, fontWeight: FontWeight.bold),
        ),
      ],
    ),
    SizedBox(
      height: 10.0,
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          children: <Widget>[
            _detailButton(
                text: "5", image: "bomb.png", size: 60), //spinDetails!.theBomb!
            _detailButton(
                text: "6",
                image: "player2.png",
                bottom: true,
                size: 50), //spinDetails!.thePlayer!,
            _detailButton(
                text: "6",
                image: "clock.png",
                bottom: true,
                size: 50), //spinDetails!.theTime!,
          ],
        ),
      ],
    ),
  ]);
}

Widget _detailButton(
    {String? image,
    required String text,
    required double size,
    bool? bottom,
    void onTap()?}) {
  return InkWell(
    child: Stack(
      children: <Widget>[
        Container(
          margin:
              EdgeInsets.only(top: 18.0, bottom: 8.0, right: 8.0, left: 8.0),
          width: 100,
          padding: EdgeInsets.only(top: 4.0, bottom: 4, right: 1, left: 40),
          decoration: BoxDecoration(
            color: whiteColor,
            border: Border.all(
              color: blackColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              color: blackColor,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            margin: EdgeInsets.only(top: bottom != true ? 4.0 : 14, left: 5.0),
            child: Image.asset(
              "assets/$image",
              height: size,
              width: size,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    ),
    onTap: () {
      onTap!();
    },
  );
}
