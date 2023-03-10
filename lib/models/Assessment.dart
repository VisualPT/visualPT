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

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Assessment type in your schema. */
@immutable
class Assessment extends Model {
  static const classType = const _AssessmentModelType();
  final String id;
  final String? _patientID;
  final AssessmentType? _type;
  final TemporalTimestamp? _timestamp;
  final List<SkeletalSequence>? _skeletalSequences;
  final int? _duration;
  final String? _pdf;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  AssessmentModelIdentifier get modelIdentifier {
      return AssessmentModelIdentifier(
        id: id
      );
  }
  
  String get patientID {
    try {
      return _patientID!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  AssessmentType get type {
    try {
      return _type!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalTimestamp get timestamp {
    try {
      return _timestamp!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<SkeletalSequence>? get skeletalSequences {
    return _skeletalSequences;
  }
  
  int? get duration {
    return _duration;
  }
  
  String? get pdf {
    return _pdf;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Assessment._internal({required this.id, required patientID, required type, required timestamp, skeletalSequences, duration, pdf, createdAt, updatedAt}): _patientID = patientID, _type = type, _timestamp = timestamp, _skeletalSequences = skeletalSequences, _duration = duration, _pdf = pdf, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Assessment({String? id, required String patientID, required AssessmentType type, required TemporalTimestamp timestamp, List<SkeletalSequence>? skeletalSequences, int? duration, String? pdf}) {
    return Assessment._internal(
      id: id == null ? UUID.getUUID() : id,
      patientID: patientID,
      type: type,
      timestamp: timestamp,
      skeletalSequences: skeletalSequences != null ? List<SkeletalSequence>.unmodifiable(skeletalSequences) : skeletalSequences,
      duration: duration,
      pdf: pdf);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Assessment &&
      id == other.id &&
      _patientID == other._patientID &&
      _type == other._type &&
      _timestamp == other._timestamp &&
      DeepCollectionEquality().equals(_skeletalSequences, other._skeletalSequences) &&
      _duration == other._duration &&
      _pdf == other._pdf;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Assessment {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("patientID=" + "$_patientID" + ", ");
    buffer.write("type=" + (_type != null ? enumToString(_type)! : "null") + ", ");
    buffer.write("timestamp=" + (_timestamp != null ? _timestamp!.toString() : "null") + ", ");
    buffer.write("duration=" + (_duration != null ? _duration!.toString() : "null") + ", ");
    buffer.write("pdf=" + "$_pdf" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Assessment copyWith({String? patientID, AssessmentType? type, TemporalTimestamp? timestamp, List<SkeletalSequence>? skeletalSequences, int? duration, String? pdf}) {
    return Assessment._internal(
      id: id,
      patientID: patientID ?? this.patientID,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      skeletalSequences: skeletalSequences ?? this.skeletalSequences,
      duration: duration ?? this.duration,
      pdf: pdf ?? this.pdf);
  }
  
  Assessment.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _patientID = json['patientID'],
      _type = enumFromString<AssessmentType>(json['type'], AssessmentType.values),
      _timestamp = json['timestamp'] != null ? TemporalTimestamp.fromSeconds(json['timestamp']) : null,
      _skeletalSequences = json['skeletalSequences'] is List
        ? (json['skeletalSequences'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => SkeletalSequence.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _duration = (json['duration'] as num?)?.toInt(),
      _pdf = json['pdf'],
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'patientID': _patientID, 'type': enumToString(_type), 'timestamp': _timestamp?.toSeconds(), 'skeletalSequences': _skeletalSequences?.map((SkeletalSequence? e) => e?.toJson()).toList(), 'duration': _duration, 'pdf': _pdf, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id, 'patientID': _patientID, 'type': _type, 'timestamp': _timestamp, 'skeletalSequences': _skeletalSequences, 'duration': _duration, 'pdf': _pdf, 'createdAt': _createdAt, 'updatedAt': _updatedAt
  };

  static final QueryModelIdentifier<AssessmentModelIdentifier> MODEL_IDENTIFIER = QueryModelIdentifier<AssessmentModelIdentifier>();
  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField PATIENTID = QueryField(fieldName: "patientID");
  static final QueryField TYPE = QueryField(fieldName: "type");
  static final QueryField TIMESTAMP = QueryField(fieldName: "timestamp");
  static final QueryField SKELETALSEQUENCES = QueryField(
    fieldName: "skeletalSequences",
    fieldType: ModelFieldType(ModelFieldTypeEnum.model, ofModelName: 'SkeletalSequence'));
  static final QueryField DURATION = QueryField(fieldName: "duration");
  static final QueryField PDF = QueryField(fieldName: "pdf");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Assessment";
    modelSchemaDefinition.pluralName = "Assessments";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.OWNER,
        ownerField: "owner",
        identityClaim: "cognito:username",
        provider: AuthRuleProvider.USERPOOLS,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.indexes = [
      ModelIndex(fields: const ["patientID"], name: "byPatient")
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Assessment.PATIENTID,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Assessment.TYPE,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Assessment.TIMESTAMP,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.timestamp)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
      key: Assessment.SKELETALSEQUENCES,
      isRequired: false,
      ofModelName: 'SkeletalSequence',
      associatedKey: SkeletalSequence.ASSESSMENTID
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Assessment.DURATION,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Assessment.PDF,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _AssessmentModelType extends ModelType<Assessment> {
  const _AssessmentModelType();
  
  @override
  Assessment fromJson(Map<String, dynamic> jsonData) {
    return Assessment.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Assessment';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Assessment] in your schema.
 */
@immutable
class AssessmentModelIdentifier implements ModelIdentifier<Assessment> {
  final String id;

  /** Create an instance of AssessmentModelIdentifier using [id] the primary key. */
  const AssessmentModelIdentifier({
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
  String toString() => 'AssessmentModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is AssessmentModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}