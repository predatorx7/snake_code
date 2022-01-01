import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart' show TextSelectionPoint;
import 'package:flutter/widgets.dart';

import '../../creamy_field.dart';

// Intermediate data used for building menu items with the _getItems method.
class CreamyTextSelectionToolbarAction {
  final String label;
  final bool visible;
  final void Function() onPressed;

  const CreamyTextSelectionToolbarAction({
    required this.label,
    required this.onPressed,
    this.visible = true,
  });
}

enum TextSelectionControlsType {
  material,
}

/// Normally, when a [TextSelectionControls] calls [buildToolbar], the UI for the toolbar is painted.
/// By default, this doesn't support additional actions other than copy, cut, select all & paste.
mixin CreamyTextSelectionControls implements TextSelectionControls {
  /// Builds a toolbar without additional actions
  @nonVirtual
  @override
  Widget buildToolbar(
    BuildContext context,
    Rect globalEditableRegion,
    double textLineHeight,
    Offset selectionMidpoint,
    List<TextSelectionPoint> endpoints,
    TextSelectionDelegate delegate,
    ClipboardStatusNotifier clipboardStatus,
    Offset? lastSecondaryTapDownPosition,
  ) {
    return buildToolbarWithActions(
      context,
      globalEditableRegion,
      textLineHeight,
      selectionMidpoint,
      endpoints,
      delegate,
      clipboardStatus,
      lastSecondaryTapDownPosition,
    );
  }

  /// Build a toolbar which supports actions.
  ///
  /// [CreamyTextSelectionControlsProvider] uses this to create toolbar with actions.
  ///
  /// This callback is also called by the [buildToolbar] to create a toolbar without actions.
  Widget buildToolbarWithActions(
    BuildContext context,
    Rect globalEditableRegion,
    double textLineHeight,
    Offset position,
    List<TextSelectionPoint> endpoints,
    TextSelectionDelegate delegate,
    ClipboardStatusNotifier clipboardStatus,
    Offset? lastSecondaryTapDownPosition, {
    List<CreamyTextSelectionToolbarAction> actions,
  });
}

typedef List<CreamyTextSelectionToolbarAction> ActionsBuilderCallback(
  BuildContext context,
  TextSelectionDelegate delegate,
  ClipboardStatusNotifier clipboardStatus,
);

/// A [TextSelectionControls] provider with actions.
///
/// Provide additional options to the text selection toolbar.
///
/// This delegates methods from [controls] to allow compatiblity with Material Text input fields.
class CreamyTextSelectionControlsProvider implements TextSelectionControls {
  final CreamyTextSelectionControls controls;

  /// More actions the selection toolbar should offer.
  ActionsBuilderCallback actionsBuilder;

  /// A Provider of a custom [CreamyTextSelectionControls] with actions.
  CreamyTextSelectionControlsProvider.custom({
    required this.controls,
    required this.actionsBuilder,
  });

  /// Provide text selection controls from this package,
  ///
  /// Describe the type of selections controls with [type].
  /// Use [actionsBuilder] to build actions for the selection controls.
  factory CreamyTextSelectionControlsProvider({
    required TextSelectionControlsType type,
    required ActionsBuilderCallback actionsBuilder,
  }) {
    TextSelectionControls textSelectionControls;

    switch (type) {
      case TextSelectionControlsType.material:
      default:
        textSelectionControls = creamyMaterialTextSelectionControls;
    }

    return CreamyTextSelectionControlsProvider.custom(
      controls: textSelectionControls as CreamyTextSelectionControls,
      actionsBuilder: actionsBuilder,
    );
  }

  @override
  Widget buildHandle(
    BuildContext context,
    TextSelectionHandleType type,
    double textLineHeight, [
    VoidCallback? onTap,
    double? startGlyphHeight,
    double? endGlyphHeight,
  ]) =>
      controls.buildHandle(
        context,
        type,
        textLineHeight,
        onTap,
        startGlyphHeight,
        endGlyphHeight,
      );

  @override
  Widget buildToolbar(
      BuildContext context,
      Rect globalEditableRegion,
      double textLineHeight,
      Offset position,
      List<TextSelectionPoint> endpoints,
      TextSelectionDelegate delegate,
      ClipboardStatusNotifier clipboardStatus,
      Offset? lastSecondaryTapDownPosition) {
    return controls.buildToolbarWithActions(
      context,
      globalEditableRegion,
      textLineHeight,
      position,
      endpoints,
      delegate,
      clipboardStatus,
      lastSecondaryTapDownPosition,
      actions: actionsBuilder(
        context,
        delegate,
        clipboardStatus,
      ),
    );
  }

  @override
  Offset getHandleAnchor(
    TextSelectionHandleType type,
    double textLineHeight, [
    double? startGlyphHeight,
    double? endGlyphHeight,
  ]) =>
      controls.getHandleAnchor(
        type,
        textLineHeight,
        startGlyphHeight,
        endGlyphHeight,
      );

  @override
  Size getHandleSize(double textLineHeight) => controls.getHandleSize(
        textLineHeight,
      );

  @override
  bool canCopy(TextSelectionDelegate delegate) => controls.canCopy(delegate);

  @override
  bool canCut(TextSelectionDelegate delegate) => controls.canCut(delegate);

  @override
  bool canPaste(TextSelectionDelegate delegate) => controls.canPaste(delegate);

  @override
  bool canSelectAll(TextSelectionDelegate delegate) =>
      controls.canSelectAll(delegate);

  @override
  void handleCopy(
    TextSelectionDelegate delegate,
    ClipboardStatusNotifier? clipboardStatus,
  ) =>
      controls.handleCopy(
        delegate,
        clipboardStatus,
      );

  @override
  void handleCut(TextSelectionDelegate delegate,
          ClipboardStatusNotifier? clipboardStatus) =>
      controls.handleCut(delegate, clipboardStatus);

  @override
  Future<void> handlePaste(TextSelectionDelegate delegate) =>
      controls.handlePaste(delegate);

  @override
  void handleSelectAll(TextSelectionDelegate delegate) =>
      controls.handleSelectAll(delegate);
}
