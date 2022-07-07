import 'package:freezed_annotation/freezed_annotation.dart';

class DynamicData {
  const DynamicData(this.data);

  final Map<String, dynamic> data;

  Map<String, dynamic> toJson() => data;

  factory DynamicData.fromJson(dynamic json) =>
      DynamicData(json ?? <String, dynamic>{});
}

class BaseResponse extends MessageWithStatus {
  @override
  @JsonKey(name: 'message')
  final String? message;

  @override
  @JsonKey(name: 'status')
  final bool? status;

  const BaseResponse(this.message, this.status);
}

class BasicResponse {
  @JsonKey(name: 'errors')
  final List<String>? errors;

  const BasicResponse(this.errors);
}

abstract class MessageWithStatus {
  const MessageWithStatus();

  @Deprecated('Use responseMessage instead')
  String? get message;

  @Deprecated('Use isSuccess instead')
  bool? get status;

  String get responseMessage {
    if (!isSuccess) {
      // ignore: deprecated_member_use_from_same_package
      return message ?? 'Something went wrong';
    }
    // ignore: deprecated_member_use_from_same_package
    return message ?? 'Success';
  }

  // ignore: deprecated_member_use_from_same_package
  bool get isSuccess => status == true;
}

class DynamicResponse extends DynamicData implements MessageWithStatus {
  const DynamicResponse(Map<String, dynamic> data) : super(data);

  factory DynamicResponse.fromJson(dynamic json) =>
      DynamicResponse(json ?? <String, dynamic>{});

  @override
  String? get message {
    final message = data['message'];
    if (!status) {
      return message ?? 'Something went wrong';
    }
    return message;
  }

  @override
  bool get status => data['status'];

  @override
  String get responseMessage {
    if (!isSuccess) {
      return message ?? 'Something went wrong';
    }
    return message ?? 'Success';
  }

  @override
  bool get isSuccess => status == true;
}
