import 'dart:async';

abstract class Repository<I, O> {
  final StreamController<I> _streamController;
  var count = 0;
  Repository() : _streamController = StreamController.broadcast();

  Stream<I> get stream => _streamController.stream;

  void add(I data) {
    if (!_streamController.isClosed) {
      count = 0;
      _streamController.add(data);
    }
  }

  Future<void> initialize();
  Future<O?> predict(I input, Map<String, dynamic>? params);
  Future<void> store(I input, O output, Map<String, dynamic>? params);

  void dispose() {
    _streamController.close();
  }
}
