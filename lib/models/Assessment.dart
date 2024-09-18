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


/** This is an auto generated class representing the Assessment type in your schema. */
class Assessment extends amplify_core.Model {
  static const classType = const _AssessmentModelType();
  final String id;
  final String? _subjectID;
  final AssessmentType? _type;
  final amplify_core.TemporalDateTime? _datetime;
  final double? _duration;
  final String? _pdf;
  final List<Condition>? _Conditions;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

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
  
  String get subjectID {
    try {
      return _subjectID!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  AssessmentType get type {
    try {
      return _type!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime get datetime {
    try {
      return _datetime!;
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
  
  String? get pdf {
    return _pdf;
  }
  
  List<Condition>? get Conditions {
    return _Conditions;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Assessment._internal({required this.id, required subjectID, required type, required datetime, required duration, pdf, Conditions, createdAt, updatedAt}): _subjectID = subjectID, _type = type, _datetime = datetime, _duration = duration, _pdf = pdf, _Conditions = Conditions, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Assessment({String? id, required String subjectID, required AssessmentType type, required amplify_core.TemporalDateTime datetime, required double duration, String? pdf, List<Condition>? Conditions}) {
    return Assessment._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      subjectID: subjectID,
      type: type,
      datetime: datetime,
      duration: duration,
      pdf: pdf,
      Conditions: Conditions != null ? List<Condition>.unmodifiable(Conditions) : Conditions);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Assessment &&
      id == other.id &&
      _subjectID == other._subjectID &&
      _type == other._type &&
      _datetime == other._datetime &&
      _duration == other._duration &&
      _pdf == other._pdf &&
      DeepCollectionEquality().equals(_Conditions, other._Conditions);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Assessment {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("subjectID=" + "$_subjectID" + ", ");
    buffer.write("type=" + (_type != null ? amplify_core.enumToString(_type)! : "null") + ", ");
    buffer.write("datetime=" + (_datetime != null ? _datetime!.format() : "null") + ", ");
    buffer.write("duration=" + (_duration != null ? _duration!.toString() : "null") + ", ");
    buffer.write("pdf=" + "$_pdf" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Assessment copyWith({String? subjectID, AssessmentType? type, amplify_core.TemporalDateTime? datetime, double? duration, String? pdf, List<Condition>? Conditions}) {
    return Assessment._internal(
      id: id,
      subjectID: subjectID ?? this.subjectID,
      type: type ?? this.type,
      datetime: datetime ?? this.datetime,
      duration: duration ?? this.duration,
      pdf: pdf ?? this.pdf,
      Conditions: Conditions ?? this.Conditions);
  }
  
  Assessment copyWithModelFieldValues({
    ModelFieldValue<String>? subjectID,
    ModelFieldValue<AssessmentType>? type,
    ModelFieldValue<amplify_core.TemporalDateTime>? datetime,
    ModelFieldValue<double>? duration,
    ModelFieldValue<String?>? pdf,
    ModelFieldValue<List<Condition>>? Conditions
  }) {
    return Assessment._internal(
      id: id,
      subjectID: subjectID == null ? this.subjectID : subjectID.value,
      type: type == null ? this.type : type.value,
      datetime: datetime == null ? this.datetime : datetime.value,
      duration: duration == null ? this.duration : duration.value,
      pdf: pdf == null ? this.pdf : pdf.value,
      Conditions: Conditions == null ? this.Conditions : Conditions.value
    );
  }
  
  Assessment.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _subjectID = json['subjectID'],
      _type = amplify_core.enumFromString<AssessmentType>(json['type'], AssessmentType.values),
      _datetime = json['datetime'] != null ? amplify_core.TemporalDateTime.fromString(json['datetime']) : null,
      _duration = (json['duration'] as num?)?.toDouble(),
      _pdf = json['pdf'],
      _Conditions = json['Conditions']  is Map
        ? (json['Conditions']['items'] is List
          ? (json['Conditions']['items'] as List)
              .where((e) => e != null)
              .map((e) => Condition.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['Conditions'] is List
          ? (json['Conditions'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => Condition.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'subjectID': _subjectID, 'type': amplify_core.enumToString(_type), 'datetime': _datetime?.format(), 'duration': _duration, 'pdf': _pdf, 'Conditions': _Conditions?.map((Condition? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'subjectID': _subjectID,
    'type': _type,
    'datetime': _datetime,
    'duration': _duration,
    'pdf': _pdf,
    'Conditions': _Conditions,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<AssessmentModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<AssessmentModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final SUBJECTID = amplify_core.QueryField(fieldName: "subjectID");
  static final TYPE = amplify_core.QueryField(fieldName: "type");
  static final DATETIME = amplify_core.QueryField(fieldName: "datetime");
  static final DURATION = amplify_core.QueryField(fieldName: "duration");
  static final PDF = amplify_core.QueryField(fieldName: "pdf");
  static final CONDITIONS = amplify_core.QueryField(
    fieldName: "Conditions",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Condition'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Assessment";
    modelSchemaDefinition.pluralName = "Assessments";
    
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
      amplify_core.ModelIndex(fields: const ["subjectID"], name: "bySubject")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Assessment.SUBJECTID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Assessment.TYPE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Assessment.DATETIME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Assessment.DURATION,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Assessment.PDF,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Assessment.CONDITIONS,
      isRequired: true,
      ofModelName: 'Condition',
      associatedKey: Condition.ASSESSMENTID
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

class _AssessmentModelType extends amplify_core.ModelType<Assessment> {
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
class AssessmentModelIdentifier implements amplify_core.ModelIdentifier<Assessment> {
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