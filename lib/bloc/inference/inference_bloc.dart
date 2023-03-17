//TODO address memory leak with this bloc

// import 'dart:async';
// import 'dart:developer';
// import 'package:camera/camera.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:visualpt/inference/model_inference_service.dart';
// import 'package:visualpt/utils/isolate_utils.dart';

// part 'inference_event.dart';
// part 'inference_state.dart';

// class InferenceBloc extends Bloc<InferenceEvent, InferenceState> {
//   //TODO dynamically load models through constructor
//   late IsolateUtils _faceIsolateUtils;
//   late IsolateUtils _handIsolateUtils;
//   late IsolateUtils _poseIsolateUtils;

//   late ModelInferenceService _faceInferenceService;
//   late ModelInferenceService _handInferenceService;
//   late ModelInferenceService _poseInferenceService;

//   late Map<String, dynamic>? aggregatedResponse;

//   bool processing = false;

//   InferenceBloc() : super(InferenceLoading()) {
//     on<InferenceInit>(_onInit);
//     on<InferenceInput>(_onInput);
//     on<InferenceEnd>(_onEnd);
//   }

//   FutureOr<void> _onInit(
//       InferenceInit event, Emitter<InferenceState> emit) async {
//     log("Configuring Models and Isolates");
//     _faceInferenceService = ModelInferenceService();
//     _handInferenceService = ModelInferenceService();
//     _poseInferenceService = ModelInferenceService();

//     _faceInferenceService.setModelConfig(1);
//     _handInferenceService.setModelConfig(2);
//     _poseInferenceService.setModelConfig(3);

//     aggregatedResponse = {};

//     _faceIsolateUtils = IsolateUtils();
//     _handIsolateUtils = IsolateUtils();
//     _poseIsolateUtils = IsolateUtils();

//     await _faceIsolateUtils.initIsolate();
//     await _handIsolateUtils.initIsolate();
//     await _poseIsolateUtils.initIsolate();
//   }

//   FutureOr<void> _onInput(
//       InferenceInput event, Emitter<InferenceState> emit) async {
//     print("Inference Input called");
//     if (processing) {
//       return;
//     } else {
//       await inference(cameraImage: event.input);
//       print(aggregatedResponse);
//       emit(InferenceRunning(response: aggregatedResponse!));
//     }
//   }

//   FutureOr<void> _onEnd(InferenceEnd event, Emitter<InferenceState> emit) {
//     _faceIsolateUtils.dispose();
//     _handIsolateUtils.dispose();
//     _poseIsolateUtils.dispose();

//     _faceInferenceService.inferenceResults = null;
//     _handInferenceService.inferenceResults = null;
//     _poseInferenceService.inferenceResults = null;
//   }

//   Future<void> inference({required CameraImage cameraImage}) async {
//     processing == true;
//     if (_faceInferenceService.model.interpreter != null &&
//         _handInferenceService.model.interpreter != null &&
//         _poseInferenceService.model.interpreter != null) {
//       await _faceInferenceService.inference(
//         isolateUtils: _faceIsolateUtils,
//         cameraImage: cameraImage,
//       );
//       await _handInferenceService.inference(
//         isolateUtils: _handIsolateUtils,
//         cameraImage: cameraImage,
//       );
//       await _poseInferenceService.inference(
//         isolateUtils: _poseIsolateUtils,
//         cameraImage: cameraImage,
//       );
//       aggregatedResponse!.clear();
//       aggregatedResponse!
//           .addAll(_faceInferenceService.inferenceResults ?? {"face": null});
//       aggregatedResponse!
//           .addAll(_handInferenceService.inferenceResults ?? {"hand": null});
//       aggregatedResponse!
//           .addAll(_poseInferenceService.inferenceResults ?? {"pose": null});
//       processing = false;
//     }
//   }
// }
