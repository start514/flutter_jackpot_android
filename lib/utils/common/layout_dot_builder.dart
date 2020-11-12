import 'package:flutter/material.dart';

Widget layoutBuilderDot(Color color) {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      final boxWidth = constraints.constrainWidth();
      final dashWidth = 2.0;
      final dashHeight = 2.5;
      final dashCount = (boxWidth / (8 * dashWidth)).floor();
      return Flex(
        children: List.generate(
          dashCount,
          (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
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
