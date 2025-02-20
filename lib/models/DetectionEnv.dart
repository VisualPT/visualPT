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
  final amplify_core.TemporalDateTime? _timestamp;
  final double? _accX;
  final double? _accY;
  final double? _accZ;

  amplify_core.TemporalDateTime get timestamp {
    try {
      return _timestamp!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double get accX {
    try {
      return _accX!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double get accY {
    try {
      return _accY!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double get accZ {
    try {
      return _accZ!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  const DetectionEnv._internal({required timestamp, required accX, required accY, required accZ}): _timestamp = timestamp, _accX = accX, _accY = accY, _accZ = accZ;
  
  factory DetectionEnv({required amplify_core.TemporalDateTime timestamp, required double accX, required double accY, required double accZ}) {
    return DetectionEnv._internal(
      timestamp: timestamp,
      accX: accX,
      accY: accY,
      accZ: accZ);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DetectionEnv &&
      _timestamp == other._timestamp &&
      _accX == other._accX &&
      _accY == other._accY &&
      _accZ == other._accZ;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("DetectionEnv {");
    buffer.write("timestamp=" + (_timestamp != null ? _timestamp!.format() : "null") + ", ");
    buffer.write("accX=" + (_accX != null ? _accX!.toString() : "null") + ", ");
    buffer.write("accY=" + (_accY != null ? _accY!.toString() : "null") + ", ");
    buffer.write("accZ=" + (_accZ != null ? _accZ!.toString() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  DetectionEnv copyWith({amplify_core.TemporalDateTime? timestamp, double? accX, double? accY, double? accZ}) {
    return DetectionEnv._internal(
      timestamp: timestamp ?? this.timestamp,
      accX: accX ?? this.accX,
      accY: accY ?? this.accY,
      accZ: accZ ?? this.accZ);
  }
  
  DetectionEnv copyWithModelFieldValues({
    ModelFieldValue<amplify_core.TemporalDateTime>? timestamp,
    ModelFieldValue<double>? accX,
    ModelFieldValue<double>? accY,
    ModelFieldValue<double>? accZ
  }) {
    return DetectionEnv._internal(
      timestamp: timestamp == null ? this.timestamp : timestamp.value,
      accX: accX == null ? this.accX : accX.value,
      accY: accY == null ? this.accY : accY.value,
      accZ: accZ == null ? this.accZ : accZ.value
    );
  }
  
  DetectionEnv.fromJson(Map<String, dynamic> json)  
    : _timestamp = json['timestamp'] != null ? amplify_core.TemporalDateTime.fromString(json['timestamp']) : null,
      _accX = (json['accX'] as num?)?.toDouble(),
      _accY = (json['accY'] as num?)?.toDouble(),
      _accZ = (json['accZ'] as num?)?.toDouble();
  
  Map<String, dynamic> toJson() => {
    'timestamp': _timestamp?.format(), 'accX': _accX, 'accY': _accY, 'accZ': _accZ
  };
  
  Map<String, Object?> toMap() => {
    'timestamp': _timestamp,
    'accX': _accX,
    'accY': _accY,
    'accZ': _accZ
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "DetectionEnv";
    modelSchemaDefinition.pluralName = "DetectionEnvs";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'timestamp',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'accX',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'accY',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'accZ',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
  });
}