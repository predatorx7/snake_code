import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CreamyToolbarItem {
  final String label;
  final bool visible;
  final void Function() callback;

  CreamyToolbarItem({
    @required this.label,
    this.visible = true,
    @required this.callback,
  });
}

class CreamyToolbarOptions implements ToolbarOptions {
  /// Create a toolbar configuration with given options.
  ///
  /// All options default to false if they are not explicitly set.
  const CreamyToolbarOptions({
    this.copy = false,
    this.cut = false,
    this.paste = false,
    this.selectAll = false,
    this.actions,
  })  : assert(copy != null),
        assert(cut != null),
        assert(paste != null),
        assert(selectAll != null);

  /// Whether to show copy option in toolbar.
  ///
  /// Defaults to false. Must not be null.
  final bool copy;

  /// Whether to show cut option in toolbar.
  ///
  /// If [EditableText.readOnly] is set to true, cut will be disabled regardless.
  ///
  /// Defaults to false. Must not be null.
  final bool cut;

  /// Whether to show paste option in toolbar.
  ///
  /// If [EditableText.readOnly] is set to true, paste will be disabled regardless.
  ///
  /// Defaults to false. Must not be null.
  final bool paste;

  /// Whether to show select all option in toolbar.
  ///
  /// Defaults to false. Must not be null.
  final bool selectAll;

  final List<CreamyToolbarItem> actions;
}
