import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../creamy_field.dart';
import 'toolbar_options.dart';

/// An interface for manipulating the selection, to be used by the implementor
/// of the toolbar widget.
abstract class CreamyTextSelectionDelegate implements TextSelectionDelegate {
  /// Gets the current text input.
  TextEditingValue get textEditingValue;

  /// Sets the current text input (replaces the whole line).
  set textEditingValue(TextEditingValue value);

  /// Hides the text selection toolbar.
  void hideToolbar();

  /// Brings the provided [TextPosition] into the visible area of the text
  /// input.
  void bringIntoView(TextPosition position);

  /// Whether cut is enabled, must not be null.
  bool get cutEnabled => true;

  /// Whether copy is enabled, must not be null.
  bool get copyEnabled => true;

  /// Whether paste is enabled, must not be null.
  bool get pasteEnabled => true;

  /// Whether select all is enabled, must not be null.
  bool get selectAllEnabled => true;

  /// Whether to format label in camelcase
  bool get useCamelCaseLabel => true;

  ThemeMode get selectionToolbarThemeMode => ThemeMode.system;

  List<CreamyToolbarItem> get actions => null;
}

/// An interface for building the selection UI, to be provided by the
/// implementor of the toolbar widget.
///
/// Override text operations such as [handleCut] if needed.
abstract class CreamyTextSelectionControls /*implements TextSelectionControls*/ {
  /// Whether brightness is dark or light.
  Brightness get brightness => Brightness.light;

  /// Builds a selection handle of the given type.
  ///
  /// The top left corner of this widget is positioned at the bottom of the
  /// selection position.
  Widget buildHandle(BuildContext context, TextSelectionHandleType type,
      double textLineHeight);

  /// Get the anchor point of the handle relative to itself. The anchor point is
  /// the point that is aligned with a specific point in the text. A handle
  /// often visually "points to" that location.
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight);

  /// Builds a toolbar near a text selection.
  ///
  /// Typically displays buttons for copying and pasting text.
  ///
  /// [globalEditableRegion] is the TextField size of the global coordinate system
  /// in logical pixels.
  ///
  /// [textLineHeight] is the `preferredLineHeight` of the [RenderEditable] we
  /// are building a toolbar for.
  ///
  /// The [position] is a general calculation midpoint parameter of the toolbar.
  /// If you want more detailed position information, can use [endpoints]
  /// to calculate it.
  Widget buildToolbar(
    BuildContext context,
    Rect globalEditableRegion,
    double textLineHeight,
    Offset position,
    List<TextSelectionPoint> endpoints,
    CreamyTextSelectionDelegate delegate,
  );

  /// Returns the size of the selection handle.
  Size getHandleSize(double textLineHeight);

  /// Whether the current selection of the text field managed by the given
  /// `delegate` can be removed from the text field and placed into the
  /// [Clipboard].
  ///
  /// By default, false is returned when nothing is selected in the text field.
  ///
  /// Subclasses can use this to decide if they should expose the cut
  /// functionality to the user.
  bool canCut(CreamyTextSelectionDelegate delegate) {
    return delegate.cutEnabled &&
        !delegate.textEditingValue.selection.isCollapsed;
  }

  /// Whether the current selection of the text field managed by the given
  /// `delegate` can be copied to the [Clipboard].
  ///
  /// By default, false is returned when nothing is selected in the text field.
  ///
  /// Subclasses can use this to decide if they should expose the copy
  /// functionality to the user.
  bool canCopy(CreamyTextSelectionDelegate delegate) {
    return delegate.copyEnabled &&
        !delegate.textEditingValue.selection.isCollapsed;
  }

  /// Whether the current [Clipboard] content can be pasted into the text field
  /// managed by the given `delegate`.
  ///
  /// Subclasses can use this to decide if they should expose the paste
  /// functionality to the user.
  bool canPaste(CreamyTextSelectionDelegate delegate) {
    // TODO(goderbauer): return false when clipboard is empty, https://github.com/flutter/flutter/issues/11254
    return delegate.pasteEnabled;
  }

  /// Whether the current selection of the text field managed by the given
  /// `delegate` can be extended to include the entire content of the text
  /// field.
  ///
  /// Subclasses can use this to decide if they should expose the select all
  /// functionality to the user.
  bool canSelectAll(CreamyTextSelectionDelegate delegate) {
    return delegate.selectAllEnabled &&
        delegate.textEditingValue.text.isNotEmpty &&
        delegate.textEditingValue.selection.isCollapsed;
  }

  /// Copy the current selection of the text field managed by the given
  /// `delegate` to the [Clipboard]. Then, remove the selected text from the
  /// text field and hide the toolbar.
  ///
  /// This is called by subclasses when their cut affordance is activated by
  /// the user.
  void handleCut(CreamyTextSelectionDelegate delegate) {
    final TextEditingValue value = delegate.textEditingValue;
    Clipboard.setData(ClipboardData(
      text: value.selection.textInside(value.text),
    ));
    delegate.textEditingValue = TextEditingValue(
      text: value.selection.textBefore(value.text) +
          value.selection.textAfter(value.text),
      selection: TextSelection.collapsed(offset: value.selection.start),
    );
    delegate.bringIntoView(delegate.textEditingValue.selection.extent);
    delegate.hideToolbar();
  }

  /// Copy the current selection of the text field managed by the given
  /// `delegate` to the [Clipboard]. Then, move the cursor to the end of the
  /// text (collapsing the selection in the process), and hide the toolbar.
  ///
  /// This is called by subclasses when their copy affordance is activated by
  /// the user.
  void handleCopy(CreamyTextSelectionDelegate delegate) {
    final TextEditingValue value = delegate.textEditingValue;
    Clipboard.setData(ClipboardData(
      text: value.selection.textInside(value.text),
    ));
    delegate.textEditingValue = TextEditingValue(
      text: value.text,
      selection: TextSelection.collapsed(offset: value.selection.end),
    );
    delegate.bringIntoView(delegate.textEditingValue.selection.extent);
    delegate.hideToolbar();
  }

  /// Paste the current clipboard selection (obtained from [Clipboard]) into
  /// the text field managed by the given `delegate`, replacing its current
  /// selection, if any. Then, hide the toolbar.
  ///
  /// This is called by subclasses when their paste affordance is activated by
  /// the user.
  ///
  /// This function is asynchronous since interacting with the clipboard is
  /// asynchronous. Race conditions may exist with this API as currently
  /// implemented.
  // TODO(ianh): https://github.com/flutter/flutter/issues/11427
  Future<void> handlePaste(CreamyTextSelectionDelegate delegate) async {
    final TextEditingValue value =
        delegate.textEditingValue; // Snapshot the input before using `await`.
    final ClipboardData data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      delegate.textEditingValue = TextEditingValue(
        text: value.selection.textBefore(value.text) +
            data.text +
            value.selection.textAfter(value.text),
        selection: TextSelection.collapsed(
            offset: value.selection.start + data.text.length),
      );
    }
    delegate.bringIntoView(delegate.textEditingValue.selection.extent);
    delegate.hideToolbar();
  }

  /// Adjust the selection of the text field managed by the given `delegate` so
  /// that everything is selected.
  ///
  /// Does not hide the toolbar.
  ///
  /// This is called by subclasses when their select-all affordance is activated
  /// by the user.
  void handleSelectAll(CreamyTextSelectionDelegate delegate) {
    delegate.textEditingValue = TextEditingValue(
      text: delegate.textEditingValue.text,
      selection: TextSelection(
        baseOffset: 0,
        extentOffset: delegate.textEditingValue.text.length,
      ),
    );
    delegate.bringIntoView(delegate.textEditingValue.selection.extent);
  }
}
