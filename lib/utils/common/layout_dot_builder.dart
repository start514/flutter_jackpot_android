import 'package:flutter/material.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
 
Widget layoutBuilderDot(Color color, {double? size}) {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      final boxWidth = constraints.constrainWidth();
      double dashWidth = size == null ? 2.0 : size;
      double dashHeight = size == null ? 2.0 : size;
      final dashCount = (boxWidth / 16).floor();
      return Flex(
        children: List.generate(
          dashCount,
          (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight, 
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            );
          },
        ),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        direction: Axis.horizontal,
      );
    },
  );
}

Widget layoutBuilderLine(Color color) {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        height: 0,
        decoration: BoxDecoration(
          // color: whiteColor,
          border: Border.all(
            color: whiteColor,
            width: 1,
          ),
        ),
      );
    },
  );
}
