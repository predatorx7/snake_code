import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Makes the child horizontally scrollable
class HorizontalScrollable extends StatelessWidget {
  /// Scrolling horizontally would be only enabled if this value is true
  final bool beScrollable;

  final Widget? child;

  final ScrollController? scrollController;

  /// In the future, this controller from a child TextField will be used to determine horizontal scroll extent.
  final TextEditingController? textEditingController;

  final ScrollPhysics physics;

  /// How much this widget should get horizontally scrolled.
  /// Defaults to 2000
  // TODO: Change this static value with the calculation horizontal scroll extent based on the pixel length of text of the longest line in textField.
  final double horizontalScrollExtent;

  /// Wrap with Expanded widget
  final bool expand;

  /// Scroll padding of the text field under this scrollable
  /// defaults to `EdgeInsets.zero`
  final EdgeInsetsGeometry padding;

  /// Makes the child horizontally scrollable
  const HorizontalScrollable({
    Key? key,
    this.textEditingController,
    this.scrollController,
    this.physics = const ClampingScrollPhysics(),
    this.child,
    this.beScrollable = true,
    this.horizontalScrollExtent = 2000,
    this.padding = EdgeInsets.zero,
    this.expand = false,
  })  : assert(horizontalScrollExtent > 0,
            'horizontal scroll extent should not be less than 1'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!beScrollable) return child!;

    final _scrollable = SingleChildScrollView(
      padding: padding,
      scrollDirection: Axis.horizontal,
      controller: scrollController,
      physics: physics,
      dragStartBehavior: DragStartBehavior.down,
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(
          width: horizontalScrollExtent,
        ),
        child: child,
      ),
    );

    if (!expand) return _scrollable;

    return Expanded(
      child: _scrollable,
    );
  }
}
