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


/** This is an auto generated class representing the Condition type in your schema. */
class Condition extends amplify_core.Model {
  static const classType = const _ConditionModelType();
  final String id;
  final String? _assessmentID;
  final int? _sequenceNumber;
  final double? _duration;
  final List<Trial>? _trials;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ConditionModelIdentifier get modelIdentifier {
      return ConditionModelIdentifier(
        id: id
      );
  }
  
  String get assessmentID {
    try {
      return _assessmentID!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get sequenceNumber {
    try {
      return _sequenceNumber!;
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
  
  List<Trial>? get trials {
    return _trials;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Condition._internal({required this.id, required assessmentID, required sequenceNumber, required duration, trials, createdAt, updatedAt}): _assessmentID = assessmentID, _sequenceNumber = sequenceNumber, _duration = duration, _trials = trials, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Condition({String? id, required String assessmentID, required int sequenceNumber, required double duration, List<Trial>? trials}) {
    return Condition._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      assessmentID: assessmentID,
      sequenceNumber: sequenceNumber,
      duration: duration,
      trials: trials != null ? List<Trial>.unmodifiable(trials) : trials);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Condition &&
      id == other.id &&
      _assessmentID == other._assessmentID &&
      _sequenceNumber == other._sequenceNumber &&
      _duration == other._duration &&
      DeepCollectionEquality().equals(_trials, other._trials);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Condition {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("assessmentID=" + "$_assessmentID" + ", ");
    buffer.write("sequenceNumber=" + (_sequenceNumber != null ? _sequenceNumber!.toString() : "null") + ", ");
    buffer.write("duration=" + (_duration != null ? _duration!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Condition copyWith({String? assessmentID, int? sequenceNumber, double? duration, List<Trial>? trials}) {
    return Condition._internal(
      id: id,
      assessmentID: assessmentID ?? this.assessmentID,
      sequenceNumber: sequenceNumber ?? this.sequenceNumber,
      duration: duration ?? this.duration,
      trials: trials ?? this.trials);
  }
  
  Condition copyWithModelFieldValues({
    ModelFieldValue<String>? assessmentID,
    ModelFieldValue<int>? sequenceNumber,
    ModelFieldValue<double>? duration,
    ModelFieldValue<List<Trial>>? trials
  }) {
    return Condition._internal(
      id: id,
      assessmentID: assessmentID == null ? this.assessmentID : assessmentID.value,
      sequenceNumber: sequenceNumber == null ? this.sequenceNumber : sequenceNumber.value,
      duration: duration == null ? this.duration : duration.value,
      trials: trials == null ? this.trials : trials.value
    );
  }
  
  Condition.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _assessmentID = json['assessmentID'],
      _sequenceNumber = (json['sequenceNumber'] as num?)?.toInt(),
      _duration = (json['duration'] as num?)?.toDouble(),
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
    'id': id, 'assessmentID': _assessmentID, 'sequenceNumber': _sequenceNumber, 'duration': _duration, 'trials': _trials?.map((Trial? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'assessmentID': _assessmentID,
    'sequenceNumber': _sequenceNumber,
    'duration': _duration,
    'trials': _trials,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ConditionModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ConditionModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final ASSESSMENTID = amplify_core.QueryField(fieldName: "assessmentID");
  static final SEQUENCENUMBER = amplify_core.QueryField(fieldName: "sequenceNumber");
  static final DURATION = amplify_core.QueryField(fieldName: "duration");
  static final TRIALS = amplify_core.QueryField(
    fieldName: "trials",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Trial'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Condition";
    modelSchemaDefinition.pluralName = "Conditions";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.GROUPS,
        groupClaim: "cognito:groups",
        groups: [ "Admin" ],
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ]),
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
        ])
    ];
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["assessmentID"], name: "byAssessment")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Condition.ASSESSMENTID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Condition.SEQUENCENUMBER,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Condition.DURATION,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Condition.TRIALS,
      isRequired: true,
      ofModelName: 'Trial',
      associatedKey: Trial.CONDITIONID
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

class _ConditionModelType extends amplify_core.ModelType<Condition> {
  const _ConditionModelType();
  
  @override
  Condition fromJson(Map<String, dynamic> jsonData) {
    return Condition.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Condition';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Condition] in your schema.
 */
class ConditionModelIdentifier implements amplify_core.ModelIdentifier<Condition> {
  final String id;

  /** Create an instance of ConditionModelIdentifier using [id] the primary key. */
  const ConditionModelIdentifier({
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
  String toString() => 'ConditionModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ConditionModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}