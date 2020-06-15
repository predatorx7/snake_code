import 'package:camera/camera.dart' show ResolutionPreset;
import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 1)
class SettingsBox {
  /// Camera quality
  @HiveField(1)
  ResolutionPreset _cameraResolution;

  /// Camera quality
  ResolutionPreset get cameraResolution =>
      _cameraResolution ?? ResolutionPreset.medium;

  /// Camera quality
  set cameraResolution(ResolutionPreset cameraResolution) {
    _cameraResolution = cameraResolution;
  }

  /// Value between 0-1
  @HiveField(2)
  double _modelThreshold;

  /// Value between 0-1
  double get modelThreshold => _modelThreshold ?? 0.5;

  /// Value between 0-1
  set modelThreshold(double modelThreshold) {
    // Avoid letting threshold be lower than 0.2
    _modelThreshold = modelThreshold;
  }

  @HiveField(3)
  bool _saveHistory;

  bool get saveHistory => _saveHistory ?? true;

  set saveHistory(bool saveHistory) {
    _saveHistory = saveHistory;
  }

  SettingsBox(this._cameraResolution, this._modelThreshold, this._saveHistory);

  factory SettingsBox.initial() {
    return SettingsBox(ResolutionPreset.medium, 0.5, true);
  }
}
