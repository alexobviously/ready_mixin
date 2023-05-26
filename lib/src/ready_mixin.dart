import 'dart:async';

import 'package:ready_mixin/ready_mixin.dart';

mixin ReadyMixin {
  ReadyState _readyState = ReadyState.initial;

  /// The current initialisation state.
  ReadyState get readyState => _readyState;

  /// Override this to change the waiting time between checks in [ready].
  Duration get readyTimeout => const Duration(milliseconds: 50);

  /// The error that caused the state to be [ReadyState.error].
  Object? readyError;

  /// Waits until the state is ready.
  /// Returns true on ready, and false on error.
  /// If initialisation hasn't started yet, this will start it.
  /// Override [readyTimeout] to change the time between checks (default 50ms).
  Future<bool> get ready async {
    while (true) {
      if (_readyState == ReadyState.ready) return true;
      if (_readyState == ReadyState.error) return false;
      if (_readyState == ReadyState.initial) {
        _readyState = ReadyState.working;
        init();
      }
      await Future.delayed(readyTimeout);
    }
  }

  /// Sets the state to [ReadyState.ready].
  void setReady() => setReadyState(ReadyState.ready);

  /// Sets the state to [ReadyState.working].
  void setWorking() => setReadyState(ReadyState.working);

  /// Sets the state to [ReadyState.error].
  /// Optionally provide an [error], which will be stored in [readyError].
  void setError([Object? error]) {
    readyError = error;
    setReadyState(ReadyState.error);
  }

  void setReadyState(ReadyState state) {
    _readyState = state;
  }

  /// Call this to start initialisation.
  /// Override [onInit] to provide your initialisation logic.
  void init() {
    _readyState = ReadyState.working;
    onInit();
  }

  /// Override this with your initialisation code.
  /// Make sure you end with [setReady] or [setError].
  void onInit();
}
