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
  final String imageUrl;
  final int imageHeight;
  final int imageWidth;
  final double ratio;
  final int classification;
  final List<Offset> offsets;
  const ValidationDisplay(super.keys,
      {required this.key,
      required this.imageUrl,
      required this.imageHeight,
      required this.imageWidth,
      required this.ratio,
      required this.classification,
      required this.offsets});

  @override
  List<Object> get props =>
      [imageUrl, imageHeight, imageWidth, classification, offsets];
}

class ValidationDispose extends ValidationState {
  const ValidationDispose(super.keys);

  @override
  List<Object> get props => [];
}

class ValidationError extends ValidationState {
  final String message;
  const ValidationError(super.keys, {required this.message});

  @override
  List<Object> get props => [message];
}
