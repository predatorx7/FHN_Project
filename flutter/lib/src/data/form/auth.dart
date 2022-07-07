import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth.freezed.dart';

@freezed
class LoginForm with _$LoginForm {
  const factory LoginForm({
    @Default('') String username,
    @Default('') String password,
  }) = _LoginForm;
}

@freezed
class SignupForm with _$SignupForm {
  const factory SignupForm({
    @Default('') String username,
    @Default('') String password,
    @Default('') String fullName,
    @Default('') String dialingCode,
    @Default('') String mobileNumberLocal,
    @Default('') String referralCode,
  }) = _SignupForm;
}
