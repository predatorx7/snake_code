// Copyright (c) 2020, Mushaheed Syed. All rights reserved.
// Use of this source code is governed by a BSD 3-Clause license that can be
// found in the LICENSE file.
//
// --------------------------------------------------------------------------------
// Copyright 2014 The Flutter Authors. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
//       copyright notice, this list of conditions and the following
//       disclaimer in the documentation and/or other materials provided
//       with the distribution.
//     * Neither the name of Google Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
// ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
// ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
    ClipboardStatusNotifier clipboardStatus,
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

  /// Whether the text field managed by the given `delegate` supports pasting
  /// from the clipboard.
  ///
  /// Subclasses can use this to decide if they should expose the paste
  /// functionality to the user.
  ///
  /// This does not consider the contents of the clipboard. Subclasses may want
  /// to, for example, disallow pasting when the clipboard contains an empty
  /// string.
  bool canPaste(CreamyTextSelectionDelegate delegate) {
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
  void handleCopy(CreamyTextSelectionDelegate delegate,
      ClipboardStatusNotifier clipboardStatus) {
    final TextEditingValue value = delegate.textEditingValue;
    Clipboard.setData(ClipboardData(
      text: value.selection.textInside(value.text),
    ));
    clipboardStatus?.update();
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
