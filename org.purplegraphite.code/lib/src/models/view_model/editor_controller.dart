import 'dart:io';

import 'package:code/src/models/provider/tab_controller.dart';
import 'package:code/src/ui/screens/editor.dart';
import 'package:code/src/ui/screens/editor_tab.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EditorController with ChangeNotifier {
  EditorController(this.workspace);

  void initialize(EditorScreenState vsync) {
    _tabController = STabController(initialIndex: 0, length: 1, vsync: vsync);
  }

  @override
  void dispose() {
    tabController.dispose();
    _tabs = null;
    super.dispose();
  }

  final Directory workspace;

  STabController _tabController;
  STabController get tabController => _tabController;

  List<EditorTab> _tabs = <EditorTab>[];
  List<EditorTab> get tabs => _tabs;

  EditorTab get currentTab => _tabs[_tabController.index];

  EditorTabController get currentTabController => currentTab.controller;

  String get currentTitle => currentTabController.entity.basename;

  void addFile(File file) {
    _tabs.add(EditorTab.fromFile(file));
    _tabController.dispose();
    _tabController = _tabController.copyWith(
      index: _tabController.length,
      length: _tabController.length + 1,
      previousIndex: _tabController.index,
    );
    notifyListeners();
  }

  void removeTab(EditorTab tab) {
    print('Tab removed: ${_tabs.remove(tab)}');
    notifyListeners();
  }
}
