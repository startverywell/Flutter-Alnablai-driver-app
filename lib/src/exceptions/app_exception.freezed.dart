// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'app_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AppException {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() wrongPassword,
    required TResult Function() userNotFound,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? wrongPassword,
    TResult? Function()? userNotFound,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? wrongPassword,
    TResult Function()? userNotFound,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WrongPassword value) wrongPassword,
    required TResult Function(UserNotFound value) userNotFound,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WrongPassword value)? wrongPassword,
    TResult? Function(UserNotFound value)? userNotFound,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WrongPassword value)? wrongPassword,
    TResult Function(UserNotFound value)? userNotFound,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppExceptionCopyWith<$Res> {
  factory $AppExceptionCopyWith(
          AppException value, $Res Function(AppException) then) =
      _$AppExceptionCopyWithImpl<$Res, AppException>;
}

/// @nodoc
class _$AppExceptionCopyWithImpl<$Res, $Val extends AppException>
    implements $AppExceptionCopyWith<$Res> {
  _$AppExceptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$WrongPasswordCopyWith<$Res> {
  factory _$$WrongPasswordCopyWith(
          _$WrongPassword value, $Res Function(_$WrongPassword) then) =
      __$$WrongPasswordCopyWithImpl<$Res>;
}

/// @nodoc
class __$$WrongPasswordCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$WrongPassword>
    implements _$$WrongPasswordCopyWith<$Res> {
  __$$WrongPasswordCopyWithImpl(
      _$WrongPassword _value, $Res Function(_$WrongPassword) _then)
      : super(_value, _then);
}

/// @nodoc

class _$WrongPassword implements WrongPassword {
  const _$WrongPassword();

  @override
  String toString() {
    return 'AppException.wrongPassword()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$WrongPassword);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() wrongPassword,
    required TResult Function() userNotFound,
  }) {
    return wrongPassword();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? wrongPassword,
    TResult? Function()? userNotFound,
  }) {
    return wrongPassword?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? wrongPassword,
    TResult Function()? userNotFound,
    required TResult orElse(),
  }) {
    if (wrongPassword != null) {
      return wrongPassword();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WrongPassword value) wrongPassword,
    required TResult Function(UserNotFound value) userNotFound,
  }) {
    return wrongPassword(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WrongPassword value)? wrongPassword,
    TResult? Function(UserNotFound value)? userNotFound,
  }) {
    return wrongPassword?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WrongPassword value)? wrongPassword,
    TResult Function(UserNotFound value)? userNotFound,
    required TResult orElse(),
  }) {
    if (wrongPassword != null) {
      return wrongPassword(this);
    }
    return orElse();
  }
}

abstract class WrongPassword implements AppException {
  const factory WrongPassword() = _$WrongPassword;
}

/// @nodoc
abstract class _$$UserNotFoundCopyWith<$Res> {
  factory _$$UserNotFoundCopyWith(
          _$UserNotFound value, $Res Function(_$UserNotFound) then) =
      __$$UserNotFoundCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UserNotFoundCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$UserNotFound>
    implements _$$UserNotFoundCopyWith<$Res> {
  __$$UserNotFoundCopyWithImpl(
      _$UserNotFound _value, $Res Function(_$UserNotFound) _then)
      : super(_value, _then);
}

/// @nodoc

class _$UserNotFound implements UserNotFound {
  const _$UserNotFound();

  @override
  String toString() {
    return 'AppException.userNotFound()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UserNotFound);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() wrongPassword,
    required TResult Function() userNotFound,
  }) {
    return userNotFound();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? wrongPassword,
    TResult? Function()? userNotFound,
  }) {
    return userNotFound?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? wrongPassword,
    TResult Function()? userNotFound,
    required TResult orElse(),
  }) {
    if (userNotFound != null) {
      return userNotFound();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WrongPassword value) wrongPassword,
    required TResult Function(UserNotFound value) userNotFound,
  }) {
    return userNotFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WrongPassword value)? wrongPassword,
    TResult? Function(UserNotFound value)? userNotFound,
  }) {
    return userNotFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WrongPassword value)? wrongPassword,
    TResult Function(UserNotFound value)? userNotFound,
    required TResult orElse(),
  }) {
    if (userNotFound != null) {
      return userNotFound(this);
    }
    return orElse();
  }
}

abstract class UserNotFound implements AppException {
  const factory UserNotFound() = _$UserNotFound;
}
