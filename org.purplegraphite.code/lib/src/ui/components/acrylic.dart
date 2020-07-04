import 'dart:ui';

import 'package:flutter/material.dart' show Colors, Theme;
import 'package:flutter/widgets.dart';

/// Adds acrylic glass-like effect to child.
class Acrylic extends StatelessWidget {
  /// Acrylic effect is only applied to this child
  final Widget child;
  final bool enabled;
  final bool isDark;
  final double blurIntensity;

  /// Changes theme's canvas color
  final Widget Function(BuildContext, Widget) builder;
  const Acrylic({
    @required this.child,
    Key key,
    this.builder,
    this.enabled = true,
    this.isDark,
    this.blurIntensity = 5.0,
  })  : assert(child != null, 'child should not be null'),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    final Widget acrylicEnabledchild = BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blurIntensity, sigmaY: blurIntensity),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(isDark ? 0.25 : 0.5),
        ),
        child: child,
      ),
    );
    if (builder != null) {
      return Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Theme.of(context).canvasColor.withAlpha(0x44),
        ),
        child: builder(context, acrylicEnabledchild),
      );
    }
    return acrylicEnabledchild;
  }
}
