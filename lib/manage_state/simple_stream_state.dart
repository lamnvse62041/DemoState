import 'dart:async';

class SimpleStreamState<T> {
  final StreamController<T> _controller;

  SimpleStreamState(this._controller);
  Stream<T> get stream => _controller.stream;

  void updateState(T newValue) {
    _controller.add(newValue);
  }
}
