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
  final int? _sequenceNumber;
  final AgeRange? _age_range;
  final Gender? _gender;
  final double? _score_sum;
  final int? _trial_sum;
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
  
  AgeRange get age_range {
    try {
      return _age_range!;
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
  
  double get score_sum {
    try {
      return _score_sum!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get trial_sum {
    try {
      return _trial_sum!;
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
  
  const Norm._internal({required this.id, required type, required sequenceNumber, required age_range, required gender, required score_sum, required trial_sum, createdAt, updatedAt}): _type = type, _sequenceNumber = sequenceNumber, _age_range = age_range, _gender = gender, _score_sum = score_sum, _trial_sum = trial_sum, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Norm({String? id, required AssessmentType type, required int sequenceNumber, required AgeRange age_range, required Gender gender, required double score_sum, required int trial_sum}) {
    return Norm._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      type: type,
      sequenceNumber: sequenceNumber,
      age_range: age_range,
      gender: gender,
      score_sum: score_sum,
      trial_sum: trial_sum);
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
      _sequenceNumber == other._sequenceNumber &&
      _age_range == other._age_range &&
      _gender == other._gender &&
      _score_sum == other._score_sum &&
      _trial_sum == other._trial_sum;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Norm {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("type=" + (_type != null ? amplify_core.enumToString(_type)! : "null") + ", ");
    buffer.write("sequenceNumber=" + (_sequenceNumber != null ? _sequenceNumber!.toString() : "null") + ", ");
    buffer.write("age_range=" + (_age_range != null ? amplify_core.enumToString(_age_range)! : "null") + ", ");
    buffer.write("gender=" + (_gender != null ? amplify_core.enumToString(_gender)! : "null") + ", ");
    buffer.write("score_sum=" + (_score_sum != null ? _score_sum!.toString() : "null") + ", ");
    buffer.write("trial_sum=" + (_trial_sum != null ? _trial_sum!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Norm copyWith({AssessmentType? type, int? sequenceNumber, AgeRange? age_range, Gender? gender, double? score_sum, int? trial_sum}) {
    return Norm._internal(
      id: id,
      type: type ?? this.type,
      sequenceNumber: sequenceNumber ?? this.sequenceNumber,
      age_range: age_range ?? this.age_range,
      gender: gender ?? this.gender,
      score_sum: score_sum ?? this.score_sum,
      trial_sum: trial_sum ?? this.trial_sum);
  }
  
  Norm copyWithModelFieldValues({
    ModelFieldValue<AssessmentType>? type,
    ModelFieldValue<int>? sequenceNumber,
    ModelFieldValue<AgeRange>? age_range,
    ModelFieldValue<Gender>? gender,
    ModelFieldValue<double>? score_sum,
    ModelFieldValue<int>? trial_sum
  }) {
    return Norm._internal(
      id: id,
      type: type == null ? this.type : type.value,
      sequenceNumber: sequenceNumber == null ? this.sequenceNumber : sequenceNumber.value,
      age_range: age_range == null ? this.age_range : age_range.value,
      gender: gender == null ? this.gender : gender.value,
      score_sum: score_sum == null ? this.score_sum : score_sum.value,
      trial_sum: trial_sum == null ? this.trial_sum : trial_sum.value
    );
  }
  
  Norm.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _type = amplify_core.enumFromString<AssessmentType>(json['type'], AssessmentType.values),
      _sequenceNumber = (json['sequenceNumber'] as num?)?.toInt(),
      _age_range = amplify_core.enumFromString<AgeRange>(json['age_range'], AgeRange.values),
      _gender = amplify_core.enumFromString<Gender>(json['gender'], Gender.values),
      _score_sum = (json['score_sum'] as num?)?.toDouble(),
      _trial_sum = (json['trial_sum'] as num?)?.toInt(),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'type': amplify_core.enumToString(_type), 'sequenceNumber': _sequenceNumber, 'age_range': amplify_core.enumToString(_age_range), 'gender': amplify_core.enumToString(_gender), 'score_sum': _score_sum, 'trial_sum': _trial_sum, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'type': _type,
    'sequenceNumber': _sequenceNumber,
    'age_range': _age_range,
    'gender': _gender,
    'score_sum': _score_sum,
    'trial_sum': _trial_sum,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<NormModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<NormModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TYPE = amplify_core.QueryField(fieldName: "type");
  static final SEQUENCENUMBER = amplify_core.QueryField(fieldName: "sequenceNumber");
  static final AGE_RANGE = amplify_core.QueryField(fieldName: "age_range");
  static final GENDER = amplify_core.QueryField(fieldName: "gender");
  static final SCORE_SUM = amplify_core.QueryField(fieldName: "score_sum");
  static final TRIAL_SUM = amplify_core.QueryField(fieldName: "trial_sum");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Norm";
    modelSchemaDefinition.pluralName = "Norms";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PRIVATE,
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
      key: Norm.SEQUENCENUMBER,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Norm.AGE_RANGE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Norm.GENDER,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Norm.SCORE_SUM,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Norm.TRIAL_SUM,
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