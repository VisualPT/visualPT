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
class Detection extends amplify_core.Model {
  static const classType = const _DetectionModelType();
  final String id;
  final bool? _obtrustion;
  final bool? _instability;
  final DetectionEnv? _env;
  final String? _keypoints;
  final String? _prediction;
  final Trial? _trial;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  DetectionModelIdentifier get modelIdentifier {
      return DetectionModelIdentifier(
        id: id
      );
  }
  
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
  
  Trial? get trial {
    return _trial;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Detection._internal({required this.id, required obtrustion, required instability, required env, required keypoints, prediction, trial, createdAt, updatedAt}): _obtrustion = obtrustion, _instability = instability, _env = env, _keypoints = keypoints, _prediction = prediction, _trial = trial, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Detection({String? id, required bool obtrustion, required bool instability, required DetectionEnv env, required String keypoints, String? prediction, Trial? trial}) {
    return Detection._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      obtrustion: obtrustion,
      instability: instability,
      env: env,
      keypoints: keypoints,
      prediction: prediction,
      trial: trial);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Detection &&
      id == other.id &&
      _obtrustion == other._obtrustion &&
      _instability == other._instability &&
      _env == other._env &&
      _keypoints == other._keypoints &&
      _prediction == other._prediction &&
      _trial == other._trial;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Detection {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("obtrustion=" + (_obtrustion != null ? _obtrustion!.toString() : "null") + ", ");
    buffer.write("instability=" + (_instability != null ? _instability!.toString() : "null") + ", ");
    buffer.write("env=" + (_env != null ? _env!.toString() : "null") + ", ");
    buffer.write("keypoints=" + "$_keypoints" + ", ");
    buffer.write("prediction=" + "$_prediction" + ", ");
    buffer.write("trial=" + (_trial != null ? _trial!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Detection copyWith({bool? obtrustion, bool? instability, DetectionEnv? env, String? keypoints, String? prediction, Trial? trial}) {
    return Detection._internal(
      id: id,
      obtrustion: obtrustion ?? this.obtrustion,
      instability: instability ?? this.instability,
      env: env ?? this.env,
      keypoints: keypoints ?? this.keypoints,
      prediction: prediction ?? this.prediction,
      trial: trial ?? this.trial);
  }
  
  Detection copyWithModelFieldValues({
    ModelFieldValue<bool>? obtrustion,
    ModelFieldValue<bool>? instability,
    ModelFieldValue<DetectionEnv>? env,
    ModelFieldValue<String>? keypoints,
    ModelFieldValue<String?>? prediction,
    ModelFieldValue<Trial?>? trial
  }) {
    return Detection._internal(
      id: id,
      obtrustion: obtrustion == null ? this.obtrustion : obtrustion.value,
      instability: instability == null ? this.instability : instability.value,
      env: env == null ? this.env : env.value,
      keypoints: keypoints == null ? this.keypoints : keypoints.value,
      prediction: prediction == null ? this.prediction : prediction.value,
      trial: trial == null ? this.trial : trial.value
    );
  }
  
  Detection.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _obtrustion = json['obtrustion'],
      _instability = json['instability'],
      _env = json['env'] != null
          ? json['env']['serializedData'] != null
              ? DetectionEnv.fromJson(new Map<String, dynamic>.from(json['env']['serializedData']))
              : DetectionEnv.fromJson(new Map<String, dynamic>.from(json['env']))
        : null,
      _keypoints = json['keypoints'],
      _prediction = json['prediction'],
      _trial = json['trial'] != null
        ? json['trial']['serializedData'] != null
          ? Trial.fromJson(new Map<String, dynamic>.from(json['trial']['serializedData']))
          : Trial.fromJson(new Map<String, dynamic>.from(json['trial']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'obtrustion': _obtrustion, 'instability': _instability, 'env': _env?.toJson(), 'keypoints': _keypoints, 'prediction': _prediction, 'trial': _trial?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'obtrustion': _obtrustion,
    'instability': _instability,
    'env': _env,
    'keypoints': _keypoints,
    'prediction': _prediction,
    'trial': _trial,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<DetectionModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<DetectionModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final OBTRUSTION = amplify_core.QueryField(fieldName: "obtrustion");
  static final INSTABILITY = amplify_core.QueryField(fieldName: "instability");
  static final ENV = amplify_core.QueryField(fieldName: "env");
  static final KEYPOINTS = amplify_core.QueryField(fieldName: "keypoints");
  static final PREDICTION = amplify_core.QueryField(fieldName: "prediction");
  static final TRIAL = amplify_core.QueryField(
    fieldName: "trial",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Trial'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Detection";
    modelSchemaDefinition.pluralName = "Detections";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.OWNER,
        ownerField: "owner",
        identityClaim: "cognito:username",
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ]),
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.GROUPS,
        groupClaim: "cognito:groups",
        groups: [ "admin" ],
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["trialId"], name: "detectionsByTrialId")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Detection.OBTRUSTION,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Detection.INSTABILITY,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.embedded(
      fieldName: 'env',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.embedded, ofCustomTypeName: 'DetectionEnv')
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Detection.KEYPOINTS,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Detection.PREDICTION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Detection.TRIAL,
      isRequired: false,
      targetNames: ['trialId'],
      ofModelName: 'Trial'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _DetectionModelType extends amplify_core.ModelType<Detection> {
  const _DetectionModelType();
  
  @override
  Detection fromJson(Map<String, dynamic> jsonData) {
    return Detection.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Detection';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Detection] in your schema.
 */
class DetectionModelIdentifier implements amplify_core.ModelIdentifier<Detection> {
  final String id;

  /** Create an instance of DetectionModelIdentifier using [id] the primary key. */
  const DetectionModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'DetectionModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is DetectionModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}