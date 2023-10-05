import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart' as amplify;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:visualpt/service/storage_service.dart';
import 'package:visualpt/utils/validation_utils.dart';

part 'validation_event.dart';
part 'validation_state.dart';

class ValidationBloc extends Bloc<ValidationEvent, ValidationState> {
  final _storage = StorageService();
  // Internal list to keep track of processed IDs
  final List<String> processedKeys = [];
  // Internal list to keep track of procesed labels
  final List<int> _processedInputs = [];

  ValidationBloc() : super(const ValidationLoad()) {
    on<ValidationFetch>(_onFetch);
    on<ValidationPrev>(_onPrev);
    on<ValidationNext>(_onNext);
    on<ValidationInput>(_onInput);
    on<ValidationEnd>(_onEnd);
  }

  FutureOr<void> _onFetch(
      ValidationFetch event, Emitter<ValidationState> emit) async {
    final storedKeys = await _storage.listRawData();
    add(ValidationNext(keys: storedKeys));
  }

  FutureOr<void> _onPrev(
      ValidationPrev event, Emitter<ValidationState> emit) async {
    emit(const ValidationLoad());
    //Put the ID back into the list of unprocessed IDs
    String id = processedKeys.removeLast();
    final newKeys = [
      'raw/$id.csv',
      'raw/$id.png',
      'raw/${event.currentKey}.csv',
      'raw/${event.currentKey}.png',
      ...event.keys
    ];

    int label = _processedInputs.removeLast();
    if (label == 1) {
      await _storage.move(
          sourceKey: 'valid/$id.csv', destinationKey: 'raw/$id.csv');
      await _storage.move(
          sourceKey: 'valid/$id.png', destinationKey: 'raw/$id.png');
    } else {
      await _storage.move(
          sourceKey: 'invalid/$id.csv', destinationKey: 'raw/$id.csv');
      await _storage.move(
          sourceKey: 'invalid/$id.png', destinationKey: 'raw/$id.png');
    }
    add(ValidationNext(keys: newKeys));
  }

  FutureOr<void> _onNext(
      ValidationNext event, Emitter<ValidationState> emit) async {
    String imageID, dataID;
    //Get the image and data from the 'raw/' storage folder using the keys from the list
    //Get the id of the first item in the list
    log("ONTO THE NEXT ONE");
    try {
      if (event.keys.isNotEmpty) {
        final temp = event.keys.removeAt(0);
        //If  temp  contains a .csv then it is the data file
        String searchKey;
        if (temp.contains('.csv')) {
          dataID = temp;
          searchKey = temp.split('.').first.split('/').last;
          final imageIndex =
              event.keys.indexWhere((element) => element.contains(searchKey));
          if (imageIndex != -1) {
            imageID = event.keys.removeAt(imageIndex);
          } else {
            throw Exception('No image file found');
          }
        } else {
          imageID = temp;
          searchKey = temp.split('.').first.split('/').last;
          final dataIndex =
              event.keys.indexWhere((element) => element.contains(searchKey));
          if (dataIndex != -1) {
            dataID = event.keys.removeAt(dataIndex);
          } else {
            throw Exception('No data file found');
          }
        }
        //Get the image and data from the storage
        final imageResult = await _storage.download(key: imageID).result;
        final dataResult = await _storage.download(key: dataID).result;
        final dataOutput = String.fromCharCodes(dataResult.bytes);
        final imageMetadata = dataOutput.split('\n').first.split(',');

        final imageHeight = int.parse(imageMetadata.elementAt(0));
        final imageWidth = int.parse(imageMetadata.elementAt(1));
        final ratio = double.parse(imageMetadata.elementAt(2));
        final classification =
            int.parse(imageMetadata.elementAt(3)) == 1 ? true : false;
        final detection = dataOutput.substring(dataOutput.indexOf('\n'));

        final offsets = parsePoseOffsets(
            detection, imageHeight.toDouble(), imageWidth.toDouble());

        emit(ValidationDisplay(
          event.keys,
          key: searchKey,
          dataBytes: dataResult.bytes,
          imageBytes: imageResult.bytes,
          imageHeight: imageHeight,
          imageWidth: imageWidth,
          ratio: ratio,
          classification: classification,
          offsets: offsets,
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
      final oldData = String.fromCharCodes(event.dataBytes);
      final index = oldData.lastIndexOf(',', oldData.indexOf('\n') - 1);
      final newData =
          oldData.replaceRange(index + 1, index + 2, "${event.input}");
      final encodedData = utf8.encode(newData);

      _storage.remove(
          'raw/${event.key}.csv', amplify.StorageAccessLevel.private);
      _storage.upload(amplify.HttpPayload.bytes(encodedData),
          'valid/${event.key}.csv', amplify.StorageAccessLevel.private);
      _storage.move(
          sourceKey: 'raw/${event.key}.png',
          destinationKey: 'valid/${event.key}.png');
    } else {
      _storage.move(
          sourceKey: 'raw/${event.key}.csv',
          destinationKey: 'invalid/${event.key}.csv');
      _storage.move(
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
}
