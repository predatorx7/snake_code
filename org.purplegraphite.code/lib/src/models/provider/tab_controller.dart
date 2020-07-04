import 'package:code/src/common/constants.dart';
import 'package:flutter/widgets.dart';

class TabController extends ChangeNotifier {
  /// Creates an object that manages the state required by [TabBar] and a
  /// [TabBarView].
  ///
  /// The [_length] must not be null or negative. Typically it's a value greater
  /// than one, i.e. typically there are two or more tabs. The [_length] must
  /// match [TabBar.tabs]'s and [TabBarView.children]'s length.
  ///
  /// The `initialIndex` must be valid given [_length] and must not be null. If
  /// [_length] is zero, then `initialIndex` must be 0 (the default).
  TabController({
    @required int tabLength,
    @required TickerProvider vsync,
    int initialIndex = 0,
  })  : _length = tabLength,
        assert(_length != null && _length >= 0),
        assert(initialIndex != null &&
            initialIndex >= 0 &&
            (_length == 0 || initialIndex < _length)),
        _index = initialIndex,
        _previousIndex = initialIndex,
        _animationController = AnimationController.unbounded(
          value: initialIndex.toDouble(),
          vsync: vsync,
        );

  // Private constructor used by `_copyWith`. This allows a new TabController to
  // be created without having to create a new animationController.
  TabController._({
    @required int tabLength,
    int index,
    int previousIndex,
    AnimationController animationController,
  })  : _length = tabLength,
        _index = index,
        _previousIndex = previousIndex,
        _animationController = animationController;

  /// Creates a new [TabController] with `index`, `previousIndex`, and `length`
  /// if they are non-null.
  ///
  /// This method is used by [DefaultTabController].
  ///
  /// When [DefaultTabController._length] is updated, this method is called to
  /// create a new [TabController] without creating a new [AnimationController].
  TabController copyWith({int index, int length, int previousIndex}) {
    return TabController._(
      index: index ?? _index,
      tabLength: length ?? this._length,
      animationController: _animationController,
      previousIndex: previousIndex ?? _previousIndex,
    );
  }

  /// An animation whose value represents the current position of the [TabBar]'s
  /// selected tab indicator as well as the scrollOffsets of the [TabBar]
  /// and [TabBarView].
  ///
  /// The animation's value ranges from 0.0 to [_length] - 1.0. After the
  /// selected tab is changed, the animation's value equals [index]. The
  /// animation's value can be [offset] by +/- 1.0 to reflect [TabBarView]
  /// drag scrolling.
  ///
  /// If this [TabController] was disposed, then return null.
  Animation<double> get animation => _animationController?.view;
  AnimationController _animationController;

  int _length;

  /// The total number of tabs.
  ///
  /// Typically greater than one. Must match [TabBar.tabs]'s and
  /// [TabBarView.children]'s length.
  int get length => _length;

  /// Change the total number of tabs.
  ///
  /// Must match [TabBar.tabs]'s and
  /// [TabBarView.children]'s length.
  void setLength(int length) {
    _length = length;
    notifyListeners();
  }

  void _changeIndex(int value, {Duration duration, Curve curve}) {
    assert(value != null);
    assert(value >= 0 && (value < _length || _length == 0));
    assert(duration != null || curve == null);
    assert(_indexIsChangingCount >= 0);
    if (value == _index || _length < 2) return;
    _previousIndex = index;
    _index = value;
    if (duration != null) {
      _indexIsChangingCount += 1;
      notifyListeners(); // Because the value of indexIsChanging may have changed.
      _animationController
          .animateTo(_index.toDouble(), duration: duration, curve: curve)
          .whenCompleteOrCancel(() {
        _indexIsChangingCount -= 1;
        notifyListeners();
      });
    } else {
      _indexIsChangingCount += 1;
      _animationController.value = _index.toDouble();
      _indexIsChangingCount -= 1;
      notifyListeners();
    }
  }

  /// The index of the currently selected tab.
  ///
  /// Changing the index also updates [previousIndex], sets the [animation]'s
  /// value to index, resets [indexIsChanging] to false, and notifies listeners.
  ///
  /// To change the currently selected tab and play the [animation] use [animateTo].
  ///
  /// The value of [index] must be valid given [_length]. If [_length] is zero,
  /// then [index] will also be zero.
  int get index => _index;
  int _index;
  set index(int value) {
    _changeIndex(value);
  }

  /// The index of the previously selected tab.
  ///
  /// Initially the same as [index].
  int get previousIndex => _previousIndex;
  int _previousIndex;

  /// True while we're animating from [previousIndex] to [index] as a
  /// consequence of calling [animateTo].
  ///
  /// This value is true during the [animateTo] animation that's triggered when
  /// the user taps a [TabBar] tab. It is false when [offset] is changing as a
  /// consequence of the user dragging (and "flinging") the [TabBarView].
  bool get indexIsChanging => _indexIsChangingCount != 0;
  int _indexIsChangingCount = 0;

  /// Immediately sets [index] and [previousIndex] and then plays the
  /// [animation] from its current value to [index].
  ///
  /// While the animation is running [indexIsChanging] is true. When the
  /// animation completes [offset] will be 0.0.
  void animateTo(int value,
      {Duration duration = kTabScrollDuration, Curve curve = Curves.ease}) {
    _changeIndex(value, duration: duration, curve: curve);
  }

  /// The difference between the [animation]'s value and [index].
  ///
  /// The offset value must be between -1.0 and 1.0.
  ///
  /// This property is typically set by the [TabBarView] when the user
  /// drags left or right. A value between -1.0 and 0.0 implies that the
  /// TabBarView has been dragged to the left. Similarly a value between
  /// 0.0 and 1.0 implies that the TabBarView has been dragged to the right.
  double get offset => _animationController.value - _index.toDouble();
  set offset(double value) {
    assert(value != null);
    assert(value >= -1.0 && value <= 1.0);
    assert(!indexIsChanging);
    if (value == offset) return;
    _animationController.value = value + _index.toDouble();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _animationController = null;
    super.dispose();
  }
}
