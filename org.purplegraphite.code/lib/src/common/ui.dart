import 'package:flutter/material.dart';

class Corners {
  /// The border radius of Card & Material widgets in this application.
  ///
  /// The value is same as [BorderRadius.circular(25.0)].
  static const BorderRadius borderRadius =
      const BorderRadius.all(Radius.circular(25.0));
  static const ShapeBorder outlinedShapeBorder = RoundedRectangleBorder(
    side: BorderSide(
      color: Colors.black,
      width: 2,
    ),
    borderRadius: const BorderRadius.all(
      Radius.circular(25),
    ),
  );
}
