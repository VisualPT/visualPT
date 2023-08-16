import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:amplify_flutter/amplify_flutter.dart' as amplify;
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:visualpt/service/storage_service.dart';
import 'package:visualpt/utils/validation_utils.dart';

part 'validation_event.dart';
part 'validation_state.dart';

class ValidationBloc extends Bloc<ValidationEvent, ValidationState> {
  final storage = StorageService();

  ValidationBloc() : super(const ValidationLoad([])) {
    on<ValidationFetch>(_onFetch);
    on<ValidationNext>(_onNext);
    on<ValidationInput>(_onInput);
    on<ValidationEnd>(_onEnd);
  }

  FutureOr<void> _onFetch(
      ValidationFetch event, Emitter<ValidationState> emit) async {
    final storedKeys = await storage.listRawData();
    add(ValidationNext(keys: storedKeys));
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
          searchKey = temp.split('.').first;
          final dataIndex =
              event.keys.indexWhere((element) => element.contains(searchKey));
          if (dataIndex != -1) {
            dataID = event.keys.removeAt(dataIndex);
          } else {
            throw Exception('No data file found');
          }
        }
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
        final classification = int.parse(imageMetadata.elementAt(3));
        final detection = dataOutput.substring(dataOutput.indexOf('\n'));

        final offsets = parsePoseOffsets(
            detection, imageHeight.toDouble(), imageWidth.toDouble());

        emit(ValidationDisplay(
          event.keys,
          key: searchKey,
          originalDataBytes: dataResult.bytes,
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

  FutureOr<void> _onInput(
      ValidationInput event, Emitter<ValidationState> emit) {
    //Store the validated data
    if (event.input) {
      storage.upload(S3DataPayload.bytes(event.originalDataBytes),
          'valid/${event.key}.csv', amplify.StorageAccessLevel.guest);
    }
    storage.remove('raw/${event.key}.csv', amplify.StorageAccessLevel.private);
    storage.remove('raw/${event.key}.png', amplify.StorageAccessLevel.private);
    //Start the next validation
    add(ValidationNext(keys: event.keys));
  }

  FutureOr<void> _onEnd(ValidationEnd event, Emitter<ValidationState> emit) {
    log("No more data to validate");
    emit(const ValidationDispose([]));
  }
}
