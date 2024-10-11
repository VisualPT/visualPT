import 'dart:async';

import 'package:visualpt/features/assessment/types.dart';

abstract class Repository<I, O> {
  final TrialMeta meta;
  final StreamController<I> _streamController;
  var isInitialized = false;
  var count = 0;
  var localStorage = <I, O>{};

  Repository(this.meta) : _streamController = StreamController.broadcast();

  Stream<I> get stream => _streamController.stream;

  void add(I data) {
    if (!_streamController.isClosed) {
      _streamController.add(data);
      count++;
    }
  }

  Future<void> initialize();
  Future<O?> runPredict(String id, I input, Map<String, dynamic>? params);
  Future<void> store(
      String id, I input, O output, Map<String, dynamic>? params);
  void reset() {
    localStorage.clear();
    count = 0;
  }

  void dispose() {
    _streamController.close();
  }
}
