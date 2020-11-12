import 'package:flutter/cupertino.dart';

Widget bgImage(BuildContext context) {
  return Image.asset(
    "assets/background.png",
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    fit: BoxFit.fill,
  );
}
