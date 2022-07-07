// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'auth.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$LoginForm {
  String get username => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LoginFormCopyWith<LoginForm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginFormCopyWith<$Res> {
  factory $LoginFormCopyWith(LoginForm value, $Res Function(LoginForm) then) =
      _$LoginFormCopyWithImpl<$Res>;
  $Res call({String username, String password});
}

/// @nodoc
class _$LoginFormCopyWithImpl<$Res> implements $LoginFormCopyWith<$Res> {
  _$LoginFormCopyWithImpl(this._value, this._then);

  final LoginForm _value;
  // ignore: unused_field
  final $Res Function(LoginForm) _then;

  @override
  $Res call({
    Object? username = freezed,
    Object? password = freezed,
  }) {
    return _then(_value.copyWith(
      username: username == freezed
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_LoginFormCopyWith<$Res> implements $LoginFormCopyWith<$Res> {
  factory _$$_LoginFormCopyWith(
          _$_LoginForm value, $Res Function(_$_LoginForm) then) =
      __$$_LoginFormCopyWithImpl<$Res>;
  @override
  $Res call({String username, String password});
}

/// @nodoc
class __$$_LoginFormCopyWithImpl<$Res> extends _$LoginFormCopyWithImpl<$Res>
    implements _$$_LoginFormCopyWith<$Res> {
  __$$_LoginFormCopyWithImpl(
      _$_LoginForm _value, $Res Function(_$_LoginForm) _then)
      : super(_value, (v) => _then(v as _$_LoginForm));

  @override
  _$_LoginForm get _value => super._value as _$_LoginForm;

  @override
  $Res call({
    Object? username = freezed,
    Object? password = freezed,
  }) {
    return _then(_$_LoginForm(
      username: username == freezed
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_LoginForm implements _LoginForm {
  const _$_LoginForm({this.username = '', this.password = ''});

  @override
  @JsonKey()
  final String username;
  @override
  @JsonKey()
  final String password;

  @override
  String toString() {
    return 'LoginForm(username: $username, password: $password)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LoginForm &&
            const DeepCollectionEquality().equals(other.username, username) &&
            const DeepCollectionEquality().equals(other.password, password));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(username),
      const DeepCollectionEquality().hash(password));

  @JsonKey(ignore: true)
  @override
  _$$_LoginFormCopyWith<_$_LoginForm> get copyWith =>
      __$$_LoginFormCopyWithImpl<_$_LoginForm>(this, _$identity);
}

abstract class _LoginForm implements LoginForm {
  const factory _LoginForm({final String username, final String password}) =
      _$_LoginForm;

  @override
  String get username => throw _privateConstructorUsedError;
  @override
  String get password => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_LoginFormCopyWith<_$_LoginForm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SignupForm {
  String get username => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get dialingCode => throw _privateConstructorUsedError;
  String get mobileNumberLocal => throw _privateConstructorUsedError;
  String get referralCode => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SignupFormCopyWith<SignupForm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignupFormCopyWith<$Res> {
  factory $SignupFormCopyWith(
          SignupForm value, $Res Function(SignupForm) then) =
      _$SignupFormCopyWithImpl<$Res>;
  $Res call(
      {String username,
      String password,
      String fullName,
      String dialingCode,
      String mobileNumberLocal,
      String referralCode});
}

/// @nodoc
class _$SignupFormCopyWithImpl<$Res> implements $SignupFormCopyWith<$Res> {
  _$SignupFormCopyWithImpl(this._value, this._then);

  final SignupForm _value;
  // ignore: unused_field
  final $Res Function(SignupForm) _then;

  @override
  $Res call({
    Object? username = freezed,
    Object? password = freezed,
    Object? fullName = freezed,
    Object? dialingCode = freezed,
    Object? mobileNumberLocal = freezed,
    Object? referralCode = freezed,
  }) {
    return _then(_value.copyWith(
      username: username == freezed
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: fullName == freezed
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      dialingCode: dialingCode == freezed
          ? _value.dialingCode
          : dialingCode // ignore: cast_nullable_to_non_nullable
              as String,
      mobileNumberLocal: mobileNumberLocal == freezed
          ? _value.mobileNumberLocal
          : mobileNumberLocal // ignore: cast_nullable_to_non_nullable
              as String,
      referralCode: referralCode == freezed
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_SignupFormCopyWith<$Res>
    implements $SignupFormCopyWith<$Res> {
  factory _$$_SignupFormCopyWith(
          _$_SignupForm value, $Res Function(_$_SignupForm) then) =
      __$$_SignupFormCopyWithImpl<$Res>;
  @override
  $Res call(
      {String username,
      String password,
      String fullName,
      String dialingCode,
      String mobileNumberLocal,
      String referralCode});
}

/// @nodoc
class __$$_SignupFormCopyWithImpl<$Res> extends _$SignupFormCopyWithImpl<$Res>
    implements _$$_SignupFormCopyWith<$Res> {
  __$$_SignupFormCopyWithImpl(
      _$_SignupForm _value, $Res Function(_$_SignupForm) _then)
      : super(_value, (v) => _then(v as _$_SignupForm));

  @override
  _$_SignupForm get _value => super._value as _$_SignupForm;

  @override
  $Res call({
    Object? username = freezed,
    Object? password = freezed,
    Object? fullName = freezed,
    Object? dialingCode = freezed,
    Object? mobileNumberLocal = freezed,
    Object? referralCode = freezed,
  }) {
    return _then(_$_SignupForm(
      username: username == freezed
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: fullName == freezed
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      dialingCode: dialingCode == freezed
          ? _value.dialingCode
          : dialingCode // ignore: cast_nullable_to_non_nullable
              as String,
      mobileNumberLocal: mobileNumberLocal == freezed
          ? _value.mobileNumberLocal
          : mobileNumberLocal // ignore: cast_nullable_to_non_nullable
              as String,
      referralCode: referralCode == freezed
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_SignupForm implements _SignupForm {
  const _$_SignupForm(
      {this.username = '',
      this.password = '',
      this.fullName = '',
      this.dialingCode = '',
      this.mobileNumberLocal = '',
      this.referralCode = ''});

  @override
  @JsonKey()
  final String username;
  @override
  @JsonKey()
  final String password;
  @override
  @JsonKey()
  final String fullName;
  @override
  @JsonKey()
  final String dialingCode;
  @override
  @JsonKey()
  final String mobileNumberLocal;
  @override
  @JsonKey()
  final String referralCode;

  @override
  String toString() {
    return 'SignupForm(username: $username, password: $password, fullName: $fullName, dialingCode: $dialingCode, mobileNumberLocal: $mobileNumberLocal, referralCode: $referralCode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SignupForm &&
            const DeepCollectionEquality().equals(other.username, username) &&
            const DeepCollectionEquality().equals(other.password, password) &&
            const DeepCollectionEquality().equals(other.fullName, fullName) &&
            const DeepCollectionEquality()
                .equals(other.dialingCode, dialingCode) &&
            const DeepCollectionEquality()
                .equals(other.mobileNumberLocal, mobileNumberLocal) &&
            const DeepCollectionEquality()
                .equals(other.referralCode, referralCode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(username),
      const DeepCollectionEquality().hash(password),
      const DeepCollectionEquality().hash(fullName),
      const DeepCollectionEquality().hash(dialingCode),
      const DeepCollectionEquality().hash(mobileNumberLocal),
      const DeepCollectionEquality().hash(referralCode));

  @JsonKey(ignore: true)
  @override
  _$$_SignupFormCopyWith<_$_SignupForm> get copyWith =>
      __$$_SignupFormCopyWithImpl<_$_SignupForm>(this, _$identity);
}

abstract class _SignupForm implements SignupForm {
  const factory _SignupForm(
      {final String username,
      final String password,
      final String fullName,
      final String dialingCode,
      final String mobileNumberLocal,
      final String referralCode}) = _$_SignupForm;

  @override
  String get username => throw _privateConstructorUsedError;
  @override
  String get password => throw _privateConstructorUsedError;
  @override
  String get fullName => throw _privateConstructorUsedError;
  @override
  String get dialingCode => throw _privateConstructorUsedError;
  @override
  String get mobileNumberLocal => throw _privateConstructorUsedError;
  @override
  String get referralCode => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_SignupFormCopyWith<_$_SignupForm> get copyWith =>
      throw _privateConstructorUsedError;
}
