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
import 'package:collection/collection.dart';


/** This is an auto generated class representing the Stage type in your schema. */
class Stage extends amplify_core.Model {
  static const classType = const _StageModelType();
  final String id;
  final int? _stageNumber;
  final double? _duration;
  final Assessment? _assessment;
  final List<Trial>? _trials;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  StageModelIdentifier get modelIdentifier {
      return StageModelIdentifier(
        id: id
      );
  }
  
  int get stageNumber {
    try {
      return _stageNumber!;
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
  
  Assessment? get assessment {
    return _assessment;
  }
  
  List<Trial>? get trials {
    return _trials;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Stage._internal({required this.id, required stageNumber, required duration, assessment, trials, createdAt, updatedAt}): _stageNumber = stageNumber, _duration = duration, _assessment = assessment, _trials = trials, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Stage({String? id, required int stageNumber, required double duration, Assessment? assessment, List<Trial>? trials}) {
    return Stage._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      stageNumber: stageNumber,
      duration: duration,
      assessment: assessment,
      trials: trials != null ? List<Trial>.unmodifiable(trials) : trials);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Stage &&
      id == other.id &&
      _stageNumber == other._stageNumber &&
      _duration == other._duration &&
      _assessment == other._assessment &&
      DeepCollectionEquality().equals(_trials, other._trials);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Stage {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("stageNumber=" + (_stageNumber != null ? _stageNumber!.toString() : "null") + ", ");
    buffer.write("duration=" + (_duration != null ? _duration!.toString() : "null") + ", ");
    buffer.write("assessment=" + (_assessment != null ? _assessment!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Stage copyWith({int? stageNumber, double? duration, Assessment? assessment, List<Trial>? trials}) {
    return Stage._internal(
      id: id,
      stageNumber: stageNumber ?? this.stageNumber,
      duration: duration ?? this.duration,
      assessment: assessment ?? this.assessment,
      trials: trials ?? this.trials);
  }
  
  Stage copyWithModelFieldValues({
    ModelFieldValue<int>? stageNumber,
    ModelFieldValue<double>? duration,
    ModelFieldValue<Assessment?>? assessment,
    ModelFieldValue<List<Trial>?>? trials
  }) {
    return Stage._internal(
      id: id,
      stageNumber: stageNumber == null ? this.stageNumber : stageNumber.value,
      duration: duration == null ? this.duration : duration.value,
      assessment: assessment == null ? this.assessment : assessment.value,
      trials: trials == null ? this.trials : trials.value
    );
  }
  
  Stage.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _stageNumber = (json['stageNumber'] as num?)?.toInt(),
      _duration = (json['duration'] as num?)?.toDouble(),
      _assessment = json['assessment'] != null
        ? json['assessment']['serializedData'] != null
          ? Assessment.fromJson(new Map<String, dynamic>.from(json['assessment']['serializedData']))
          : Assessment.fromJson(new Map<String, dynamic>.from(json['assessment']))
        : null,
      _trials = json['trials']  is Map
        ? (json['trials']['items'] is List
          ? (json['trials']['items'] as List)
              .where((e) => e != null)
              .map((e) => Trial.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['trials'] is List
          ? (json['trials'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => Trial.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'stageNumber': _stageNumber, 'duration': _duration, 'assessment': _assessment?.toJson(), 'trials': _trials?.map((Trial? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'stageNumber': _stageNumber,
    'duration': _duration,
    'assessment': _assessment,
    'trials': _trials,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<StageModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<StageModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final STAGENUMBER = amplify_core.QueryField(fieldName: "stageNumber");
  static final DURATION = amplify_core.QueryField(fieldName: "duration");
  static final ASSESSMENT = amplify_core.QueryField(
    fieldName: "assessment",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Assessment'));
  static final TRIALS = amplify_core.QueryField(
    fieldName: "trials",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Trial'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Stage";
    modelSchemaDefinition.pluralName = "Stages";
    
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
      amplify_core.ModelIndex(fields: const ["assessmentId"], name: "stagesByAssessmentId")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Stage.STAGENUMBER,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Stage.DURATION,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Stage.ASSESSMENT,
      isRequired: false,
      targetNames: ['assessmentId'],
      ofModelName: 'Assessment'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Stage.TRIALS,
      isRequired: false,
      ofModelName: 'Trial',
      associatedKey: Trial.STAGE
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

class _StageModelType extends amplify_core.ModelType<Stage> {
  const _StageModelType();
  
  @override
  Stage fromJson(Map<String, dynamic> jsonData) {
    return Stage.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Stage';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Stage] in your schema.
 */
class StageModelIdentifier implements amplify_core.ModelIdentifier<Stage> {
  final String id;

  /** Create an instance of StageModelIdentifier using [id] the primary key. */
  const StageModelIdentifier({
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
  String toString() => 'StageModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is StageModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}