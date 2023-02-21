part of 'camera_bloc.dart';

@immutable
abstract class CameraEvent {}

class CameraInit extends CameraEvent {}

class CameraPlay extends CameraEvent {}

class CameraPause extends CameraEvent {}

class CameraStop extends CameraEvent {}
