// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      userId: json['userId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
      dateOfBirth: json['dateOfBirth'] as String,
      gender: const GenderConverter().fromJson(json['gender'] as String),
      subject: json['subject'] as String,
      avatar: json['avatar'] as String?,
      school: json['school'],
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'displayName': instance.displayName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'dateOfBirth': instance.dateOfBirth,
      'gender': const GenderConverter().toJson(instance.gender),
      'subject': instance.subject,
      'avatar': instance.avatar,
      'school': instance.school,
    };
