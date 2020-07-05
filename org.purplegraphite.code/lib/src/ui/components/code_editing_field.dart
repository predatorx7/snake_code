import 'dart:ui' as ui;
import 'package:code/src/models/provider/theme.dart';
import 'package:code/src/ui/components/selection_control.dart'
    show codeSelectionControls;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

export 'package:flutter/services.dart'
    show TextInputType, TextInputAction, TextCapitalization;

class _CodeEditingFieldSelectionGestureDetectorBuilder
    extends TextSelectionGestureDetectorBuilder {
  _CodeEditingFieldSelectionGestureDetectorBuilder({
    @required _CodeEditingFieldState state,
  })  : _state = state,
        super(delegate: state);

  final _CodeEditingFieldState _state;
  @override
  void onForcePressStart(ForcePressDetails details) {
    super.onForcePressStart(details);
    if (delegate.selectionEnabled && shouldShowSelectionToolbar) {
      editableText.showToolbar();
    }
  }

  @override
  void onForcePressEnd(ForcePressDetails details) {
    // Not required.
  }

  @override
  void onSingleLongTapMoveUpdate(LongPressMoveUpdateDetails details) {
    if (delegate.selectionEnabled) {
      switch (Theme.of(_state.context).platform) {
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          renderEditable.selectPositionAt(
            from: details.globalPosition,
            cause: SelectionChangedCause.longPress,
          );
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          renderEditable.selectWordsInRange(
            from: details.globalPosition - details.offsetFromOrigin,
            to: details.globalPosition,
            cause: SelectionChangedCause.longPress,
          );
          break;
      }
    }
  }

  @override
  void onSingleTapUp(TapUpDetails details) {
    editableText.hideToolbar();
    if (delegate.selectionEnabled) {
      switch (Theme.of(_state.context).platform) {
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          renderEditable.selectWordEdge(cause: SelectionChangedCause.tap);
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          renderEditable.selectPosition(cause: SelectionChangedCause.tap);
          break;
      }
    }
    _state._requestKeyboard();
    if (_state.widget.onTap != null) {
      _state.widget.onTap();
    }
  }

  @override
  void onSingleLongTapStart(LongPressStartDetails details) {
    if (delegate.selectionEnabled) {
      switch (Theme.of(_state.context).platform) {
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          renderEditable.selectPositionAt(
            from: details.globalPosition,
            cause: SelectionChangedCause.longPress,
          );
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          renderEditable.selectWord(cause: SelectionChangedCause.longPress);
          Feedback.forLongPress(_state.context);
          break;
      }
    }
  }
}

/// A Code Editing Text Field without Syntax highlighting.
class CodeEditingField extends StatefulWidget {
  /// Creates a text field.
  const CodeEditingField({
    @required this.verticalAxisScrollController,
    Key key,
    this.controller,
    this.focusNode,
    this.strutStyle,
    this.autofocus = false,
    this.minLines,
    this.expands = false,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.enabled,
    this.cursorRadius,
    this.cursorColor,
    this.onTap,
    this.horizontalAxisScrollController,
    this.style,
  })  : assert(expands != null),
        toolbarOptions = const ToolbarOptions(
          copy: true,
          cut: true,
          selectAll: true,
          paste: true,
        ),
        super(key: key);

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController controller;

  /// Defines the keyboard focus for this widget.
  ///
  /// The [focusNode] is a long-lived object that's typically managed by a
  /// [StatefulWidget] parent. See [FocusNode] for more information.
  ///
  /// To give the keyboard focus to this widget, provide a [focusNode] and then
  /// use the current [FocusScope] to request the focus:
  ///
  /// ```dart
  /// FocusScope.of(context).requestFocus(myFocusNode);
  /// ```
  ///
  /// This happens automatically when the widget is tapped.
  ///
  /// To be notified when the widget gains or loses the focus, add a listener
  /// to the [focusNode]:
  ///
  /// ```dart
  /// focusNode.addListener(() { print(myFocusNode.hasFocus); });
  /// ```
  ///
  /// If null, this widget will create its own [FocusNode].
  ///
  /// ## Keyboard
  ///
  /// Requesting the focus will typically cause the keyboard to be shown
  /// if it's not showing already.
  ///
  /// On Android, the user can hide the keyboard - without changing the focus -
  /// with the system back button. They can restore the keyboard's visibility
  /// by tapping on a text field.  The user might hide the keyboard and
  /// switch to a physical keyboard, or they might just need to get it
  /// out of the way for a moment, to expose something it's
  /// obscuring. In this case requesting the focus again will not
  /// cause the focus to change, and will not make the keyboard visible.
  ///
  /// This widget builds an [EditableText] and will ensure that the keyboard is
  /// showing when it is tapped by calling [EditableTextState.requestKeyboard()].
  final FocusNode focusNode;

  /// The style to use for the text being edited.
  ///
  /// This text style is also used as the base style for the [decoration].
  ///
  /// If null, defaults to the `subhead` text style from the current [Theme].
  final TextStyle style;

  /// {@macro flutter.widgets.editableText.strutStyle}
  final StrutStyle strutStyle;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  /// {@macro flutter.widgets.editableText.minLines}
  final int minLines;

  /// {@macro flutter.widgets.editableText.expands}
  final bool expands;

  /// Configuration of toolbar options.
  ///
  /// If not set, select all and paste will default to be enabled. Copy and cut
  /// will be disabled if [obscureText] is true. If [readOnly] is true,
  /// paste and cut will be disabled regardless.
  final ToolbarOptions toolbarOptions;

  /// {@macro flutter.widgets.editableText.cursorColor}
  final Color cursorColor;

  /// {@macro flutter.widgets.editableText.cursorRadius}
  final Radius cursorRadius;

  /// If [maxLength] is set to this value, only the "current input length"
  /// part of the character counter is shown.
  static const int noMaxLength = -1;

  /// {@macro flutter.widgets.editableText.onChanged}
  ///
  /// See also:
  ///
  ///  * [inputFormatters], which are called before [onChanged]
  ///    runs and can validate and change ("format") the input value.
  ///  * [onEditingComplete], [onSubmitted], [onSelectionChanged]:
  ///    which are more specialized input change notifications.
  final ValueChanged<String> onChanged;

  /// {@macro flutter.widgets.editableText.onEditingComplete}
  final VoidCallback onEditingComplete;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  ///
  /// See also:
  ///
  ///  * [EditableText.onSubmitted] for an example of how to handle moving to
  ///    the next/previous field when using [TextInputAction.next] and
  ///    [TextInputAction.previous] for [textInputAction].
  final ValueChanged<String> onSubmitted;

  /// If false the code editing field is "disabled": it ignores taps and its
  /// [decoration] is rendered in grey.
  ///
  /// If non-null this property overrides the [decoration]'s
  /// [Decoration.enabled] property.
  final bool enabled;

  /// {@macro flutter.rendering.editable.selectionEnabled}
  bool get selectionEnabled => true;

  /// {@template flutter.material.textfield.onTap}
  /// Called for each distinct tap except for every second tap of a double tap.
  ///
  /// The text field builds a [GestureDetector] to handle input events like tap,
  /// to trigger focus requests, to move the caret, adjust the selection, etc.
  /// Handling some of those events by wrapping the text field with a competing
  /// GestureDetector is problematic.
  ///
  /// To unconditionally handle taps, without interfering with the text field's
  /// internal gesture detector, provide this callback.
  ///
  /// If the text field is created with [enabled] false, taps will not be
  /// recognized.
  ///
  /// To be notified when the text field gains or loses the focus, provide a
  /// [focusNode] and add a listener to that.
  ///
  /// To listen to arbitrary pointer events without competing with the
  /// text field's internal gesture detector, use a [Listener].
  /// {@endtemplate}
  final GestureTapCallback onTap;

  /// {@macro flutter.widgets.editableText.scrollController}
  final ScrollController verticalAxisScrollController;

  final ScrollController horizontalAxisScrollController;

  @override
  _CodeEditingFieldState createState() => _CodeEditingFieldState();
}

class _CodeEditingFieldState extends State<CodeEditingField>
    implements TextSelectionGestureDetectorBuilderDelegate {
  int lineCount = 0;
  double _lastBottomViewInset;
  ThemeProvider themeProvider;
  TextEditingController _controller;
  TextEditingController get _effectiveController =>
      widget.controller ?? _controller;
  ScrollController _lineIndicatorController;
  // TODO: Make caret follow ThemeStyle
  // static const Duration _caretAnimationDuration = Duration(milliseconds: 100);
  // static const Curve _caretAnimationCurve = Curves.fastOutSlowIn;

  FocusNode _focusNode;
  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());

  bool _isHovering = false;

  bool _showSelectionHandles = false;

  _CodeEditingFieldSelectionGestureDetectorBuilder
      _selectionGestureDetectorBuilder;

  // API for TextSelectionGestureDetectorBuilderDelegate.
  @override
  bool forcePressEnabled;

  @override
  final GlobalKey<EditableTextState> editableTextKey =
      GlobalKey<EditableTextState>();

  @override
  bool get selectionEnabled => widget.selectionEnabled;
  // End of API for TextSelectionGestureDetectorBuilderDelegate.

  bool get _isEnabled => widget.enabled ?? true;

  int get _currentLength => _effectiveController.value.text.runes.length;

  InputDecoration _getEffectiveDecoration() {
    final ThemeData themeData = Theme.of(context);
    final InputDecoration effectiveDecoration =
        const InputDecoration.collapsed(hintText: 'write from here..')
            .applyDefaults(themeData.inputDecorationTheme)
            .copyWith(
              enabled: widget.enabled,
              hintStyle: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white60
                      : null),
            );

    return effectiveDecoration;
  }

  @override
  void initState() {
    super.initState();
    _lineIndicatorController = ScrollController();
    _selectionGestureDetectorBuilder =
        _CodeEditingFieldSelectionGestureDetectorBuilder(state: this);
    if (widget.controller == null) {
      _controller = TextEditingController();
    }
    lineCount = '\n'.allMatches(_effectiveController.text).length + 1;
    _effectiveController.addListener(
      () {
        var _lineCount = '\n'.allMatches(_effectiveController.text).length + 1;
        if (_lineCount != lineCount)
          setState(
            () {
              lineCount = _lineCount;
            },
          );
      },
    );

    _effectiveFocusNode.canRequestFocus = _isEnabled;
    widget.verticalAxisScrollController.addListener(() {
      // Changes scroll offset of lineStrip with EditableText
      if (widget.verticalAxisScrollController?.offset != null)
        _lineIndicatorController.animateTo(
          widget.verticalAxisScrollController.offset,
          // Makes animation quicker
          curve: Curves.easeIn, // _caretAnimationCurve,
          duration: Duration(milliseconds: 1), // _caretAnimationDuration,
        );
    });
  }

  @override
  void didUpdateWidget(CodeEditingField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && oldWidget.controller != null)
      _controller = TextEditingController.fromValue(oldWidget.controller.value);
    else if (widget.controller != null && oldWidget.controller == null)
      _controller = null;
    _effectiveFocusNode.canRequestFocus = _isEnabled;
    if (_effectiveFocusNode.hasFocus) {
      if (_effectiveController.selection.isCollapsed) {
        _showSelectionHandles = true;
      }
    }
    if (_lastBottomViewInset !=
        WidgetsBinding.instance.window.viewInsets.bottom) {
      _lastBottomViewInset = WidgetsBinding.instance.window.viewInsets.bottom;
    }
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    super.dispose();
  }

  EditableTextState get _editableText => editableTextKey.currentState;

  void _requestKeyboard() {
    _editableText?.requestKeyboard();
  }

  bool _shouldShowSelectionHandles(SelectionChangedCause cause) {
    // When the text field is activated by something that doesn't trigger the
    // selection overlay, we shouldn't show the handles either.
    if (!_selectionGestureDetectorBuilder.shouldShowSelectionToolbar)
      return false;

    if (cause == SelectionChangedCause.keyboard) return false;

    if (cause == SelectionChangedCause.longPress) return true;

    if (_effectiveController.text.isNotEmpty) return true;

    return false;
  }

  void _handleSelectionChanged(
      TextSelection selection, SelectionChangedCause cause) {
    final bool willShowSelectionHandles = _shouldShowSelectionHandles(cause);
    if (willShowSelectionHandles != _showSelectionHandles) {
      setState(
        () {
          _showSelectionHandles = willShowSelectionHandles;
        },
      );
    }

    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        if (cause == SelectionChangedCause.longPress) {
          _editableText?.bringIntoView(selection.base);
        }
        return;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      // Do nothing.
    }
  }

  /// Toggle the toolbar when a selection handle is tapped.
  void _handleSelectionHandleTapped() {
    if (_effectiveController.selection.isCollapsed) {
      _editableText.toggleToolbar();
    }
  }

  void _handleHover(bool hovering) {
    if (hovering != _isHovering) {
      setState(() {
        return _isHovering = hovering;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    assert(
      !(widget.style != null &&
          widget.style.inherit == false &&
          (widget.style.fontSize == null || widget.style.textBaseline == null)),
      'inherit false style must supply fontSize and textBaseline',
    );
    final double _widthConstraints = (14 * lineCount.toString().length) + 2.0;
    final ThemeData themeData = Theme.of(context);
    final TextStyle style = themeData.textTheme.subtitle1.merge(widget.style);
    final Brightness keyboardAppearance = themeData.primaryColorBrightness;
    final TextEditingController controller = _effectiveController;
    final FocusNode focusNode = _effectiveFocusNode;
    final List<TextInputFormatter> formatters = <TextInputFormatter>[];

    TextSelectionControls textSelectionControls;
    bool paintCursorAboveText;
    bool cursorOpacityAnimates;
    Offset cursorOffset;
    Color cursorColor = widget.cursorColor;
    Radius cursorRadius = widget.cursorRadius;

    forcePressEnabled = false;
    paintCursorAboveText = false;
    cursorOpacityAnimates = true;
    cursorColor ??= themeData.cursorColor;
    cursorRadius ??= const Radius.circular(2.0);
    textSelectionControls = codeSelectionControls;

    Widget child = RepaintBoundary(
      child: EditableText(
        key: editableTextKey,
        readOnly: false,
        toolbarOptions: widget.toolbarOptions,
        showCursor: true,
        showSelectionHandles: _showSelectionHandles,
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        textCapitalization: TextCapitalization.none,
        style: style,
        strutStyle: widget.strutStyle,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
        autofocus: widget.autofocus,
        obscureText: false,
        autocorrect: true,
        enableSuggestions: true,
        maxLines: null,
        minLines: widget.minLines,
        expands: widget.expands,
        selectionColor: themeData.textSelectionColor,
        selectionControls:
            widget.selectionEnabled ? textSelectionControls : null,
        onChanged: widget.onChanged,
        onSelectionChanged: _handleSelectionChanged,
        onEditingComplete: widget.onEditingComplete,
        onSubmitted: widget.onSubmitted,
        onSelectionHandleTapped: _handleSelectionHandleTapped,
        inputFormatters: formatters,
        rendererIgnoresPointer: true,
        cursorWidth: 2.0,
        cursorRadius: cursorRadius,
        cursorColor: cursorColor,
        cursorOpacityAnimates: cursorOpacityAnimates,
        cursorOffset: cursorOffset,
        paintCursorAboveText: paintCursorAboveText,
        backgroundCursorColor: CupertinoColors.inactiveGray,
        scrollPadding: const EdgeInsets.all(20.0),
        keyboardAppearance: keyboardAppearance,
        enableInteractiveSelection: true,
        dragStartBehavior: DragStartBehavior.start,
        scrollController: widget.verticalAxisScrollController,
        scrollPhysics: const ClampingScrollPhysics(),
        smartDashesType: SmartDashesType.enabled,
        smartQuotesType: SmartQuotesType.enabled,
        selectionHeightStyle: ui.BoxHeightStyle.max,
        selectionWidthStyle: ui.BoxWidthStyle.max,
      ),
    );

    Widget lineIndicator = IgnorePointer(
      ignoring: true,
      child: Container(
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor.withAlpha(0x88),
          border: Border(
            right: BorderSide(
              width: 2,
              color: Theme.of(context).accentColor,
            ),
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
          controller: _lineIndicatorController,
          itemCount: lineCount,
          padding: EdgeInsets.only(
              bottom: _lastBottomViewInset ??
                  0), // Adjust bottom padding with view inset (keyboard)
          physics: const ClampingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            final double topBottomPadding = lineCount == 1 ? 12 : 0;
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                top: topBottomPadding,
                bottom: topBottomPadding,
              ),
              child: Text(
                '${index + 1}',
                style: style.copyWith(color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
    child = AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[
        focusNode,
        controller
      ]), // changes the focus & controller
      builder: (BuildContext context, Widget child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            lineIndicator,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                // To make child scrollable
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: widget.horizontalAxisScrollController,
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.expand(width: 2000),
                    child: InputDecorator(
                      decoration: _getEffectiveDecoration(),
                      baseStyle: widget.style,
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.top,
                      isHovering: _isHovering,
                      isFocused: focusNode.hasFocus,
                      isEmpty: controller.value.text.isEmpty,
                      expands: widget.expands,
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      child: child,
    );

    return IgnorePointer(
      ignoring: !_isEnabled,
      child: MouseRegion(
        onEnter: (PointerEnterEvent event) => _handleHover(true),
        onExit: (PointerExitEvent event) => _handleHover(false),
        child: AnimatedBuilder(
          animation: controller, // changes the _currentLength
          builder: (BuildContext context, Widget child) {
            return Semantics(
              maxValueLength: _effectiveController.text.length,
              currentValueLength: _currentLength,
              onTap: () {
                if (!_effectiveController.selection.isValid) {
                  _effectiveController.selection = TextSelection.collapsed(
                      offset: _effectiveController.text.length);
                }
                _requestKeyboard();
              },
              child: child,
            );
          },
          child: _selectionGestureDetectorBuilder.buildGestureDetector(
            behavior: HitTestBehavior.translucent,
            child: child,
          ),
        ),
      ),
    );
  }
}
