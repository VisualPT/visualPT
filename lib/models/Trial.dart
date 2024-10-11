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


/** This is an auto generated class representing the Trial type in your schema. */
class Trial extends amplify_core.Model {
  static const classType = const _TrialModelType();
  final String id;
  final String? _conditionID;
  final amplify_core.TemporalDateTime? _start_time;
  final double? _duration;
  final List<Detection>? _Detections;
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
  
  String get conditionID {
    try {
      return _conditionID!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime get start_time {
    try {
      return _start_time!;
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
  
  List<Detection>? get Detections {
    return _Detections;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Trial._internal({required this.id, required conditionID, required start_time, required duration, Detections, createdAt, updatedAt}): _conditionID = conditionID, _start_time = start_time, _duration = duration, _Detections = Detections, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Trial({String? id, required String conditionID, required amplify_core.TemporalDateTime start_time, required double duration, List<Detection>? Detections}) {
    return Trial._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      conditionID: conditionID,
      start_time: start_time,
      duration: duration,
      Detections: Detections != null ? List<Detection>.unmodifiable(Detections) : Detections);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Trial &&
      id == other.id &&
      _conditionID == other._conditionID &&
      _start_time == other._start_time &&
      _duration == other._duration &&
      DeepCollectionEquality().equals(_Detections, other._Detections);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Trial {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("conditionID=" + "$_conditionID" + ", ");
    buffer.write("start_time=" + (_start_time != null ? _start_time!.format() : "null") + ", ");
    buffer.write("duration=" + (_duration != null ? _duration!.toString() : "null") + ", ");
    buffer.write("Detections=" + (_Detections != null ? _Detections!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Trial copyWith({String? conditionID, amplify_core.TemporalDateTime? start_time, double? duration, List<Detection>? Detections}) {
    return Trial._internal(
      id: id,
      conditionID: conditionID ?? this.conditionID,
      start_time: start_time ?? this.start_time,
      duration: duration ?? this.duration,
      Detections: Detections ?? this.Detections);
  }
  
  Trial copyWithModelFieldValues({
    ModelFieldValue<String>? conditionID,
    ModelFieldValue<amplify_core.TemporalDateTime>? start_time,
    ModelFieldValue<double>? duration,
    ModelFieldValue<List<Detection>>? Detections
  }) {
    return Trial._internal(
      id: id,
      conditionID: conditionID == null ? this.conditionID : conditionID.value,
      start_time: start_time == null ? this.start_time : start_time.value,
      duration: duration == null ? this.duration : duration.value,
      Detections: Detections == null ? this.Detections : Detections.value
    );
  }
  
  Trial.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _conditionID = json['conditionID'],
      _start_time = json['start_time'] != null ? amplify_core.TemporalDateTime.fromString(json['start_time']) : null,
      _duration = (json['duration'] as num?)?.toDouble(),
      _Detections = json['Detections'] is List
        ? (json['Detections'] as List)
          .where((e) => e != null)
          .map((e) => Detection.fromJson(new Map<String, dynamic>.from(e)))
          .toList()
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'conditionID': _conditionID, 'start_time': _start_time?.format(), 'duration': _duration, 'Detections': _Detections?.map((Detection? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'conditionID': _conditionID,
    'start_time': _start_time,
    'duration': _duration,
    'Detections': _Detections,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<TrialModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<TrialModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final CONDITIONID = amplify_core.QueryField(fieldName: "conditionID");
  static final START_TIME = amplify_core.QueryField(fieldName: "start_time");
  static final DURATION = amplify_core.QueryField(fieldName: "duration");
  static final DETECTIONS = amplify_core.QueryField(fieldName: "Detections");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Trial";
    modelSchemaDefinition.pluralName = "Trials";
    
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
      amplify_core.ModelIndex(fields: const ["conditionID"], name: "byCondition")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Trial.CONDITIONID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Trial.START_TIME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Trial.DURATION,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.embedded(
      fieldName: 'Detections',
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.embeddedCollection, ofCustomTypeName: 'Detection')
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