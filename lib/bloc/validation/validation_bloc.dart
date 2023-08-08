import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

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
  }

  FutureOr<void> _onFetch(
      ValidationFetch event, Emitter<ValidationState> emit) async {
    final storedKeys = await storage.listRawData();
    add(ValidationNext(keys: storedKeys));
    //TODO: Get the ValidationData from this response
  }

  FutureOr<void> _onNext(
      ValidationNext event, Emitter<ValidationState> emit) async {
    String imageID, dataID;
    //Get the image and data from the 'raw/' storage folder using the keys from the list
    //Get the id of the first item in the list
    print("ONTO THE NEXT ONE");
    try {
      if (event.keys.isNotEmpty) {
        final temp = event.keys.removeAt(0);
        //If  temp  contains a . then it is an image
        if (temp.contains('.')) {
          dataID = temp;
          final imageIndex = event.keys
              .indexWhere((element) => element.contains(temp.split('.').first));
          if (imageIndex != -1) {
            imageID = event.keys.removeAt(imageIndex);
          } else {
            throw Exception('No image file found');
          }
        } else {
          imageID = temp;
          final dataIndex = event.keys
              .indexWhere((element) => element.contains(temp.split('=').first));
          if (dataIndex != -1) {
            dataID = event.keys.removeAt(dataIndex);
          } else {
            throw Exception('No data file found');
          }
        }
        final imageResult = await storage.download(imageID).result;
        final dataResult = await storage.download(dataID).result;
        final dataOutput = String.fromCharCodes(dataResult.bytes);
        final imageMetadata = dataOutput.split('\n').first.split(',');

        //TODO: Pass this to a proper image format for visualization
        final Uint8List uint8list = Uint8List.fromList(imageResult.bytes);
        final classification = int.parse(imageMetadata.elementAt(0));
        final detection = dataOutput.substring(dataOutput.indexOf('\n'));

        final offsets = parseOffsets(detection);

        print("displaying");
        emit(ValidationDisplay(
          event.keys,
          key: dataID,
          imageData: uint8list,
          imageRatio: double.parse(imageMetadata.elementAt(0)) /
              double.parse(imageMetadata.elementAt(0)),
          classification: classification,
          offsets: offsets,
        ));
      }
    } on Exception catch (e) {
      print(e);
      add(ValidationNext(keys: event.keys));
    }
  }

  FutureOr<void> _onInput(
      ValidationInput event, Emitter<ValidationState> emit) {
    //Store the validated data
    storage.moveFile(
        sourceKey: 'raw/${event.key}', destinationKey: 'valid/${event.key}');
    //Start the next validation
    add(ValidationNext(keys: event.keys));
  }
}
