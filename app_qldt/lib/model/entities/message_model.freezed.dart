// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MessageModel {
  String get id => throw _privateConstructorUsedError;
  MessageUserModel get user => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  String? get media => throw _privateConstructorUsedError;
  List<dynamic>? get isRead => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageModelCopyWith<MessageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageModelCopyWith<$Res> {
  factory $MessageModelCopyWith(
          MessageModel value, $Res Function(MessageModel) then) =
      _$MessageModelCopyWithImpl<$Res, MessageModel>;
  @useResult
  $Res call(
      {String id,
      MessageUserModel user,
      String? message,
      String? media,
      List<dynamic>? isRead,
      String createdAt,
      String updatedAt});

  $MessageUserModelCopyWith<$Res> get user;
}

/// @nodoc
class _$MessageModelCopyWithImpl<$Res, $Val extends MessageModel>
    implements $MessageModelCopyWith<$Res> {
  _$MessageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user = null,
    Object? message = freezed,
    Object? media = freezed,
    Object? isRead = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as MessageUserModel,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      media: freezed == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: freezed == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MessageUserModelCopyWith<$Res> get user {
    return $MessageUserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MessageModelImplCopyWith<$Res>
    implements $MessageModelCopyWith<$Res> {
  factory _$$MessageModelImplCopyWith(
          _$MessageModelImpl value, $Res Function(_$MessageModelImpl) then) =
      __$$MessageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      MessageUserModel user,
      String? message,
      String? media,
      List<dynamic>? isRead,
      String createdAt,
      String updatedAt});

  @override
  $MessageUserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$MessageModelImplCopyWithImpl<$Res>
    extends _$MessageModelCopyWithImpl<$Res, _$MessageModelImpl>
    implements _$$MessageModelImplCopyWith<$Res> {
  __$$MessageModelImplCopyWithImpl(
      _$MessageModelImpl _value, $Res Function(_$MessageModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user = null,
    Object? message = freezed,
    Object? media = freezed,
    Object? isRead = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$MessageModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as MessageUserModel,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      media: freezed == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: freezed == isRead
          ? _value._isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$MessageModelImpl implements _MessageModel {
  const _$MessageModelImpl(
      {required this.id,
      required this.user,
      this.message,
      this.media,
      final List<dynamic>? isRead,
      required this.createdAt,
      required this.updatedAt})
      : _isRead = isRead;

  @override
  final String id;
  @override
  final MessageUserModel user;
  @override
  final String? message;
  @override
  final String? media;
  final List<dynamic>? _isRead;
  @override
  List<dynamic>? get isRead {
    final value = _isRead;
    if (value == null) return null;
    if (_isRead is EqualUnmodifiableListView) return _isRead;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String createdAt;
  @override
  final String updatedAt;

  @override
  String toString() {
    return 'MessageModel(id: $id, user: $user, message: $message, media: $media, isRead: $isRead, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.media, media) || other.media == media) &&
            const DeepCollectionEquality().equals(other._isRead, _isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, user, message, media,
      const DeepCollectionEquality().hash(_isRead), createdAt, updatedAt);

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      __$$MessageModelImplCopyWithImpl<_$MessageModelImpl>(this, _$identity);
}

abstract class _MessageModel implements MessageModel {
  const factory _MessageModel(
      {required final String id,
      required final MessageUserModel user,
      final String? message,
      final String? media,
      final List<dynamic>? isRead,
      required final String createdAt,
      required final String updatedAt}) = _$MessageModelImpl;

  @override
  String get id;
  @override
  MessageUserModel get user;
  @override
  String? get message;
  @override
  String? get media;
  @override
  List<dynamic>? get isRead;
  @override
  String get createdAt;
  @override
  String get updatedAt;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MessageUserModel _$MessageUserModelFromJson(Map<String, dynamic> json) {
  return _MessageUserModel.fromJson(json);
}

/// @nodoc
mixin _$MessageUserModel {
  String get userId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;

  /// Serializes this MessageUserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageUserModelCopyWith<MessageUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageUserModelCopyWith<$Res> {
  factory $MessageUserModelCopyWith(
          MessageUserModel value, $Res Function(MessageUserModel) then) =
      _$MessageUserModelCopyWithImpl<$Res, MessageUserModel>;
  @useResult
  $Res call({String userId, String displayName, String? avatar});
}

/// @nodoc
class _$MessageUserModelCopyWithImpl<$Res, $Val extends MessageUserModel>
    implements $MessageUserModelCopyWith<$Res> {
  _$MessageUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? avatar = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageUserModelImplCopyWith<$Res>
    implements $MessageUserModelCopyWith<$Res> {
  factory _$$MessageUserModelImplCopyWith(_$MessageUserModelImpl value,
          $Res Function(_$MessageUserModelImpl) then) =
      __$$MessageUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId, String displayName, String? avatar});
}

/// @nodoc
class __$$MessageUserModelImplCopyWithImpl<$Res>
    extends _$MessageUserModelCopyWithImpl<$Res, _$MessageUserModelImpl>
    implements _$$MessageUserModelImplCopyWith<$Res> {
  __$$MessageUserModelImplCopyWithImpl(_$MessageUserModelImpl _value,
      $Res Function(_$MessageUserModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MessageUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? avatar = freezed,
  }) {
    return _then(_$MessageUserModelImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$MessageUserModelImpl implements _MessageUserModel {
  const _$MessageUserModelImpl(
      {required this.userId, required this.displayName, this.avatar});

  factory _$MessageUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageUserModelImplFromJson(json);

  @override
  final String userId;
  @override
  final String displayName;
  @override
  final String? avatar;

  @override
  String toString() {
    return 'MessageUserModel(userId: $userId, displayName: $displayName, avatar: $avatar)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageUserModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.avatar, avatar) || other.avatar == avatar));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, displayName, avatar);

  /// Create a copy of MessageUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageUserModelImplCopyWith<_$MessageUserModelImpl> get copyWith =>
      __$$MessageUserModelImplCopyWithImpl<_$MessageUserModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageUserModelImplToJson(
      this,
    );
  }
}

abstract class _MessageUserModel implements MessageUserModel {
  const factory _MessageUserModel(
      {required final String userId,
      required final String displayName,
      final String? avatar}) = _$MessageUserModelImpl;

  factory _MessageUserModel.fromJson(Map<String, dynamic> json) =
      _$MessageUserModelImpl.fromJson;

  @override
  String get userId;
  @override
  String get displayName;
  @override
  String? get avatar;

  /// Create a copy of MessageUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageUserModelImplCopyWith<_$MessageUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
