import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import 'dart:math';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class StartTipsController with ChangeNotifier {
  StartScreenController() {
    _generateRandomIndexForTip();
  }

  // TIPS

  bool _showTips = true;

  bool get showTips => _showTips ?? false;

  int _tipIndex = 0;

  void _generateRandomIndexForTip() {
    DateTime time = DateTime.now();
    Random rand = Random(time.millisecond);
    _tipIndex = rand.nextInt(_tips.length);
  }

  void expandTips() {
    _showTips = true;
    notifyListeners();
  }

  void collapseTips() {
    _showTips = false;
    notifyListeners();
  }

  int getTipIndex() {
    return _tipIndex;
  }

  void nextTip() {
    final _potentialIndex = _tipIndex + 1;
    _tipIndex = _potentialIndex == _tips.length ? 0 : _potentialIndex;
    notifyListeners();
  }

  void previousTip() {
    final _potentialIndex = _tipIndex - 1;
    _tipIndex = _potentialIndex == -1 ? (_tips.length - 1) : _potentialIndex;
    notifyListeners();
  }

  final List<String> _tips = [
    'Files are good for writing code snippets, general programs & short scripts. Opening a directory as a project will allow working with multiple files.',
    'You can open directory from Termux app storage if you tap on import while keeping Termux app open in background!'
  ];

  List<String> get tips => _tips ?? [];
}

class StartTips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDarkMode = _theme.brightness == Brightness.dark;
    final _borderRadius = BorderRadius.circular(10);
    final foregroundColorOnDarkBackground =
        _isDarkMode ? Colors.white.withOpacity(1) : Color(0xEE212121);
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 16),
      child: Consumer<StartTipsController>(
        builder: (context, value, child) {
          if (!value.showTips) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Material(
                    borderRadius: _borderRadius,
                    elevation: _isDarkMode ? 0 : 2,
                    child: InkWell(
                      onTap: value.expandTips,
                      borderRadius: _borderRadius,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4),
                        child: Icon(EvaIcons.moreHorizotnalOutline),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          final int _index = value.getTipIndex();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Material(
              borderRadius: _borderRadius,
              elevation: _isDarkMode ? 0 : 2,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'TIP #${_index + 1}',
                                style: _theme.textTheme.subtitle1.copyWith(
                                  color: foregroundColorOnDarkBackground,
                                ),
                              ),
                              IconButton(
                                padding: const EdgeInsets.all(0),
                                icon: Icon(EvaIcons.close),
                                color: foregroundColorOnDarkBackground,
                                onPressed: value.collapseTips,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Text(
                            value.tips[_index],
                            style: _theme.textTheme.subtitle2.copyWith(
                              color: foregroundColorOnDarkBackground,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(EvaIcons.chevronLeftOutline),
                                color: foregroundColorOnDarkBackground,
                                onPressed: value.previousTip,
                              ),
                              IconButton(
                                icon: Icon(EvaIcons.chevronRightOutline),
                                color: foregroundColorOnDarkBackground,
                                onPressed: value.nextTip,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Close button above the tip
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
