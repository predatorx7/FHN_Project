// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMFARequirementRequest _$UserMFARequirementRequestFromJson(
        Map<String, dynamic> json) =>
    UserMFARequirementRequest(
      json['username'] as String?,
    );

Map<String, dynamic> _$UserMFARequirementRequestToJson(
        UserMFARequirementRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
    };

UserMFARequirementResponse _$UserMFARequirementResponseFromJson(
        Map<String, dynamic> json) =>
    UserMFARequirementResponse(
      json['message'] as String?,
      json['status'] as bool?,
      json['isEnabled'] as bool?,
    );

Map<String, dynamic> _$UserMFARequirementResponseToJson(
        UserMFARequirementResponse instance) =>
    <String, dynamic>{
      'isEnabled': instance.isEnabled,
      'message': instance.message,
      'status': instance.status,
    };

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      json['accessToken'] as String?,
      json['refreshToken'] as String?,
      (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'errors': instance.errors,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };

Jwt _$JwtFromJson(Map<String, dynamic> json) => Jwt(
      userId: json['userId'] as int?,
      username: json['username'] as String?,
      provider: json['provider'] as String?,
      roleType: json['roleType'] as String?,
      roleLevel: json['roleLevel'] as int?,
      refreshKey: json['refreshKey'],
    );

Map<String, dynamic> _$JwtToJson(Jwt instance) => <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'provider': instance.provider,
      'roleType': instance.roleType,
      'roleLevel': instance.roleLevel,
      'refreshKey': instance.refreshKey,
    };
