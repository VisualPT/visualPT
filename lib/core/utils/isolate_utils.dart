import 'dart:async';
import 'dart:isolate';

class IsolateUtils {
  Isolate? _isolate;
  late SendPort _sendPort;
  late ReceivePort _receivePort;
  final Completer<void> _isolateReady = Completer<void>();

  SendPort get sendPort => _sendPort;

  IsolateUtils(String name) {
    _initIsolate(name);
  }

  Future<void> _initIsolate(String name) async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn<SendPort>(_entryPoint, _receivePort.sendPort,
        debugName: name);
    try {
      _sendPort = await _receivePort.first;
      _isolateReady.complete();
    } on Exception catch (e) {
      _isolateReady.completeError(e);
    }
  }

  static void _entryPoint(SendPort mainSendPort) async {
    final childReceivePort = ReceivePort();
    mainSendPort.send(childReceivePort.sendPort);

    await for (final _IsolateData? isolateData in childReceivePort) {
      if (isolateData != null) {
        final results = isolateData.handler(isolateData.params);
        isolateData.responsePort.send(results);
      }
    }
  }

  Future<void> sendMessage({
    required Function handler,
    required Map<String, dynamic> params,
    required ReceivePort responsePort,
  }) async {
    await _isolateReady.future;
    final isolateData = _IsolateData(
      handler: handler,
      params: params,
      responsePort: responsePort.sendPort,
    );
    _sendPort.send(isolateData);
  }

  void dispose() {
    _receivePort.close();
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
  }
}

class _IsolateData {
  final Function handler;
  final Map<String, dynamic> params;
  final SendPort responsePort;

  _IsolateData({
    required this.handler,
    required this.params,
    required this.responsePort,
  });
}
