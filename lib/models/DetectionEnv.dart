/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;


/** This is an auto generated class representing the DetectionEnv type in your schema. */
class DetectionEnv {
  final int? _imageHeight;
  final int? _imageWidth;
  final double? _accX;
  final double? _accY;
  final double? _accZ;
  final double? _gyroX;
  final double? _gyroY;
  final double? _gyroZ;
  final amplify_core.TemporalDateTime? _timestamp;

  int? get imageHeight {
    return _imageHeight;
  }
  
  int? get imageWidth {
    return _imageWidth;
  }
  
  double? get accX {
    return _accX;
  }
  
  double? get accY {
    return _accY;
  }
  
  double? get accZ {
    return _accZ;
  }
  
  double? get gyroX {
    return _gyroX;
  }
  
  double? get gyroY {
    return _gyroY;
  }
  
  double? get gyroZ {
    return _gyroZ;
  }
  
  amplify_core.TemporalDateTime? get timestamp {
    return _timestamp;
  }
  
  const DetectionEnv._internal({imageHeight, imageWidth, accX, accY, accZ, gyroX, gyroY, gyroZ, timestamp}): _imageHeight = imageHeight, _imageWidth = imageWidth, _accX = accX, _accY = accY, _accZ = accZ, _gyroX = gyroX, _gyroY = gyroY, _gyroZ = gyroZ, _timestamp = timestamp;
  
  factory DetectionEnv({int? imageHeight, int? imageWidth, double? accX, double? accY, double? accZ, double? gyroX, double? gyroY, double? gyroZ, amplify_core.TemporalDateTime? timestamp}) {
    return DetectionEnv._internal(
      imageHeight: imageHeight,
      imageWidth: imageWidth,
      accX: accX,
      accY: accY,
      accZ: accZ,
      gyroX: gyroX,
      gyroY: gyroY,
      gyroZ: gyroZ,
      timestamp: timestamp);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DetectionEnv &&
      _imageHeight == other._imageHeight &&
      _imageWidth == other._imageWidth &&
      _accX == other._accX &&
      _accY == other._accY &&
      _accZ == other._accZ &&
      _gyroX == other._gyroX &&
      _gyroY == other._gyroY &&
      _gyroZ == other._gyroZ &&
      _timestamp == other._timestamp;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("DetectionEnv {");
    buffer.write("imageHeight=" + (_imageHeight != null ? _imageHeight!.toString() : "null") + ", ");
    buffer.write("imageWidth=" + (_imageWidth != null ? _imageWidth!.toString() : "null") + ", ");
    buffer.write("accX=" + (_accX != null ? _accX!.toString() : "null") + ", ");
    buffer.write("accY=" + (_accY != null ? _accY!.toString() : "null") + ", ");
    buffer.write("accZ=" + (_accZ != null ? _accZ!.toString() : "null") + ", ");
    buffer.write("gyroX=" + (_gyroX != null ? _gyroX!.toString() : "null") + ", ");
    buffer.write("gyroY=" + (_gyroY != null ? _gyroY!.toString() : "null") + ", ");
    buffer.write("gyroZ=" + (_gyroZ != null ? _gyroZ!.toString() : "null") + ", ");
    buffer.write("timestamp=" + (_timestamp != null ? _timestamp!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  DetectionEnv copyWith({int? imageHeight, int? imageWidth, double? accX, double? accY, double? accZ, double? gyroX, double? gyroY, double? gyroZ, amplify_core.TemporalDateTime? timestamp}) {
    return DetectionEnv._internal(
      imageHeight: imageHeight ?? this.imageHeight,
      imageWidth: imageWidth ?? this.imageWidth,
      accX: accX ?? this.accX,
      accY: accY ?? this.accY,
      accZ: accZ ?? this.accZ,
      gyroX: gyroX ?? this.gyroX,
      gyroY: gyroY ?? this.gyroY,
      gyroZ: gyroZ ?? this.gyroZ,
      timestamp: timestamp ?? this.timestamp);
  }
  
  DetectionEnv copyWithModelFieldValues({
    ModelFieldValue<int?>? imageHeight,
    ModelFieldValue<int?>? imageWidth,
    ModelFieldValue<double?>? accX,
    ModelFieldValue<double?>? accY,
    ModelFieldValue<double?>? accZ,
    ModelFieldValue<double?>? gyroX,
    ModelFieldValue<double?>? gyroY,
    ModelFieldValue<double?>? gyroZ,
    ModelFieldValue<amplify_core.TemporalDateTime?>? timestamp
  }) {
    return DetectionEnv._internal(
      imageHeight: imageHeight == null ? this.imageHeight : imageHeight.value,
      imageWidth: imageWidth == null ? this.imageWidth : imageWidth.value,
      accX: accX == null ? this.accX : accX.value,
      accY: accY == null ? this.accY : accY.value,
      accZ: accZ == null ? this.accZ : accZ.value,
      gyroX: gyroX == null ? this.gyroX : gyroX.value,
      gyroY: gyroY == null ? this.gyroY : gyroY.value,
      gyroZ: gyroZ == null ? this.gyroZ : gyroZ.value,
      timestamp: timestamp == null ? this.timestamp : timestamp.value
    );
  }
  
  DetectionEnv.fromJson(Map<String, dynamic> json)  
    : _imageHeight = (json['imageHeight'] as num?)?.toInt(),
      _imageWidth = (json['imageWidth'] as num?)?.toInt(),
      _accX = (json['accX'] as num?)?.toDouble(),
      _accY = (json['accY'] as num?)?.toDouble(),
      _accZ = (json['accZ'] as num?)?.toDouble(),
      _gyroX = (json['gyroX'] as num?)?.toDouble(),
      _gyroY = (json['gyroY'] as num?)?.toDouble(),
      _gyroZ = (json['gyroZ'] as num?)?.toDouble(),
      _timestamp = json['timestamp'] != null ? amplify_core.TemporalDateTime.fromString(json['timestamp']) : null;
  
  Map<String, dynamic> toJson() => {
    'imageHeight': _imageHeight, 'imageWidth': _imageWidth, 'accX': _accX, 'accY': _accY, 'accZ': _accZ, 'gyroX': _gyroX, 'gyroY': _gyroY, 'gyroZ': _gyroZ, 'timestamp': _timestamp?.format()
  };
  
  Map<String, Object?> toMap() => {
    'imageHeight': _imageHeight,
    'imageWidth': _imageWidth,
    'accX': _accX,
    'accY': _accY,
    'accZ': _accZ,
    'gyroX': _gyroX,
    'gyroY': _gyroY,
    'gyroZ': _gyroZ,
    'timestamp': _timestamp
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "DetectionEnv";
    modelSchemaDefinition.pluralName = "DetectionEnvs";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'imageHeight',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'imageWidth',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'accX',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'accY',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'accZ',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'gyroX',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'gyroY',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'gyroZ',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'timestamp',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}