import 'dart:async';

abstract class Repository<O> {
  final StreamController<O> _streamController;
  var count = 0;
  var localStorage = <int, O>{};

  Repository() : _streamController = StreamController.broadcast();

  Stream<O> get stream => _streamController.stream;

  void add(O data) {
    if (!_streamController.isClosed) {
      _streamController.add(data);
      localStorage[DateTime.now().microsecondsSinceEpoch] =
          data; // updated line to store data correctly
      count++;
    }
  }

  Future<void> store(int id, O output, Map<String, dynamic>? params);

  void dispose() {
    localStorage.clear();
    count = 0;
    if (!_streamController.isClosed) {
      _streamController.close();
    }
  }
}
