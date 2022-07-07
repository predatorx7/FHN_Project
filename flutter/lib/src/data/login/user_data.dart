import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserInformation {
  @JsonKey(name: 'token')
  final String? token;

  @JsonKey(name: 'user')
  final UserData? user;

  const UserInformation(this.token, this.user);

  factory UserInformation.fromJson(dynamic json) =>
      _$UserInformationFromJson(json);

  Map<String, dynamic> toJson() => _$UserInformationToJson(this);
}

@JsonSerializable()
class UserData {
  @JsonKey(name: 'username')
  final String? userName;

  @JsonKey(name: 'user_id')
  final int? userId;

  const UserData(this.userName, this.userId);

  factory UserData.fromJson(dynamic json) => _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
