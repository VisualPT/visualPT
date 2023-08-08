part of 'validation_bloc.dart';

abstract class ValidationState extends Equatable {
  final List<String> keys;
  const ValidationState(this.keys);

  @override
  List<Object> get props => [];
}

class ValidationLoad extends ValidationState {
  const ValidationLoad(super.keys);

  @override
  List<Object> get props => [];
}

class ValidationDisplay extends ValidationState {
  final String key;
  final Uint8List imageData;
  final double imageRatio;
  final int classification;
  final List<Offset> offsets;
  const ValidationDisplay(super.keys,
      {required this.key,
      required this.imageData,
      required this.imageRatio,
      required this.classification,
      required this.offsets});

  @override
  List<Object> get props => [imageData, imageRatio, classification, offsets];
}

class ValidationError extends ValidationState {
  final String message;
  const ValidationError(super.keys, {required this.message});

  @override
  List<Object> get props => [message];
}
