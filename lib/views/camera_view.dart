import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

import '../../inference/model_inference_service.dart';
import '../../inference/service_locator.dart';
import '../../utils/isolate_utils.dart';
import 'camera_painters/model_camera_preview.dart';

class CameraView extends StatefulWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  CameraViewState createState() => CameraViewState();
}

class CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  CameraController? _cameraController;
  late List<CameraDescription> _cameras;
  late CameraDescription _cameraDescription;

  late bool _isRun;
  bool _predicting = false;
  bool _draw = false;

  late IsolateUtils _isolateUtils1;
  late IsolateUtils _isolateUtils2;
  late IsolateUtils _isolateUtils3;

  late ModelInferenceService _modelInferenceService1;
  late ModelInferenceService _modelInferenceService2;
  late ModelInferenceService _modelInferenceService3;

  late Map<String, dynamic>? _aggregatedResponse;

  @override
  void initState() {
    _modelInferenceService1 = ModelInferenceService();
    _modelInferenceService2 = ModelInferenceService();
    _modelInferenceService3 = ModelInferenceService();

    _modelInferenceService1.setModelConfig(1);
    _modelInferenceService2.setModelConfig(2);
    _modelInferenceService3.setModelConfig(3);

    _aggregatedResponse = {};

    _initStateAsync();
    super.initState();
  }

  void _initStateAsync() async {
    _isolateUtils1 = IsolateUtils();
    _isolateUtils2 = IsolateUtils();
    _isolateUtils3 = IsolateUtils();

    await _isolateUtils1.initIsolate();
    await _isolateUtils2.initIsolate();
    await _isolateUtils3.initIsolate();

    await _initCamera();
    _predicting = false;
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _cameraController = null;

    _isolateUtils1.dispose();
    _isolateUtils2.dispose();
    _isolateUtils3.dispose();

    _modelInferenceService1.inferenceResults = null;
    _modelInferenceService2.inferenceResults = null;
    _modelInferenceService3.inferenceResults = null;

    super.dispose();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _cameraDescription = _cameras[1];
    _isRun = false;
    _onNewCameraSelected(_cameraDescription);
  }

  void _onNewCameraSelected(CameraDescription cameraDescription) async {
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    _cameraController!.addListener(() {
      if (mounted) setState(() {});
      if (_cameraController!.value.hasError) {
        log('Camera error ${_cameraController!.value.errorDescription}');
      }
    });

    try {
      await _cameraController!.initialize().then((value) {
        if (!mounted) return;
      });
    } on CameraException catch (e) {
      log('Error: ${e.code}\n${e.description}');
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      navigationBar: _buildAppBar,
      child: ModelCameraPreview(
        cameraController: _cameraController,
        draw: _draw,
        results: _aggregatedResponse,
      ),
    );
  }

  CupertinoNavigationBar get _buildAppBar => CupertinoNavigationBar(
        leading: const Text(
          "Aggregated Models",
          style: TextStyle(
              color: CupertinoColors.white, fontWeight: FontWeight.bold),
        ),
        trailing: CupertinoButton(
          onPressed: () => _imageStreamToggle,
          child: const Icon(
            CupertinoIcons.play_arrow,
          ),
        ),
      );

  void get _imageStreamToggle {
    setState(() {
      _draw = !_draw;
    });

    _isRun = !_isRun;
    if (_isRun) {
      print("Starting stream");
      _cameraController!.startImageStream(
        (CameraImage cameraImage) async =>
            await _inference(cameraImage: cameraImage),
      );
    } else {
      _cameraController!.stopImageStream();
    }
  }

  Future<void> _inference({required CameraImage cameraImage}) async {
    if (!mounted) return;

    if (_modelInferenceService1.model.interpreter != null &&
        _modelInferenceService2.model.interpreter != null &&
        _modelInferenceService3.model.interpreter != null) {
      if (_predicting || !_draw) {
        return;
      }

      setState(() {
        _predicting = true;
      });

      if (_draw) {
        await _modelInferenceService1.inference(
          isolateUtils: _isolateUtils1,
          cameraImage: cameraImage,
        );
        await _modelInferenceService2.inference(
          isolateUtils: _isolateUtils2,
          cameraImage: cameraImage,
        );
        await _modelInferenceService3.inference(
          isolateUtils: _isolateUtils3,
          cameraImage: cameraImage,
        );
      }
      _aggregatedResponse!.clear();
      _aggregatedResponse!
          .addAll(_modelInferenceService1.inferenceResults ?? {"face": null});
      _aggregatedResponse!
          .addAll(_modelInferenceService2.inferenceResults ?? {"hand": null});
      _aggregatedResponse!
          .addAll(_modelInferenceService3.inferenceResults ?? {"pose": null});

      setState(() {
        _predicting = false;
      });
    }
  }
}
