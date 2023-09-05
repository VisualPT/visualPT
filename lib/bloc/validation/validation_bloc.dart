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
  final storage = StorageService();
  // Internal list to keep track of processed IDs
  final List<String> _processedKeys = [];
  // Internal list to keep track of procesed labels
  final List<int> _processedInputs = [];

  ValidationBloc() : super(const ValidationLoad([])) {
    on<ValidationFetch>(_onFetch);
    on<ValidationPrev>(_onPrev);
    on<ValidationNext>(_onNext);
    on<ValidationToggle>(_onToggle);
    on<ValidationInput>(_onInput);
    on<ValidationEnd>(_onEnd);
  }

  FutureOr<void> _onFetch(
      ValidationFetch event, Emitter<ValidationState> emit) async {
    final storedKeys = await storage.listRawData();
    add(ValidationNext(keys: storedKeys));
  }

  FutureOr<void> _onPrev(
      ValidationPrev event, Emitter<ValidationState> emit) async {
    //Put the ID back into the list of unprocessed IDs
    String id = _processedKeys.removeLast();
    int classification = _processedInputs.removeLast();
    event.keys.insert(0, event.currentKey);
    event.keys.insert(0, id);
    if (classification == 1) {
      storage.move(sourceKey: 'valid/$id.csv', destinationKey: 'raw/$id.csv');
      storage.move(sourceKey: 'valid/$id.png', destinationKey: 'raw/$id.png');
    } else {
      storage.move(sourceKey: 'invalid/$id.csv', destinationKey: 'raw/$id.csv');
      storage.move(sourceKey: 'invalid/$id.png', destinationKey: 'raw/$id.png');
    }
    add(ValidationNext(keys: event.keys));
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
        final imageResult = await storage
            .getUrl(imageID, amplify.StorageAccessLevel.private)
            .result;
        final dataResult = await storage
            .download(dataID, amplify.StorageAccessLevel.private)
            .result;
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
          imageUrl: imageResult.url.toString(),
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

  FutureOr<void> _onToggle(
      ValidationToggle event, Emitter<ValidationState> emit) {
    final oldData = String.fromCharCodes(event.data);

    final newLabel = event.classification ? 0 : 1;
    final newData =
        oldData.replaceFirst(",${event.classification},", ",$newLabel,");

    emit(ValidationDisplay(event.keys,
        key: event.key,
        dataBytes: utf8.encode(newData),
        imageUrl: event.imageUrl,
        imageHeight: event.imageHeight,
        imageWidth: event.imageWidth,
        ratio: event.ratio,
        classification: !event.classification,
        offsets: event.offsets));
  }

  FutureOr<void> _onInput(
      ValidationInput event, Emitter<ValidationState> emit) {
    //Store the ID of the image and data file in a list in case we need to go back
    _processedKeys.add(event.key);
    _processedInputs.add(event.input ? 1 : 0);
    //Store the validated data
    if (event.input) {
      storage.remove(
          'raw/${event.key}.csv', amplify.StorageAccessLevel.private);
      storage.upload(amplify.HttpPayload.bytes(event.dataBytes),
          'valid/${event.key}.csv', amplify.StorageAccessLevel.private);
      storage.move(
          sourceKey: 'raw/${event.key}.png',
          destinationKey: 'valid/${event.key}.png');
    } else {
      storage.move(
          sourceKey: 'raw/${event.key}.csv',
          destinationKey: 'invalid/${event.key}.csv');
      storage.move(
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
