import 'dart:async';

import 'package:ready_mixin/ready_mixin.dart';

mixin ReadyManager {
  ReadyState _readyState = ReadyState.initial;

  /// The current initialisation state.
  ReadyState get readyState => _readyState;
  Duration get readyTimeout => const Duration(milliseconds: 50);
  Object? readyError;

  /// Waits until the state is ready.
  /// Returns true on ready, and false on error.
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

  void setReady() => setReadyState(ReadyState.ready);
  void setWorking() => setReadyState(ReadyState.working);
  void setError([Object? error]) {
    readyError = error;
    setReadyState(ReadyState.error);
  }

  void setReadyState(ReadyState state) {
    _readyState = state;
  }

  void init() {
    _readyState = ReadyState.working;
    onInit();
  }

  void onInit();
}
