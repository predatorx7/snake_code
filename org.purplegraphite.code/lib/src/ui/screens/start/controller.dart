import 'package:flutter/widgets.dart';

enum PreviousProjectLoadingStatus { loading, empty, done }

class StartScreenController with ChangeNotifier {
  PreviousProjectLoadingStatus _previousProjectStatus =
      PreviousProjectLoadingStatus.loading;
  PreviousProjectLoadingStatus get status =>
      _previousProjectStatus ?? PreviousProjectLoadingStatus.empty;

  StartScreenController();
}
