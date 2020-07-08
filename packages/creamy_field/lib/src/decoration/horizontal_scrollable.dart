import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HorizontalScrollable extends StatelessWidget {
  final bool beScrollable;
  final Widget child;
  final ScrollController scrollController;
  final ScrollPhysics physics;
  final double horizontalScrollExtent;
  final bool useExpanded;

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
      this.padding,
      this.useExpanded})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!beScrollable) return child;
    // widget.padding
    Widget _scrollable = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: scrollController,
      physics: physics ?? const ClampingScrollPhysics(),
      dragStartBehavior: DragStartBehavior.down,
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(
          width: horizontalScrollExtent ?? 2000,
        ),
        child: child,
      ),
    );
    if (!useExpanded) return _scrollable;
    return Expanded(
      child: _scrollable,
    );
  }
}
