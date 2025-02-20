import 'dart:async';

abstract class Repository<I, O> {
  final StreamController<O> _streamController;
  var isInitialized = false;
  var count = 0;
  var localStorage = <I, O>{};

  Repository() : _streamController = StreamController.broadcast();

  Stream<O> get stream => _streamController.stream;

  void add(O data) {
    if (!_streamController.isClosed) {
      _streamController.add(data);
      count++;
    }
  }

  Future<void> initialize();
  Future<void> store(
      String id, I input, O output, Map<String, dynamic>? params);
  void reset() {
    localStorage.clear();
    count = 0;
  }

  void dispose() {
    reset();
    if (!_streamController.isClosed) {
      _streamController.close();
    }
  }
}
