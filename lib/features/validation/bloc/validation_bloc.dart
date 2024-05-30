import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart' as amplify;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:visualpt/features/backend/service/storage_service.dart';
import 'package:visualpt/features/video/types.dart';

part 'validation_event.dart';
part 'validation_state.dart';

class ValidationBloc extends Bloc<ValidationEvent, ValidationState> {
  final String type;
  final _storage = StorageService();
  // Internal list to keep track of processed IDs
  final List<String> processedKeys = [];
  // Internal list to keep track of procesed labels
  final List<int> _processedInputs = [];

  ValidationBloc(this.type) : super(const ValidationLoad()) {
    on<ValidationFetch>(_onFetch);
    on<ValidationPrev>(_onPrev);
    on<ValidationNext>(_onNext);
    on<ValidationInput>(_onInput);
    on<ValidationEnd>(_onEnd);
  }

  FutureOr<void> _onFetch(
      ValidationFetch event, Emitter<ValidationState> emit) async {
    try {
      final storedKeys = await _storage.listRawData(type);
      add(ValidationNext(keys: storedKeys));
    } catch (e) {
      log(e.toString());
      emit(const ValidationLoad());
    }
  }

  FutureOr<void> _onPrev(
      ValidationPrev event, Emitter<ValidationState> emit) async {
    emit(const ValidationLoad());
    //Put the ID back into the list of unprocessed IDs
    String id = processedKeys.removeLast();
    final newKeys = [
      '$id.csv',
      '$id.png',
      '${event.currentKey}.csv',
      '${event.currentKey}.png',
    ].map((k) => '$type/raw/$k').toList()
      ..addAll(event.keys);

    int label = _processedInputs.removeLast();
    if (label == 1) {
      await _storage.move(
          path: type,
          sourceKey: 'valid/$id.csv',
          destinationKey: 'raw/$id.csv');
      await _storage.move(
          path: type,
          sourceKey: 'valid/$id.png',
          destinationKey: 'raw/$id.png');
    } else {
      await _storage.move(
          path: type,
          sourceKey: 'invalid/$id.csv',
          destinationKey: 'raw/$id.csv');
      await _storage.move(
          path: type,
          sourceKey: 'invalid/$id.png',
          destinationKey: 'raw/$id.png');
    }
    add(ValidationNext(keys: newKeys));
  }

  FutureOr<void> _onNext(
      ValidationNext event, Emitter<ValidationState> emit) async {
    String imageID, dataID;
    //Get the image and data from the 'raw/' storage folder using the keys from the list
    //Get the id of the first item in the list
    try {
      if (event.keys.isNotEmpty) {
        final temp = event.keys.removeAt(0);
        //If  temp  contains a .csv then it is the data file
        String searchKey;
        if (temp.endsWith('.csv')) {
          dataID = temp;
          searchKey = temp.substring(0, temp.lastIndexOf('.')).split('/').last;
          final imageIndex =
              event.keys.indexWhere((element) => element.contains(searchKey));
          if (imageIndex != -1) {
            imageID = event.keys.removeAt(imageIndex);
          } else {
            throw Exception('No image file found');
          }
        } else {
          imageID = temp;
          searchKey = temp.substring(0, temp.lastIndexOf('.')).split('/').last;
          final dataIndex =
              event.keys.indexWhere((element) => element.contains(searchKey));
          if (dataIndex != -1) {
            dataID = event.keys.removeAt(dataIndex);
          } else {
            throw Exception('No data file found');
          }
        }
        final timestampID = searchKey.split("_").last;
        //Get the image and data from the storage
        final imageResult = await _storage.download(key: imageID).result;
        final dataResult = await _storage.download(key: dataID).result;
        final dataOutput = String.fromCharCodes(dataResult.bytes);
        final detection = parseVersionedDetection(timestampID, dataOutput);

        final classification = detection.inferredClassification == "1";
        emit(ValidationDisplay(
          event.keys,
          key: searchKey,
          dataBytes: dataResult.bytes,
          imageBytes: imageResult.bytes,
          imageHeight: detection.imageHeight,
          imageWidth: detection.imageWidth,
          classification: classification,
          offsets: detection.output.landmarks,
        ));
      } else {
        add(const ValidationEnd());
      }
    } on Exception catch (e) {
      log(e.toString());
      add(ValidationNext(keys: event.keys));
    }
  }

  FutureOr<void> _onInput(
      ValidationInput event, Emitter<ValidationState> emit) {
    emit(const ValidationLoad());
    //Store the ID of the image and data file in a list in case we need to go back
    processedKeys.add(event.key);
    _processedInputs.add(event.input > -1 ? 1 : 0);
    //Store the validated data
    if (event.input > -1) {
      final dataOutput = String.fromCharCodes(event.dataBytes);
      final detection = VPTDetection.fromCSV(dataOutput);
      final newDetection = detection
          .copyWith(
            inferredClassification: event.input.toString(),
          )
          .toCSV();

      final encodedData = utf8.encode(newDetection);

      _storage.remove(
          '$type/raw/${event.key}.csv', amplify.StorageAccessLevel.guest);
      _storage.upload(amplify.HttpPayload.bytes(encodedData),
          '$type/valid/${event.key}.csv', amplify.StorageAccessLevel.guest);
      _storage.move(
          path: type,
          sourceKey: 'raw/${event.key}.png',
          destinationKey: 'valid/${event.key}.png');
    } else {
      _storage.move(
          path: type,
          sourceKey: 'raw/${event.key}.csv',
          destinationKey: 'invalid/${event.key}.csv');
      _storage.move(
          path: type,
          sourceKey: 'raw/${event.key}.png',
          destinationKey: 'invalid/${event.key}.png');
    }
    //Start the next validation
    add(ValidationNext(keys: event.keys));
  }

  FutureOr<void> _onEnd(ValidationEnd event, Emitter<ValidationState> emit) {
    log("No more data to validate");
    emit(const ValidationDispose([]));
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // TODO: implement onError
    print({error, stackTrace});
    super.onError(error, stackTrace);
  }
}
