import 'package:flutter/material.dart';

/// The decoration which will be applied to [LineCountIndicator]
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

  /// Decoration for right border side
  final BorderSide rightBorderSide;

  /// Alignment of numbers in the Line Indicator Column
  final AlignmentGeometry alignment;

  /// The padding for the line indicator column.
  final EdgeInsetsGeometry padding;

  /// The decoration which will be applied to [LineCountIndicator]
  const LineCountIndicatorDecoration({
    this.width,
    this.textStyle,
    this.textColor,
    this.backgroundColor,
    this.scrollPhysics,
    this.rightBorderSide,
    this.alignment,
    this.padding,
  });

  /// Merge this with other
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
class LineCountIndicator extends StatefulWidget {
  /// Keep Line indicator visible
  final bool visible;

  /// The child this wraps to show line indicator adjacent
  final Widget child;

  /// Text Field's scroll controller. Do not provide a new scroll controller
  /// for this widget
  final ScrollController scrollControllerOfTextField;

  /// The decoration which will be applied to this widget
  final LineCountIndicatorDecoration decoration;

  /// Number of lines in text will be obtained from this controller
  final TextEditingController textController;

  /// Creates a Line count indicator Flex which can be kept
  /// adjacent (preferably left) of a Text Field.
  const LineCountIndicator({
    // @required this.lineCount,
    @required this.decoration,
    @required this.scrollControllerOfTextField,
    this.visible = true,
    this.child,
    Key key,
    this.textController,
  })  : assert(child != null),
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
    if (widget.scrollControllerOfTextField?.offset != null) {
      lineScrollController.jumpTo(
        widget.scrollControllerOfTextField.offset,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    lineScrollController = ScrollController();
    widget.scrollControllerOfTextField
        .addListener(_whenTextFieldScrollControllerChanges);
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

  static double calculateTopBottomPadding(int lineCount) {
    if (lineCount == 1) return 14;
    if (lineCount == 2) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final bool _visible = widget?.visible ?? true;
    if (!_visible) return widget.child;
    final Color _color = widget?.decoration?.textColor ?? Colors.white;
    final TextStyle _style = (widget?.decoration?.textStyle != null)
        ? widget.decoration.textStyle.copyWith(color: _color)
        : TextStyle(
            fontFamily: 'monospace',
            color: _color,
          );
    final ThemeData _theme = Theme.of(context);
    final Color _accent = _theme.accentColor;
    final BorderSide effectiveRightBorderSide = BorderSide(
      color: widget?.decoration?.rightBorderSide?.color ?? _accent,
      width: widget?.decoration?.rightBorderSide?.width ?? 2,
      style: widget?.decoration?.rightBorderSide?.style ?? BorderStyle.solid,
    );
    final int totalLineCount =
        widget.textController.value.text?.split('\n')?.length ?? 0;
    final int digitsOfMaxLineCount = totalLineCount.toString().length;
    final double _widthConstraints =
        widget?.decoration?.width ?? (14 * digitsOfMaxLineCount) + 2.0;
    final double topBottomPadding = calculateTopBottomPadding(totalLineCount);
    final Alignment _alignment =
        widget.decoration.alignment ?? Alignment.centerRight;
    final Widget lineIndicator = IgnorePointer(
      ignoring: true,
      child: Container(
        alignment: _alignment,
        decoration: BoxDecoration(
          color: widget?.decoration?.backgroundColor ?? _accent.withAlpha(0x88),
          border: Border(
            right: effectiveRightBorderSide,
          ),
        ),
        padding: widget?.decoration?.padding ?? EdgeInsets.zero,
        constraints: BoxConstraints(
          // Allows width for line number to show wihtout overflowing.
          // Changes with digits of Max number
          maxWidth: _widthConstraints,
          minWidth: _widthConstraints,
        ),
        child: ListView.builder(
          shrinkWrap: false,
          controller: lineScrollController,
          itemCount: totalLineCount,
          padding: EdgeInsets.only(
            top: topBottomPadding,
            bottom: (latestBottomViewInset ?? 0) + topBottomPadding,
          ), // Adjust bottom padding with view inset (keyboard)
          physics: widget?.decoration?.scrollPhysics ??
              const ClampingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            // A regular TextField in flutter 1.x has a top & bottom padding
            // when it has no text. This workaround keeps this line indicato
            // follow that behaviour.

            final String lineCountText = (index + 1).toString();
            return Container(
              alignment: _alignment,
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
        Expanded(child: widget.child),
      ],
    );
  }
}
