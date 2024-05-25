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


/** This is an auto generated class representing the Subject type in your schema. */
class Subject extends amplify_core.Model {
  static const classType = const _SubjectModelType();
  final String id;
  final String? _userID;
  final String? _first_name;
  final String? _last_name;
  final amplify_core.TemporalDate? _dob;
  final Gender? _gender;
  final double? _height_in_inches;
  final FallHistory? _fall_history;
  final String? _provider_contact;
  final List<Assessment>? _Assessments;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  SubjectModelIdentifier get modelIdentifier {
      return SubjectModelIdentifier(
        id: id
      );
  }
  
  String get userID {
    try {
      return _userID!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get first_name {
    try {
      return _first_name!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get last_name {
    try {
      return _last_name!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDate get dob {
    try {
      return _dob!;
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
  
  double get height_in_inches {
    try {
      return _height_in_inches!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  FallHistory get fall_history {
    try {
      return _fall_history!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get provider_contact {
    try {
      return _provider_contact!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<Assessment>? get Assessments {
    return _Assessments;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Subject._internal({required this.id, required userID, required first_name, required last_name, required dob, required gender, required height_in_inches, required fall_history, required provider_contact, Assessments, createdAt, updatedAt}): _userID = userID, _first_name = first_name, _last_name = last_name, _dob = dob, _gender = gender, _height_in_inches = height_in_inches, _fall_history = fall_history, _provider_contact = provider_contact, _Assessments = Assessments, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Subject({String? id, required String userID, required String first_name, required String last_name, required amplify_core.TemporalDate dob, required Gender gender, required double height_in_inches, required FallHistory fall_history, required String provider_contact, List<Assessment>? Assessments}) {
    return Subject._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      userID: userID,
      first_name: first_name,
      last_name: last_name,
      dob: dob,
      gender: gender,
      height_in_inches: height_in_inches,
      fall_history: fall_history,
      provider_contact: provider_contact,
      Assessments: Assessments != null ? List<Assessment>.unmodifiable(Assessments) : Assessments);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Subject &&
      id == other.id &&
      _userID == other._userID &&
      _first_name == other._first_name &&
      _last_name == other._last_name &&
      _dob == other._dob &&
      _gender == other._gender &&
      _height_in_inches == other._height_in_inches &&
      _fall_history == other._fall_history &&
      _provider_contact == other._provider_contact &&
      DeepCollectionEquality().equals(_Assessments, other._Assessments);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Subject {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("userID=" + "$_userID" + ", ");
    buffer.write("first_name=" + "$_first_name" + ", ");
    buffer.write("last_name=" + "$_last_name" + ", ");
    buffer.write("dob=" + (_dob != null ? _dob!.format() : "null") + ", ");
    buffer.write("gender=" + (_gender != null ? amplify_core.enumToString(_gender)! : "null") + ", ");
    buffer.write("height_in_inches=" + (_height_in_inches != null ? _height_in_inches!.toString() : "null") + ", ");
    buffer.write("fall_history=" + (_fall_history != null ? amplify_core.enumToString(_fall_history)! : "null") + ", ");
    buffer.write("provider_contact=" + "$_provider_contact" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Subject copyWith({String? userID, String? first_name, String? last_name, amplify_core.TemporalDate? dob, Gender? gender, double? height_in_inches, FallHistory? fall_history, String? provider_contact, List<Assessment>? Assessments}) {
    return Subject._internal(
      id: id,
      userID: userID ?? this.userID,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      height_in_inches: height_in_inches ?? this.height_in_inches,
      fall_history: fall_history ?? this.fall_history,
      provider_contact: provider_contact ?? this.provider_contact,
      Assessments: Assessments ?? this.Assessments);
  }
  
  Subject copyWithModelFieldValues({
    ModelFieldValue<String>? userID,
    ModelFieldValue<String>? first_name,
    ModelFieldValue<String>? last_name,
    ModelFieldValue<amplify_core.TemporalDate>? dob,
    ModelFieldValue<Gender>? gender,
    ModelFieldValue<double>? height_in_inches,
    ModelFieldValue<FallHistory>? fall_history,
    ModelFieldValue<String>? provider_contact,
    ModelFieldValue<List<Assessment>>? Assessments
  }) {
    return Subject._internal(
      id: id,
      userID: userID == null ? this.userID : userID.value,
      first_name: first_name == null ? this.first_name : first_name.value,
      last_name: last_name == null ? this.last_name : last_name.value,
      dob: dob == null ? this.dob : dob.value,
      gender: gender == null ? this.gender : gender.value,
      height_in_inches: height_in_inches == null ? this.height_in_inches : height_in_inches.value,
      fall_history: fall_history == null ? this.fall_history : fall_history.value,
      provider_contact: provider_contact == null ? this.provider_contact : provider_contact.value,
      Assessments: Assessments == null ? this.Assessments : Assessments.value
    );
  }
  
  Subject.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _userID = json['userID'],
      _first_name = json['first_name'],
      _last_name = json['last_name'],
      _dob = json['dob'] != null ? amplify_core.TemporalDate.fromString(json['dob']) : null,
      _gender = amplify_core.enumFromString<Gender>(json['gender'], Gender.values),
      _height_in_inches = (json['height_in_inches'] as num?)?.toDouble(),
      _fall_history = amplify_core.enumFromString<FallHistory>(json['fall_history'], FallHistory.values),
      _provider_contact = json['provider_contact'],
      _Assessments = json['Assessments']  is Map
        ? (json['Assessments']['items'] is List
          ? (json['Assessments']['items'] as List)
              .where((e) => e != null)
              .map((e) => Assessment.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['Assessments'] is List
          ? (json['Assessments'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => Assessment.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'userID': _userID, 'first_name': _first_name, 'last_name': _last_name, 'dob': _dob?.format(), 'gender': amplify_core.enumToString(_gender), 'height_in_inches': _height_in_inches, 'fall_history': amplify_core.enumToString(_fall_history), 'provider_contact': _provider_contact, 'Assessments': _Assessments?.map((Assessment? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'userID': _userID,
    'first_name': _first_name,
    'last_name': _last_name,
    'dob': _dob,
    'gender': _gender,
    'height_in_inches': _height_in_inches,
    'fall_history': _fall_history,
    'provider_contact': _provider_contact,
    'Assessments': _Assessments,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<SubjectModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<SubjectModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USERID = amplify_core.QueryField(fieldName: "userID");
  static final FIRST_NAME = amplify_core.QueryField(fieldName: "first_name");
  static final LAST_NAME = amplify_core.QueryField(fieldName: "last_name");
  static final DOB = amplify_core.QueryField(fieldName: "dob");
  static final GENDER = amplify_core.QueryField(fieldName: "gender");
  static final HEIGHT_IN_INCHES = amplify_core.QueryField(fieldName: "height_in_inches");
  static final FALL_HISTORY = amplify_core.QueryField(fieldName: "fall_history");
  static final PROVIDER_CONTACT = amplify_core.QueryField(fieldName: "provider_contact");
  static final ASSESSMENTS = amplify_core.QueryField(
    fieldName: "Assessments",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Assessment'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Subject";
    modelSchemaDefinition.pluralName = "Subjects";
    
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
        ])
    ];
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["userID"], name: "byUser")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Subject.USERID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Subject.FIRST_NAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Subject.LAST_NAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Subject.DOB,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Subject.GENDER,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Subject.HEIGHT_IN_INCHES,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Subject.FALL_HISTORY,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Subject.PROVIDER_CONTACT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Subject.ASSESSMENTS,
      isRequired: true,
      ofModelName: 'Assessment',
      associatedKey: Assessment.SUBJECTID
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

class _SubjectModelType extends amplify_core.ModelType<Subject> {
  const _SubjectModelType();
  
  @override
  Subject fromJson(Map<String, dynamic> jsonData) {
    return Subject.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Subject';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Subject] in your schema.
 */
class SubjectModelIdentifier implements amplify_core.ModelIdentifier<Subject> {
  final String id;

  /** Create an instance of SubjectModelIdentifier using [id] the primary key. */
  const SubjectModelIdentifier({
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
  String toString() => 'SubjectModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is SubjectModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}