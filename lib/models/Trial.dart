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


/** This is an auto generated class representing the Trial type in your schema. */
class Trial extends amplify_core.Model {
  static const classType = const _TrialModelType();
  final String id;
  final amplify_core.TemporalDateTime? _startTime;
  final double? _duration;
  final Stage? _stage;
  final String? _compressedKeypoints;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  TrialModelIdentifier get modelIdentifier {
      return TrialModelIdentifier(
        id: id
      );
  }
  
  amplify_core.TemporalDateTime get startTime {
    try {
      return _startTime!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double get duration {
    try {
      return _duration!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  Stage? get stage {
    return _stage;
  }
  
  String get compressedKeypoints {
    try {
      return _compressedKeypoints!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Trial._internal({required this.id, required startTime, required duration, stage, required compressedKeypoints, createdAt, updatedAt}): _startTime = startTime, _duration = duration, _stage = stage, _compressedKeypoints = compressedKeypoints, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Trial({String? id, required amplify_core.TemporalDateTime startTime, required double duration, Stage? stage, required String compressedKeypoints}) {
    return Trial._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      startTime: startTime,
      duration: duration,
      stage: stage,
      compressedKeypoints: compressedKeypoints);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Trial &&
      id == other.id &&
      _startTime == other._startTime &&
      _duration == other._duration &&
      _stage == other._stage &&
      _compressedKeypoints == other._compressedKeypoints;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Trial {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("startTime=" + (_startTime != null ? _startTime!.format() : "null") + ", ");
    buffer.write("duration=" + (_duration != null ? _duration!.toString() : "null") + ", ");
    buffer.write("stage=" + (_stage != null ? _stage!.toString() : "null") + ", ");
    buffer.write("compressedKeypoints=" + "$_compressedKeypoints" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Trial copyWith({amplify_core.TemporalDateTime? startTime, double? duration, Stage? stage, String? compressedKeypoints}) {
    return Trial._internal(
      id: id,
      startTime: startTime ?? this.startTime,
      duration: duration ?? this.duration,
      stage: stage ?? this.stage,
      compressedKeypoints: compressedKeypoints ?? this.compressedKeypoints);
  }
  
  Trial copyWithModelFieldValues({
    ModelFieldValue<amplify_core.TemporalDateTime>? startTime,
    ModelFieldValue<double>? duration,
    ModelFieldValue<Stage?>? stage,
    ModelFieldValue<String>? compressedKeypoints
  }) {
    return Trial._internal(
      id: id,
      startTime: startTime == null ? this.startTime : startTime.value,
      duration: duration == null ? this.duration : duration.value,
      stage: stage == null ? this.stage : stage.value,
      compressedKeypoints: compressedKeypoints == null ? this.compressedKeypoints : compressedKeypoints.value
    );
  }
  
  Trial.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _startTime = json['startTime'] != null ? amplify_core.TemporalDateTime.fromString(json['startTime']) : null,
      _duration = (json['duration'] as num?)?.toDouble(),
      _stage = json['stage'] != null
        ? json['stage']['serializedData'] != null
          ? Stage.fromJson(new Map<String, dynamic>.from(json['stage']['serializedData']))
          : Stage.fromJson(new Map<String, dynamic>.from(json['stage']))
        : null,
      _compressedKeypoints = json['compressedKeypoints'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'startTime': _startTime?.format(), 'duration': _duration, 'stage': _stage?.toJson(), 'compressedKeypoints': _compressedKeypoints, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'startTime': _startTime,
    'duration': _duration,
    'stage': _stage,
    'compressedKeypoints': _compressedKeypoints,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<TrialModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<TrialModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final STARTTIME = amplify_core.QueryField(fieldName: "startTime");
  static final DURATION = amplify_core.QueryField(fieldName: "duration");
  static final STAGE = amplify_core.QueryField(
    fieldName: "stage",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Stage'));
  static final COMPRESSEDKEYPOINTS = amplify_core.QueryField(fieldName: "compressedKeypoints");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Trial";
    modelSchemaDefinition.pluralName = "Trials";
    
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
      amplify_core.ModelIndex(fields: const ["stageId"], name: "trialsByStageId")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Trial.STARTTIME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Trial.DURATION,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Trial.STAGE,
      isRequired: false,
      targetNames: ['stageId'],
      ofModelName: 'Stage'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Trial.COMPRESSEDKEYPOINTS,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
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

class _TrialModelType extends amplify_core.ModelType<Trial> {
  const _TrialModelType();
  
  @override
  Trial fromJson(Map<String, dynamic> jsonData) {
    return Trial.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Trial';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Trial] in your schema.
 */
class TrialModelIdentifier implements amplify_core.ModelIdentifier<Trial> {
  final String id;

  /** Create an instance of TrialModelIdentifier using [id] the primary key. */
  const TrialModelIdentifier({
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
  String toString() => 'TrialModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is TrialModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}