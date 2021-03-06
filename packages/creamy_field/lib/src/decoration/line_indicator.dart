import 'package:flutter/material.dart';

typedef double WidthBuilderCallback(
  int numberOfLines,
  int digitsOfLastLineNumber,
);

/// The decoration which will be applied to [LineCountIndicator]
///
/// Use the same font-family & font-size you would use in the TextField.
class LineCountIndicatorDecoration {
  /// Calculate the width based on the total number of lines & digits of last line number.
  final WidthBuilderCallback? widthBuilder;

  /// Explicitly specify a line height for each line indicator.
  ///
  /// [lineHeight] value excludes the padding.
  final double? lineHeight;

  /// Text style of line indicator
  ///
  /// To change text color, use [textColor] argument
  final TextStyle? textStyle;

  /// Text color
  ///
  /// Overrides the [textStyle]'s color,
  /// defaults to [Colors.white]
  final Color textColor;

  /// Line background color
  final Color? backgroundColor;

  /// Determines the physics of a this widget.
  /// defaults to [ClampingScrollPhysics]
  final ScrollPhysics scrollPhysics;

  /// Decoration for right border side
  final BorderSide? rightBorderSide;

  /// Alignment of numbers in the Line Indicator Column
  final AlignmentGeometry? alignment;

  /// The padding for the line indicator column.
  final EdgeInsetsGeometry? padding;

  /// The decoration which will be applied to [LineCountIndicator]
  LineCountIndicatorDecoration({
    this.widthBuilder,
    this.textStyle,
    this.textColor = Colors.white,
    this.lineHeight,
    this.backgroundColor,
    this.scrollPhysics = const ClampingScrollPhysics(),
    this.rightBorderSide,
    this.alignment,
    this.padding,
  });

  /// Merge this with other
  LineCountIndicatorDecoration merge(LineCountIndicatorDecoration? other) {
    return LineCountIndicatorDecoration(
      widthBuilder: other?.widthBuilder ?? this.widthBuilder,
      lineHeight: other?.lineHeight ?? this.lineHeight,
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
  /// for this widget. This same scroll controller must be passed to the child TextField.
  final ScrollController scrollControllerOfTextField;

  /// The decoration which will be applied to this widget
  final LineCountIndicatorDecoration decoration;

  /// Number of lines in text will be obtained from this controller
  final TextEditingController textControllerOfTextField;

  /// Creates a Line count indicator Flex which can be kept
  /// adjacent (preferably left) of a Text Field.
  const LineCountIndicator({
    Key? key,
    this.visible = true,
    required this.textControllerOfTextField,
    required this.scrollControllerOfTextField,
    required this.decoration,
    required this.child,
  }) : super(key: key);

  @override
  _LineCountIndicatorState createState() => _LineCountIndicatorState();
}

class _LineCountIndicatorState extends State<LineCountIndicator> {
  @override
  Widget build(BuildContext context) {
    if (!widget.visible) return widget.child;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _LineIndicatorWidget(
          decoration: widget.decoration,
          scrollControllerOfTextField: widget.scrollControllerOfTextField,
          textController: widget.textControllerOfTextField,
        ),
        Expanded(
          child: widget.child,
        ),
      ],
    );
  }
}

class _LineIndicatorWidget extends StatefulWidget {
  /// Text Field's scroll controller. Do not provide a new scroll controller
  /// for this widget. This same scroll controller must be passed to the child TextField.
  final ScrollController scrollControllerOfTextField;

  /// The decoration which will be applied to this widget
  final LineCountIndicatorDecoration decoration;

  /// Number of lines in text will be obtained from this controller
  final TextEditingController textController;

  const _LineIndicatorWidget({
    Key? key,
    required this.textController,
    required this.scrollControllerOfTextField,
    required this.decoration,
  }) : super(key: key);

  @override
  __LineIndicatorWidgetState createState() => __LineIndicatorWidgetState();
}

class __LineIndicatorWidgetState extends State<_LineIndicatorWidget>
    with WidgetsBindingObserver {
  double latestBottomViewInset = 0;
  late ScrollController lineScrollController;

  void _whenTextFieldScrollControllerChanges() {
    // Changes scroll offset of lineStrip with EditableText
    lineScrollController.jumpTo(
      widget.scrollControllerOfTextField.offset,
    );
  }

  @override
  void initState() {
    super.initState();
    lineScrollController = ScrollController();
    widget.scrollControllerOfTextField
        .addListener(_whenTextFieldScrollControllerChanges);
    widget.textController.addListener(updateLines);
  }

  @override
  void dispose() {
    lineScrollController.dispose();
    super.dispose();
  }

  int get totalNumberOfLines {
    return widget.textController.value.text.split('\n').length;
  }

  int get digitsOfLastLineNumber {
    return totalNumberOfLines.toString().length;
  }

  int _lastTotalNumberOfLines = 0;

  void updateLines() {
    final _newTotalNumberOfLines = totalNumberOfLines;
    final didLinesChanged = _lastTotalNumberOfLines != _newTotalNumberOfLines;
    if (didLinesChanged) {
      if (mounted) {
        setState(() {
          _lastTotalNumberOfLines = _newTotalNumberOfLines;
        });
      }
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final double windowViewInsetsBottom =
        WidgetsBinding.instance!.window.viewInsets.bottom;
    if (latestBottomViewInset != windowViewInsetsBottom) {
      latestBottomViewInset = windowViewInsetsBottom;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    TextStyle _style = widget.decoration.textStyle ??
        TextStyle(
          fontFamily: 'monospace',
          color:
              widget.decoration.textStyle?.color ?? widget.decoration.textColor,
        );

    if (_theme.textTheme.subtitle1 != null) {
      _style = _theme.textTheme.subtitle1!.merge(_style);
    }

    final Color _accent = _theme.accentColor;

    final BorderSide effectiveRightBorderSide = BorderSide(
      color: widget.decoration.rightBorderSide?.color ?? _accent,
      width: widget.decoration.rightBorderSide?.width ?? 2,
      style: widget.decoration.rightBorderSide?.style ?? BorderStyle.solid,
    );

    final _fontSize = _style.fontSize ?? 12;

    final double _widthConstraints;

    if (widget.decoration.widthBuilder != null) {
      _widthConstraints = widget.decoration.widthBuilder!(
          totalNumberOfLines, digitsOfLastLineNumber);
    } else {
      final double _approxWidthOfDigit = (_fontSize / 1.6);
      _widthConstraints = (_approxWidthOfDigit * digitsOfLastLineNumber) + 4.0;
    }

    final Alignment _alignment =
        widget.decoration.alignment as Alignment? ?? Alignment.centerRight;

    return IgnorePointer(
      ignoring: true,
      child: Container(
        alignment: _alignment,
        decoration: BoxDecoration(
          color: widget.decoration.backgroundColor ?? _accent.withAlpha(0x88),
          border: Border(
            right: effectiveRightBorderSide,
          ),
        ),
        padding: widget.decoration.padding ?? EdgeInsets.zero,
        constraints: BoxConstraints(
          // Allows width for line number to show wihtout overflowing.
          // Changes with digits of Max number
          maxWidth: _widthConstraints,
          minWidth: _widthConstraints,
        ),
        child: ListView.builder(
          shrinkWrap: false,
          controller: lineScrollController,
          itemCount: totalNumberOfLines,
          padding: EdgeInsets.only(
            // Adjusts bottom padding with view inset (keyboard)
            bottom: latestBottomViewInset,
          ),
          physics: widget.decoration.scrollPhysics,
          itemBuilder: (BuildContext context, int index) {
            final String lineCountText = (index + 1).toString();
            return Container(
              alignment: _alignment,
              height: widget.decoration.lineHeight,
              child: Text(
                lineCountText,
                style: _style,
              ),
            );
          },
        ),
      ),
    );
  }
}
