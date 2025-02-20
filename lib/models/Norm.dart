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


/** This is an auto generated class representing the Norm type in your schema. */
class Norm extends amplify_core.Model {
  static const classType = const _NormModelType();
  final String id;
  final AssessmentType? _type;
  final int? _stageNumber;
  final AgeRange? _ageRange;
  final Gender? _gender;
  final double? _scoreSum;
  final int? _trialSum;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  NormModelIdentifier get modelIdentifier {
      return NormModelIdentifier(
        id: id
      );
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
  
  AgeRange get ageRange {
    try {
      return _ageRange!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  Gender get gender {
    try {
      return _gender!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double get scoreSum {
    try {
      return _scoreSum!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get trialSum {
    try {
      return _trialSum!;
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
  
  const Norm._internal({required this.id, required type, required stageNumber, required ageRange, required gender, required scoreSum, required trialSum, createdAt, updatedAt}): _type = type, _stageNumber = stageNumber, _ageRange = ageRange, _gender = gender, _scoreSum = scoreSum, _trialSum = trialSum, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Norm({String? id, required AssessmentType type, required int stageNumber, required AgeRange ageRange, required Gender gender, required double scoreSum, required int trialSum}) {
    return Norm._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      type: type,
      stageNumber: stageNumber,
      ageRange: ageRange,
      gender: gender,
      scoreSum: scoreSum,
      trialSum: trialSum);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Norm &&
      id == other.id &&
      _type == other._type &&
      _stageNumber == other._stageNumber &&
      _ageRange == other._ageRange &&
      _gender == other._gender &&
      _scoreSum == other._scoreSum &&
      _trialSum == other._trialSum;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Norm {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("type=" + (_type != null ? amplify_core.enumToString(_type)! : "null") + ", ");
    buffer.write("stageNumber=" + (_stageNumber != null ? _stageNumber!.toString() : "null") + ", ");
    buffer.write("ageRange=" + (_ageRange != null ? amplify_core.enumToString(_ageRange)! : "null") + ", ");
    buffer.write("gender=" + (_gender != null ? amplify_core.enumToString(_gender)! : "null") + ", ");
    buffer.write("scoreSum=" + (_scoreSum != null ? _scoreSum!.toString() : "null") + ", ");
    buffer.write("trialSum=" + (_trialSum != null ? _trialSum!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Norm copyWith({AssessmentType? type, int? stageNumber, AgeRange? ageRange, Gender? gender, double? scoreSum, int? trialSum}) {
    return Norm._internal(
      id: id,
      type: type ?? this.type,
      stageNumber: stageNumber ?? this.stageNumber,
      ageRange: ageRange ?? this.ageRange,
      gender: gender ?? this.gender,
      scoreSum: scoreSum ?? this.scoreSum,
      trialSum: trialSum ?? this.trialSum);
  }
  
  Norm copyWithModelFieldValues({
    ModelFieldValue<AssessmentType>? type,
    ModelFieldValue<int>? stageNumber,
    ModelFieldValue<AgeRange>? ageRange,
    ModelFieldValue<Gender>? gender,
    ModelFieldValue<double>? scoreSum,
    ModelFieldValue<int>? trialSum
  }) {
    return Norm._internal(
      id: id,
      type: type == null ? this.type : type.value,
      stageNumber: stageNumber == null ? this.stageNumber : stageNumber.value,
      ageRange: ageRange == null ? this.ageRange : ageRange.value,
      gender: gender == null ? this.gender : gender.value,
      scoreSum: scoreSum == null ? this.scoreSum : scoreSum.value,
      trialSum: trialSum == null ? this.trialSum : trialSum.value
    );
  }
  
  Norm.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _type = amplify_core.enumFromString<AssessmentType>(json['type'], AssessmentType.values),
      _stageNumber = (json['stageNumber'] as num?)?.toInt(),
      _ageRange = amplify_core.enumFromString<AgeRange>(json['ageRange'], AgeRange.values),
      _gender = amplify_core.enumFromString<Gender>(json['gender'], Gender.values),
      _scoreSum = (json['scoreSum'] as num?)?.toDouble(),
      _trialSum = (json['trialSum'] as num?)?.toInt(),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'type': amplify_core.enumToString(_type), 'stageNumber': _stageNumber, 'ageRange': amplify_core.enumToString(_ageRange), 'gender': amplify_core.enumToString(_gender), 'scoreSum': _scoreSum, 'trialSum': _trialSum, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'type': _type,
    'stageNumber': _stageNumber,
    'ageRange': _ageRange,
    'gender': _gender,
    'scoreSum': _scoreSum,
    'trialSum': _trialSum,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<NormModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<NormModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TYPE = amplify_core.QueryField(fieldName: "type");
  static final STAGENUMBER = amplify_core.QueryField(fieldName: "stageNumber");
  static final AGERANGE = amplify_core.QueryField(fieldName: "ageRange");
  static final GENDER = amplify_core.QueryField(fieldName: "gender");
  static final SCORESUM = amplify_core.QueryField(fieldName: "scoreSum");
  static final TRIALSUM = amplify_core.QueryField(fieldName: "trialSum");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Norm";
    modelSchemaDefinition.pluralName = "Norms";
    
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
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Norm.TYPE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Norm.STAGENUMBER,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Norm.AGERANGE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Norm.GENDER,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Norm.SCORESUM,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Norm.TRIALSUM,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
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

class _NormModelType extends amplify_core.ModelType<Norm> {
  const _NormModelType();
  
  @override
  Norm fromJson(Map<String, dynamic> jsonData) {
    return Norm.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Norm';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Norm] in your schema.
 */
class NormModelIdentifier implements amplify_core.ModelIdentifier<Norm> {
  final String id;

  /** Create an instance of NormModelIdentifier using [id] the primary key. */
  const NormModelIdentifier({
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
  String toString() => 'NormModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is NormModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}