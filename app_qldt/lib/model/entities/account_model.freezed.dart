// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-model');

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) {
  return _AccountModel.fromJson(json);
}

/// @nodoc
mixin _$AccountModel {
  String get username => throw _privateConstructorUsedError;
  String get accessToken => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;
  @_AccountStatusConverter()
  AccountStatus get statusAccount => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  bool get saved => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AccountModelCopyWith<AccountModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountModelCopyWith<$Res> {
  factory $AccountModelCopyWith(
          AccountModel value, $Res Function(AccountModel) then) =
      _$AccountModelCopyWithImpl<$Res, AccountModel>;
  @useResult
  $Res call(
      {String username,
      String accessToken,
      String refreshToken,
      @_AccountStatusConverter() AccountStatus statusAccount,
      String? avatar,
      bool saved});
}

/// @nodoc
class _$AccountModelCopyWithImpl<$Res, $Val extends AccountModel>
    implements $AccountModelCopyWith<$Res> {
  _$AccountModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? statusAccount = null,
    Object? avatar = freezed,
    Object? saved = null,
  }) {
    return _then(_value.copyWith(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      statusAccount: null == statusAccount
          ? _value.statusAccount
          : statusAccount // ignore: cast_nullable_to_non_nullable
              as AccountStatus,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      saved: null == saved
          ? _value.saved
          : saved // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountModelImplCopyWith<$Res>
    implements $AccountModelCopyWith<$Res> {
  factory _$$AccountModelImplCopyWith(
          _$AccountModelImpl value, $Res Function(_$AccountModelImpl) then) =
      __$$AccountModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String username,
      String accessToken,
      String refreshToken,
      @_AccountStatusConverter() AccountStatus statusAccount,
      String? avatar,
      bool saved});
}

/// @nodoc
class __$$AccountModelImplCopyWithImpl<$Res>
    extends _$AccountModelCopyWithImpl<$Res, _$AccountModelImpl>
    implements _$$AccountModelImplCopyWith<$Res> {
  __$$AccountModelImplCopyWithImpl(
      _$AccountModelImpl _value, $Res Function(_$AccountModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? statusAccount = null,
    Object? avatar = freezed,
    Object? saved = null,
  }) {
    return _then(_$AccountModelImpl(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      statusAccount: null == statusAccount
          ? _value.statusAccount
          : statusAccount // ignore: cast_nullable_to_non_nullable
              as AccountStatus,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      saved: null == saved
          ? _value.saved
          : saved // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$AccountModelImpl implements _AccountModel {
  const _$AccountModelImpl(
      {required this.username,
      required this.accessToken,
      required this.refreshToken,
      @_AccountStatusConverter() this.statusAccount = AccountStatus.NO,
      this.avatar,
      this.saved = false});

  factory _$AccountModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountModelImplFromJson(json);

  @override
  final String username;
  @override
  final String accessToken;
  @override
  final String refreshToken;
  @override
  @JsonKey()
  @_AccountStatusConverter()
  final AccountStatus statusAccount;
  @override
  final String? avatar;
  @override
  @JsonKey()
  final bool saved;

  @override
  String toString() {
    return 'AccountModel(username: $username, accessToken: $accessToken, refreshToken: $refreshToken, statusAccount: $statusAccount, avatar: $avatar, saved: $saved)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountModelImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.statusAccount, statusAccount) ||
                other.statusAccount == statusAccount) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.saved, saved) || other.saved == saved));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, username, accessToken,
      refreshToken, statusAccount, avatar, saved);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountModelImplCopyWith<_$AccountModelImpl> get copyWith =>
      __$$AccountModelImplCopyWithImpl<_$AccountModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountModelImplToJson(
      this,
    );
  }
}

abstract class _AccountModel implements AccountModel {
  const factory _AccountModel(
      {required final String username,
      required final String accessToken,
      required final String refreshToken,
      @_AccountStatusConverter() final AccountStatus statusAccount,
      final String? avatar,
      final bool saved}) = _$AccountModelImpl;

  factory _AccountModel.fromJson(Map<String, dynamic> json) =
      _$AccountModelImpl.fromJson;

  @override
  String get username;
  @override
  String get accessToken;
  @override
  String get refreshToken;
  @override
  @_AccountStatusConverter()
  AccountStatus get statusAccount;
  @override
  String? get avatar;
  @override
  bool get saved;
  @override
  @JsonKey(ignore: true)
  _$$AccountModelImplCopyWith<_$AccountModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
