import 'package:flutter/material.dart';

class HorizontalScrollable extends StatelessWidget {
  final bool beScrollable;
  final Widget child;
  final ScrollController scrollController;
  final ScrollPhysics physics;
  final double horizontalScrollExtent;

  /// Scroll padding of the text field under this scrollable
  /// defaults to `const EdgeInsets.only(left: 4)`
  final EdgeInsetsGeometry padding;

  const HorizontalScrollable(
      {Key key,
      this.scrollController,
      this.physics,
      this.child,
      this.beScrollable = true,
      this.horizontalScrollExtent = 2000,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!beScrollable) return child;
    return Expanded(
      child: Padding(
        padding: padding ?? const EdgeInsets.only(left: 4),
        // To make child scrollable
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          physics: physics ?? const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(
              width: horizontalScrollExtent ?? 2000,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
