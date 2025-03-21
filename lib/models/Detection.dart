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


/** This is an auto generated class representing the Detection type in your schema. */
class Detection {
  final bool? _obtrustion;
  final bool? _instability;
  final DetectionEnv? _env;
  final String? _keypoints;
  final String? _prediction;

  bool get obtrustion {
    try {
      return _obtrustion!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  bool get instability {
    try {
      return _instability!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  DetectionEnv get env {
    try {
      return _env!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get keypoints {
    try {
      return _keypoints!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get prediction {
    return _prediction;
  }
  
  const Detection._internal({required obtrustion, required instability, required env, required keypoints, prediction}): _obtrustion = obtrustion, _instability = instability, _env = env, _keypoints = keypoints, _prediction = prediction;
  
  factory Detection({required bool obtrustion, required bool instability, required DetectionEnv env, required String keypoints, String? prediction}) {
    return Detection._internal(
      obtrustion: obtrustion,
      instability: instability,
      env: env,
      keypoints: keypoints,
      prediction: prediction);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Detection &&
      _obtrustion == other._obtrustion &&
      _instability == other._instability &&
      _env == other._env &&
      _keypoints == other._keypoints &&
      _prediction == other._prediction;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Detection {");
    buffer.write("obtrustion=" + (_obtrustion != null ? _obtrustion!.toString() : "null") + ", ");
    buffer.write("instability=" + (_instability != null ? _instability!.toString() : "null") + ", ");
    buffer.write("env=" + (_env != null ? _env!.toString() : "null") + ", ");
    buffer.write("keypoints=" + "$_keypoints" + ", ");
    buffer.write("prediction=" + "$_prediction");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Detection copyWith({bool? obtrustion, bool? instability, DetectionEnv? env, String? keypoints, String? prediction}) {
    return Detection._internal(
      obtrustion: obtrustion ?? this.obtrustion,
      instability: instability ?? this.instability,
      env: env ?? this.env,
      keypoints: keypoints ?? this.keypoints,
      prediction: prediction ?? this.prediction);
  }
  
  Detection copyWithModelFieldValues({
    ModelFieldValue<bool>? obtrustion,
    ModelFieldValue<bool>? instability,
    ModelFieldValue<DetectionEnv>? env,
    ModelFieldValue<String>? keypoints,
    ModelFieldValue<String?>? prediction
  }) {
    return Detection._internal(
      obtrustion: obtrustion == null ? this.obtrustion : obtrustion.value,
      instability: instability == null ? this.instability : instability.value,
      env: env == null ? this.env : env.value,
      keypoints: keypoints == null ? this.keypoints : keypoints.value,
      prediction: prediction == null ? this.prediction : prediction.value
    );
  }
  
  Detection.fromJson(Map<String, dynamic> json)  
    : _obtrustion = json['obtrustion'],
      _instability = json['instability'],
      _env = json['env'] != null
          ? json['env']['serializedData'] != null
              ? DetectionEnv.fromJson(new Map<String, dynamic>.from(json['env']['serializedData']))
              : DetectionEnv.fromJson(new Map<String, dynamic>.from(json['env']))
        : null,
      _keypoints = json['keypoints'],
      _prediction = json['prediction'];
  
  Map<String, dynamic> toJson() => {
    'obtrustion': _obtrustion, 'instability': _instability, 'env': _env?.toJson(), 'keypoints': _keypoints, 'prediction': _prediction
  };
  
  Map<String, Object?> toMap() => {
    'obtrustion': _obtrustion,
    'instability': _instability,
    'env': _env,
    'keypoints': _keypoints,
    'prediction': _prediction
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Detection";
    modelSchemaDefinition.pluralName = "Detections";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'obtrustion',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'instability',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.embedded(
      fieldName: 'env',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.embedded, ofCustomTypeName: 'DetectionEnv')
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'keypoints',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'prediction',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
  });
}