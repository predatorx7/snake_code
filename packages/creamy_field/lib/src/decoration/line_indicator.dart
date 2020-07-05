import 'package:flutter/material.dart';

class LineCountIndicatorDecoration {
  /// width of this widget
  final double width;

  /// Text style of line indicator
  ///
  /// To change text color, use [textColor] argument
  final TextStyle textStyle;

  /// Text color
  ///
  /// Overrides the [textStyle]'s color,
  /// defaults to [Colors.white]
  final Color textColor;

  /// Line background color
  final Color backgroundColor;

  /// Determines the physics of a this widget.
  /// defaults to [ClampingScrollPhysics]
  final ScrollPhysics scrollPhysics;

  final BorderSide rightBorderSide;

  final AlignmentGeometry alignment;

  const LineCountIndicatorDecoration({
    this.width,
    this.textStyle,
    this.textColor,
    this.backgroundColor,
    this.scrollPhysics,
    this.rightBorderSide,
    this.alignment,
  });

  LineCountIndicatorDecoration merge(LineCountIndicatorDecoration other) {
    return LineCountIndicatorDecoration(
      width: other?.width ?? this.width,
      textStyle: other?.textStyle ?? this.textStyle,
      textColor: other?.textColor ?? this.textColor,
      backgroundColor: other?.backgroundColor ?? this.backgroundColor,
      scrollPhysics: other?.scrollPhysics ?? this.scrollPhysics,
      rightBorderSide: other?.rightBorderSide ?? this.rightBorderSide,
      alignment: other?.alignment ?? this.alignment,
    );
  }
}

/// A horizontal widget with lists of indexes to represent
/// adjacent TextField's line number.
///
/// Note: This widget being StatefulWidget could've been avoided if we
/// use it in rich editable code, but in that case it'd be dependant
/// on parent state's provided logic
class LineCountIndicator extends StatefulWidget {
  /// Keep Line indicator visible
  final bool visible;

  /// The child this wraps to show line indicator adjacent
  final Widget child;

  /// Text Field's scroll controller. Do not provide a new scroll controller
  /// for this widget
  final ScrollController scrollController;

  /// Number of lines in text
  ///
  /// Can be obtained with a simple logic
  /// ```dart
  /// lineCount = '\n'.allMatches(yourTextController.text).length + 1;
  /// ```
  final int lineCount;

  final LineCountIndicatorDecoration decoration;

  /// Creates a Line count indicator which can be kept
  /// adjacent (preferably left) of a Text Field.
  const LineCountIndicator({
    @required this.scrollController,
    @required this.lineCount,
    @required this.decoration,
    this.visible = true,
    this.child,
    Key key,
  })  : assert(child != null),
        assert(scrollController != null,
            'Scroll controller of Text field is required to keep this widget\'s scroll in sync with the Text field'),
        super(key: key);

  @override
  _LineCountIndicatorState createState() => _LineCountIndicatorState();
}

class _LineCountIndicatorState extends State<LineCountIndicator>
    with WidgetsBindingObserver {
  double latestBottomViewInset = 0;
  ScrollController lineScrollController;

  void _whenTextFieldScrollControllerChanges() {
    // Changes scroll offset of lineStrip with EditableText
    if (widget.scrollController?.offset != null) {
      lineScrollController.animateTo(
        widget.scrollController.offset,
        // A quick animation
        curve: Curves.decelerate, // _caretAnimationCurve,
        duration: Duration(milliseconds: 1), // _caretAnimationDuration,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    lineScrollController = ScrollController();
    widget.scrollController.addListener(_whenTextFieldScrollControllerChanges);
  }

  @override
  void dispose() {
    lineScrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final double windowViewInsetsBottom =
        WidgetsBinding.instance.window.viewInsets.bottom;
    if (latestBottomViewInset != windowViewInsetsBottom) {
      latestBottomViewInset = windowViewInsetsBottom;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.visible) return widget.child;
    final Color _color = widget?.decoration?.textColor ?? Colors.white;
    final TextStyle _style = (widget?.decoration?.textStyle != null)
        ? widget.decoration.textStyle.copyWith(color: _color)
        : TextStyle(
            fontFamily: 'monospace',
            color: _color,
          );
    final BorderSide effectiveRightBorderSide = BorderSide(
      color: widget?.decoration?.rightBorderSide?.color ??
          Theme.of(context).accentColor,
      width: widget?.decoration?.rightBorderSide?.width ?? 2,
      style: widget?.decoration?.rightBorderSide?.style ?? BorderStyle.solid,
    );
    final int digitsOfMaxLineCount = widget.lineCount.toString().length;
    final double _widthConstraints =
        widget?.decoration?.width ?? (14 * digitsOfMaxLineCount) + 2.0;
    final Widget lineIndicator = IgnorePointer(
      ignoring: true,
      child: Container(
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: widget?.decoration?.backgroundColor ??
              Theme.of(context).accentColor.withAlpha(0x88),
          border: Border(
            right: effectiveRightBorderSide,
          ),
        ),
        constraints: BoxConstraints(
          // Allows width for line number to show wihtout overflowing.
          // Changes with digits of Max number
          maxWidth: _widthConstraints,
          minWidth: _widthConstraints,
        ),
        child: ListView.builder(
          // shrinkWrap: true,
          controller: lineScrollController,
          itemCount: widget.lineCount,
          padding: EdgeInsets.only(
              bottom: latestBottomViewInset ??
                  0), // Adjust bottom padding with view inset (keyboard)
          physics: widget?.decoration?.scrollPhysics ??
              const ClampingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            // A regular TextField in flutter 1.x has a top & bottom padding
            // when it has no text. This workaround keeps this line indicato
            // follow that behaviour.
            final double topBottomPadding = (widget.lineCount == 1) ? 12 : 0;
            final String lineCountText = (index + 1).toString();
            return Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(
                top: topBottomPadding,
                bottom: topBottomPadding,
              ),
              child: Text(
                lineCountText,
                style: _style,
              ),
            );
          },
        ),
      ),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        lineIndicator,
        widget.child,
      ],
    );
  }
}
