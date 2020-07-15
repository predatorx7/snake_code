import 'dart:io';

import 'package:code/src/models/plain_model/entity.dart';
import 'package:code/src/models/provider/theme.dart';
import 'package:creamy_field/creamy_field.dart';
import 'package:flutter/material.dart';

class EditorTabController with ChangeNotifier {
  String get directoryPath => file.path;

  final Entity entity;
  File get file => entity.entity as File;

  ScrollController scrollController;
  FocusNode focusNode;
  CreamyEditingController textController;

  bool _initialized = false;
  bool get isInitialized => _initialized;

  void initState() {
    scrollController = ScrollController();
    textController = CreamyEditingController();
    focusNode = FocusNode();
    _initialized = true;
  }

  @override
  void dispose() {
    scrollController.dispose();
    focusNode.dispose();
    textController.dispose();
    super.dispose();
    _initialized = false;
  }

  EditorTabController(this.entity);
}

class EditorTab extends StatefulWidget with Comparable<EditorTab> {
  final EditorTabController controller;

  const EditorTab._({
    @required this.controller,
    Key key,
  }) : super(key: key);

  factory EditorTab.fromFile(File file) {
    return EditorTab._(
      controller: EditorTabController(Entity(file)),
    );
  }

  @override
  int compareTo(EditorTab other) {
    return this.controller.entity.compareTo(other.controller.entity);
  }

  @override
  _EditorTabState createState() =>
      _EditorTabState(ValueKey<String>(controller.directoryPath));
}

class _EditorTabState extends State<EditorTab> {
  final ValueKey key;

  _EditorTabState(this.key);

  @override
  void initState() {
    widget.controller.initState();
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foregroundInDark = (Theme.of(context).brightness == Brightness.dark)
        ? Colors.white
        : Colors.black;
    return CreamyField(
      key: key,
      controller: widget.controller.textController,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      textCapitalization: TextCapitalization.none,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
      obscureText: false,
      focusNode: widget.controller.focusNode,
      style: ThemeProvider.monospaceTextStyle.copyWith(color: foregroundInDark),
      autocorrect: true,
      enableSuggestions: true,
      maxLines: null,
      scrollPadding: const EdgeInsets.all(20.0),
      smartDashesType: SmartDashesType.enabled,
      smartQuotesType: SmartQuotesType.enabled,
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration.collapsed(
        hintText: 'Start writing..',
        hintStyle: ThemeProvider.monospaceTextStyle.copyWith(
          color: foregroundInDark.withOpacity(0.5),
        ),
      ),
      showLineIndicator: true,
      horizontallyScrollable: true,
    );
  }
}
