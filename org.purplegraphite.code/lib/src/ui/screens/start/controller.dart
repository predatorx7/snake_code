import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

enum PreviousProjectLoadingStatus { loading, empty, done }

class StartScreenController with ChangeNotifier {
  PreviousProjectLoadingStatus _previousProjectStatus =
      PreviousProjectLoadingStatus.loading;
  PreviousProjectLoadingStatus get status =>
      _previousProjectStatus ?? PreviousProjectLoadingStatus.empty;

  StartScreenController();
}
