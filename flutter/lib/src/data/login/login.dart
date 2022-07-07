import 'package:json_annotation/json_annotation.dart';
import 'package:magnific_core/strings/jwt.dart';

import '../data.dart';

part 'login.g.dart';

@JsonSerializable()
class UserMFARequirementRequest {
  @JsonKey(name: 'username')
  final String? username;

  const UserMFARequirementRequest(this.username);

  factory UserMFARequirementRequest.fromJson(dynamic json) =>
      _$UserMFARequirementRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserMFARequirementRequestToJson(this);
}

@JsonSerializable()
class UserMFARequirementResponse extends MessageWithStatus {
  @JsonKey(name: 'isEnabled')
  final bool? isEnabled;

  @override
  @JsonKey(name: 'message')
  final String? message;

  @override
  @JsonKey(name: 'status')
  final bool? status;

  const UserMFARequirementResponse(this.message, this.status, this.isEnabled);

  factory UserMFARequirementResponse.fromJson(dynamic json) =>
      _$UserMFARequirementResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserMFARequirementResponseToJson(this);
}

@JsonSerializable()
class LoginResponse extends BasicResponse {
  @JsonKey(name: 'accessToken')
  final String? accessToken;

  @JsonKey(name: 'refreshToken')
  final String? refreshToken;

  @JsonKey(ignore: true)
  final Jwt jwt;

  LoginResponse(
    this.accessToken,
    this.refreshToken,
    List<String>? errors,
  )   : jwt = Jwt.fromJson(
          accessToken == null ? null : JwtDecoder.tryDecode(accessToken),
        ),
        super(errors);

  factory LoginResponse.fromJson(dynamic json) => _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class Jwt {
  final int? userId;
  final String? username;
  final String? provider;
  final String? roleType;
  final int? roleLevel;
  final dynamic refreshKey;

  const Jwt({
    this.userId,
    this.username,
    this.provider,
    this.roleType,
    this.roleLevel,
    this.refreshKey,
  });

  factory Jwt.fromJson(dynamic json) {
    if (json == null) return const Jwt();
    print('JWT: ${json['refreshKey'].runtimeType}');
    return _$JwtFromJson(json);
  }

  Map<String, dynamic> toJson() => _$JwtToJson(this);
}
