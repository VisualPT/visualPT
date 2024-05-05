import 'dart:async';

import 'package:visualpt/features/assessment/types.dart';

abstract class Repository<I, O> {
  final ClinicalMeta meta;
  final StreamController<I> _streamController;
  var isInitialized = false;
  var count = 0;
  Repository(this.meta) : _streamController = StreamController.broadcast();

  Stream<I> get stream => _streamController.stream;

  void add(I data) {
    if (!_streamController.isClosed) {
      _streamController.add(data);
      count++;
    }
  }

  Future<void> initialize();
  Future<O?> runPredict(I input, Map<String, dynamic>? params);
  Future<void> store(I input, O output, Map<String, dynamic>? params);

  void dispose() {
    _streamController.close();
  }
}
