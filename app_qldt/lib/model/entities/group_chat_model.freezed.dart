// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_chat_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GroupChatModel _$GroupChatModelFromJson(Map<String, dynamic> json) {
  return _GroupChatModel.fromJson(json);
}

/// @nodoc
mixin _$GroupChatModel {
  GroupChatInfoModel get infoGroup => throw _privateConstructorUsedError;
  GroupChatInfoMessageNotRead get infoMessageNotRead =>
      throw _privateConstructorUsedError;
  int get numNewMessage => throw _privateConstructorUsedError;

  /// Serializes this GroupChatModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupChatModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupChatModelCopyWith<GroupChatModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupChatModelCopyWith<$Res> {
  factory $GroupChatModelCopyWith(
          GroupChatModel value, $Res Function(GroupChatModel) then) =
      _$GroupChatModelCopyWithImpl<$Res, GroupChatModel>;
  @useResult
  $Res call(
      {GroupChatInfoModel infoGroup,
      GroupChatInfoMessageNotRead infoMessageNotRead,
      int numNewMessage});

  $GroupChatInfoModelCopyWith<$Res> get infoGroup;
  $GroupChatInfoMessageNotReadCopyWith<$Res> get infoMessageNotRead;
}

/// @nodoc
class _$GroupChatModelCopyWithImpl<$Res, $Val extends GroupChatModel>
    implements $GroupChatModelCopyWith<$Res> {
  _$GroupChatModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupChatModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? infoGroup = null,
    Object? infoMessageNotRead = null,
    Object? numNewMessage = null,
  }) {
    return _then(_value.copyWith(
      infoGroup: null == infoGroup
          ? _value.infoGroup
          : infoGroup // ignore: cast_nullable_to_non_nullable
              as GroupChatInfoModel,
      infoMessageNotRead: null == infoMessageNotRead
          ? _value.infoMessageNotRead
          : infoMessageNotRead // ignore: cast_nullable_to_non_nullable
              as GroupChatInfoMessageNotRead,
      numNewMessage: null == numNewMessage
          ? _value.numNewMessage
          : numNewMessage // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of GroupChatModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GroupChatInfoModelCopyWith<$Res> get infoGroup {
    return $GroupChatInfoModelCopyWith<$Res>(_value.infoGroup, (value) {
      return _then(_value.copyWith(infoGroup: value) as $Val);
    });
  }

  /// Create a copy of GroupChatModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GroupChatInfoMessageNotReadCopyWith<$Res> get infoMessageNotRead {
    return $GroupChatInfoMessageNotReadCopyWith<$Res>(_value.infoMessageNotRead,
        (value) {
      return _then(_value.copyWith(infoMessageNotRead: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GroupChatModelImplCopyWith<$Res>
    implements $GroupChatModelCopyWith<$Res> {
  factory _$$GroupChatModelImplCopyWith(_$GroupChatModelImpl value,
          $Res Function(_$GroupChatModelImpl) then) =
      __$$GroupChatModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {GroupChatInfoModel infoGroup,
      GroupChatInfoMessageNotRead infoMessageNotRead,
      int numNewMessage});

  @override
  $GroupChatInfoModelCopyWith<$Res> get infoGroup;
  @override
  $GroupChatInfoMessageNotReadCopyWith<$Res> get infoMessageNotRead;
}

/// @nodoc
class __$$GroupChatModelImplCopyWithImpl<$Res>
    extends _$GroupChatModelCopyWithImpl<$Res, _$GroupChatModelImpl>
    implements _$$GroupChatModelImplCopyWith<$Res> {
  __$$GroupChatModelImplCopyWithImpl(
      _$GroupChatModelImpl _value, $Res Function(_$GroupChatModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupChatModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? infoGroup = null,
    Object? infoMessageNotRead = null,
    Object? numNewMessage = null,
  }) {
    return _then(_$GroupChatModelImpl(
      infoGroup: null == infoGroup
          ? _value.infoGroup
          : infoGroup // ignore: cast_nullable_to_non_nullable
              as GroupChatInfoModel,
      infoMessageNotRead: null == infoMessageNotRead
          ? _value.infoMessageNotRead
          : infoMessageNotRead // ignore: cast_nullable_to_non_nullable
              as GroupChatInfoMessageNotRead,
      numNewMessage: null == numNewMessage
          ? _value.numNewMessage
          : numNewMessage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$GroupChatModelImpl implements _GroupChatModel {
  const _$GroupChatModelImpl(
      {required this.infoGroup,
      required this.infoMessageNotRead,
      required this.numNewMessage});

  factory _$GroupChatModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupChatModelImplFromJson(json);

  @override
  final GroupChatInfoModel infoGroup;
  @override
  final GroupChatInfoMessageNotRead infoMessageNotRead;
  @override
  final int numNewMessage;

  @override
  String toString() {
    return 'GroupChatModel(infoGroup: $infoGroup, infoMessageNotRead: $infoMessageNotRead, numNewMessage: $numNewMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupChatModelImpl &&
            (identical(other.infoGroup, infoGroup) ||
                other.infoGroup == infoGroup) &&
            (identical(other.infoMessageNotRead, infoMessageNotRead) ||
                other.infoMessageNotRead == infoMessageNotRead) &&
            (identical(other.numNewMessage, numNewMessage) ||
                other.numNewMessage == numNewMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, infoGroup, infoMessageNotRead, numNewMessage);

  /// Create a copy of GroupChatModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupChatModelImplCopyWith<_$GroupChatModelImpl> get copyWith =>
      __$$GroupChatModelImplCopyWithImpl<_$GroupChatModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupChatModelImplToJson(
      this,
    );
  }
}

abstract class _GroupChatModel implements GroupChatModel {
  const factory _GroupChatModel(
      {required final GroupChatInfoModel infoGroup,
      required final GroupChatInfoMessageNotRead infoMessageNotRead,
      required final int numNewMessage}) = _$GroupChatModelImpl;

  factory _GroupChatModel.fromJson(Map<String, dynamic> json) =
      _$GroupChatModelImpl.fromJson;

  @override
  GroupChatInfoModel get infoGroup;
  @override
  GroupChatInfoMessageNotRead get infoMessageNotRead;
  @override
  int get numNewMessage;

  /// Create a copy of GroupChatModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupChatModelImplCopyWith<_$GroupChatModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GroupChatInfoModel _$GroupChatInfoModelFromJson(Map<String, dynamic> json) {
  return _GroupChatInfoModel.fromJson(json);
}

/// @nodoc
mixin _$GroupChatInfoModel {
  int get groupId => throw _privateConstructorUsedError; // id of chat
  int get partnerId =>
      throw _privateConstructorUsedError; // info of người chat vs mình: id, name, avatar
  String get partnerName => throw _privateConstructorUsedError;
  String? get partnerAvatar => throw _privateConstructorUsedError;
  int get lastMessageSenderId =>
      throw _privateConstructorUsedError; // last message: sender(id, name, avatar), message, created_at, unread
  String get lastMessageSenderName => throw _privateConstructorUsedError;
  String? get lastMessageSenderAvatar => throw _privateConstructorUsedError;
  String? get lastMessageMessage => throw _privateConstructorUsedError;
  String get lastMessageCreatedAt => throw _privateConstructorUsedError;
  int get lastMessageUnRead => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this GroupChatInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupChatInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupChatInfoModelCopyWith<GroupChatInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupChatInfoModelCopyWith<$Res> {
  factory $GroupChatInfoModelCopyWith(
          GroupChatInfoModel value, $Res Function(GroupChatInfoModel) then) =
      _$GroupChatInfoModelCopyWithImpl<$Res, GroupChatInfoModel>;
  @useResult
  $Res call(
      {int groupId,
      int partnerId,
      String partnerName,
      String? partnerAvatar,
      int lastMessageSenderId,
      String lastMessageSenderName,
      String? lastMessageSenderAvatar,
      String? lastMessageMessage,
      String lastMessageCreatedAt,
      int lastMessageUnRead,
      String createdAt,
      String updatedAt});
}

/// @nodoc
class _$GroupChatInfoModelCopyWithImpl<$Res, $Val extends GroupChatInfoModel>
    implements $GroupChatInfoModelCopyWith<$Res> {
  _$GroupChatInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupChatInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? partnerId = null,
    Object? partnerName = null,
    Object? partnerAvatar = freezed,
    Object? lastMessageSenderId = null,
    Object? lastMessageSenderName = null,
    Object? lastMessageSenderAvatar = freezed,
    Object? lastMessageMessage = freezed,
    Object? lastMessageCreatedAt = null,
    Object? lastMessageUnRead = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as int,
      partnerId: null == partnerId
          ? _value.partnerId
          : partnerId // ignore: cast_nullable_to_non_nullable
              as int,
      partnerName: null == partnerName
          ? _value.partnerName
          : partnerName // ignore: cast_nullable_to_non_nullable
              as String,
      partnerAvatar: freezed == partnerAvatar
          ? _value.partnerAvatar
          : partnerAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageSenderId: null == lastMessageSenderId
          ? _value.lastMessageSenderId
          : lastMessageSenderId // ignore: cast_nullable_to_non_nullable
              as int,
      lastMessageSenderName: null == lastMessageSenderName
          ? _value.lastMessageSenderName
          : lastMessageSenderName // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessageSenderAvatar: freezed == lastMessageSenderAvatar
          ? _value.lastMessageSenderAvatar
          : lastMessageSenderAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageMessage: freezed == lastMessageMessage
          ? _value.lastMessageMessage
          : lastMessageMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageCreatedAt: null == lastMessageCreatedAt
          ? _value.lastMessageCreatedAt
          : lastMessageCreatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessageUnRead: null == lastMessageUnRead
          ? _value.lastMessageUnRead
          : lastMessageUnRead // ignore: cast_nullable_to_non_nullable
              as int,
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
}

/// @nodoc
abstract class _$$GroupChatInfoModelImplCopyWith<$Res>
    implements $GroupChatInfoModelCopyWith<$Res> {
  factory _$$GroupChatInfoModelImplCopyWith(_$GroupChatInfoModelImpl value,
          $Res Function(_$GroupChatInfoModelImpl) then) =
      __$$GroupChatInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int groupId,
      int partnerId,
      String partnerName,
      String? partnerAvatar,
      int lastMessageSenderId,
      String lastMessageSenderName,
      String? lastMessageSenderAvatar,
      String? lastMessageMessage,
      String lastMessageCreatedAt,
      int lastMessageUnRead,
      String createdAt,
      String updatedAt});
}

/// @nodoc
class __$$GroupChatInfoModelImplCopyWithImpl<$Res>
    extends _$GroupChatInfoModelCopyWithImpl<$Res, _$GroupChatInfoModelImpl>
    implements _$$GroupChatInfoModelImplCopyWith<$Res> {
  __$$GroupChatInfoModelImplCopyWithImpl(_$GroupChatInfoModelImpl _value,
      $Res Function(_$GroupChatInfoModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupChatInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? partnerId = null,
    Object? partnerName = null,
    Object? partnerAvatar = freezed,
    Object? lastMessageSenderId = null,
    Object? lastMessageSenderName = null,
    Object? lastMessageSenderAvatar = freezed,
    Object? lastMessageMessage = freezed,
    Object? lastMessageCreatedAt = null,
    Object? lastMessageUnRead = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$GroupChatInfoModelImpl(
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as int,
      partnerId: null == partnerId
          ? _value.partnerId
          : partnerId // ignore: cast_nullable_to_non_nullable
              as int,
      partnerName: null == partnerName
          ? _value.partnerName
          : partnerName // ignore: cast_nullable_to_non_nullable
              as String,
      partnerAvatar: freezed == partnerAvatar
          ? _value.partnerAvatar
          : partnerAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageSenderId: null == lastMessageSenderId
          ? _value.lastMessageSenderId
          : lastMessageSenderId // ignore: cast_nullable_to_non_nullable
              as int,
      lastMessageSenderName: null == lastMessageSenderName
          ? _value.lastMessageSenderName
          : lastMessageSenderName // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessageSenderAvatar: freezed == lastMessageSenderAvatar
          ? _value.lastMessageSenderAvatar
          : lastMessageSenderAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageMessage: freezed == lastMessageMessage
          ? _value.lastMessageMessage
          : lastMessageMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageCreatedAt: null == lastMessageCreatedAt
          ? _value.lastMessageCreatedAt
          : lastMessageCreatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessageUnRead: null == lastMessageUnRead
          ? _value.lastMessageUnRead
          : lastMessageUnRead // ignore: cast_nullable_to_non_nullable
              as int,
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
@JsonSerializable()
class _$GroupChatInfoModelImpl implements _GroupChatInfoModel {
  const _$GroupChatInfoModelImpl(
      {required this.groupId,
      required this.partnerId,
      required this.partnerName,
      this.partnerAvatar,
      required this.lastMessageSenderId,
      required this.lastMessageSenderName,
      this.lastMessageSenderAvatar,
      this.lastMessageMessage,
      required this.lastMessageCreatedAt,
      required this.lastMessageUnRead,
      required this.createdAt,
      required this.updatedAt});

  factory _$GroupChatInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupChatInfoModelImplFromJson(json);

  @override
  final int groupId;
// id of chat
  @override
  final int partnerId;
// info of người chat vs mình: id, name, avatar
  @override
  final String partnerName;
  @override
  final String? partnerAvatar;
  @override
  final int lastMessageSenderId;
// last message: sender(id, name, avatar), message, created_at, unread
  @override
  final String lastMessageSenderName;
  @override
  final String? lastMessageSenderAvatar;
  @override
  final String? lastMessageMessage;
  @override
  final String lastMessageCreatedAt;
  @override
  final int lastMessageUnRead;
  @override
  final String createdAt;
  @override
  final String updatedAt;

  @override
  String toString() {
    return 'GroupChatInfoModel(groupId: $groupId, partnerId: $partnerId, partnerName: $partnerName, partnerAvatar: $partnerAvatar, lastMessageSenderId: $lastMessageSenderId, lastMessageSenderName: $lastMessageSenderName, lastMessageSenderAvatar: $lastMessageSenderAvatar, lastMessageMessage: $lastMessageMessage, lastMessageCreatedAt: $lastMessageCreatedAt, lastMessageUnRead: $lastMessageUnRead, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupChatInfoModelImpl &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.partnerId, partnerId) ||
                other.partnerId == partnerId) &&
            (identical(other.partnerName, partnerName) ||
                other.partnerName == partnerName) &&
            (identical(other.partnerAvatar, partnerAvatar) ||
                other.partnerAvatar == partnerAvatar) &&
            (identical(other.lastMessageSenderId, lastMessageSenderId) ||
                other.lastMessageSenderId == lastMessageSenderId) &&
            (identical(other.lastMessageSenderName, lastMessageSenderName) ||
                other.lastMessageSenderName == lastMessageSenderName) &&
            (identical(
                    other.lastMessageSenderAvatar, lastMessageSenderAvatar) ||
                other.lastMessageSenderAvatar == lastMessageSenderAvatar) &&
            (identical(other.lastMessageMessage, lastMessageMessage) ||
                other.lastMessageMessage == lastMessageMessage) &&
            (identical(other.lastMessageCreatedAt, lastMessageCreatedAt) ||
                other.lastMessageCreatedAt == lastMessageCreatedAt) &&
            (identical(other.lastMessageUnRead, lastMessageUnRead) ||
                other.lastMessageUnRead == lastMessageUnRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      groupId,
      partnerId,
      partnerName,
      partnerAvatar,
      lastMessageSenderId,
      lastMessageSenderName,
      lastMessageSenderAvatar,
      lastMessageMessage,
      lastMessageCreatedAt,
      lastMessageUnRead,
      createdAt,
      updatedAt);

  /// Create a copy of GroupChatInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupChatInfoModelImplCopyWith<_$GroupChatInfoModelImpl> get copyWith =>
      __$$GroupChatInfoModelImplCopyWithImpl<_$GroupChatInfoModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupChatInfoModelImplToJson(
      this,
    );
  }
}

abstract class _GroupChatInfoModel implements GroupChatInfoModel {
  const factory _GroupChatInfoModel(
      {required final int groupId,
      required final int partnerId,
      required final String partnerName,
      final String? partnerAvatar,
      required final int lastMessageSenderId,
      required final String lastMessageSenderName,
      final String? lastMessageSenderAvatar,
      final String? lastMessageMessage,
      required final String lastMessageCreatedAt,
      required final int lastMessageUnRead,
      required final String createdAt,
      required final String updatedAt}) = _$GroupChatInfoModelImpl;

  factory _GroupChatInfoModel.fromJson(Map<String, dynamic> json) =
      _$GroupChatInfoModelImpl.fromJson;

  @override
  int get groupId; // id of chat
  @override
  int get partnerId; // info of người chat vs mình: id, name, avatar
  @override
  String get partnerName;
  @override
  String? get partnerAvatar;
  @override
  int get lastMessageSenderId; // last message: sender(id, name, avatar), message, created_at, unread
  @override
  String get lastMessageSenderName;
  @override
  String? get lastMessageSenderAvatar;
  @override
  String? get lastMessageMessage;
  @override
  String get lastMessageCreatedAt;
  @override
  int get lastMessageUnRead;
  @override
  String get createdAt;
  @override
  String get updatedAt;

  /// Create a copy of GroupChatInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupChatInfoModelImplCopyWith<_$GroupChatInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GroupChatInfoMessageNotRead _$GroupChatInfoMessageNotReadFromJson(
    Map<String, dynamic> json) {
  return _GroupChatInfoMessageNotRead.fromJson(json);
}

/// @nodoc
mixin _$GroupChatInfoMessageNotRead {
  int get groupId => throw _privateConstructorUsedError; // id of chat
  int get partnerId =>
      throw _privateConstructorUsedError; // info of người chat vs mình: id, name, avatar
  String get partnerName => throw _privateConstructorUsedError;
  String? get partnerAvatar => throw _privateConstructorUsedError;
  int get lastMessageSenderId =>
      throw _privateConstructorUsedError; // last message: sender(id, name, avatar), message, created_at, unread
  String get lastMessageSenderName => throw _privateConstructorUsedError;
  String? get lastMessageSenderAvatar => throw _privateConstructorUsedError;
  String? get lastMessageMessage => throw _privateConstructorUsedError;
  String get lastMessageCreatedAt => throw _privateConstructorUsedError;
  int get lastMessageUnRead => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this GroupChatInfoMessageNotRead to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupChatInfoMessageNotRead
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupChatInfoMessageNotReadCopyWith<GroupChatInfoMessageNotRead>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupChatInfoMessageNotReadCopyWith<$Res> {
  factory $GroupChatInfoMessageNotReadCopyWith(
          GroupChatInfoMessageNotRead value,
          $Res Function(GroupChatInfoMessageNotRead) then) =
      _$GroupChatInfoMessageNotReadCopyWithImpl<$Res,
          GroupChatInfoMessageNotRead>;
  @useResult
  $Res call(
      {int groupId,
      int partnerId,
      String partnerName,
      String? partnerAvatar,
      int lastMessageSenderId,
      String lastMessageSenderName,
      String? lastMessageSenderAvatar,
      String? lastMessageMessage,
      String lastMessageCreatedAt,
      int lastMessageUnRead,
      String createdAt,
      String updatedAt});
}

/// @nodoc
class _$GroupChatInfoMessageNotReadCopyWithImpl<$Res,
        $Val extends GroupChatInfoMessageNotRead>
    implements $GroupChatInfoMessageNotReadCopyWith<$Res> {
  _$GroupChatInfoMessageNotReadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupChatInfoMessageNotRead
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? partnerId = null,
    Object? partnerName = null,
    Object? partnerAvatar = freezed,
    Object? lastMessageSenderId = null,
    Object? lastMessageSenderName = null,
    Object? lastMessageSenderAvatar = freezed,
    Object? lastMessageMessage = freezed,
    Object? lastMessageCreatedAt = null,
    Object? lastMessageUnRead = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as int,
      partnerId: null == partnerId
          ? _value.partnerId
          : partnerId // ignore: cast_nullable_to_non_nullable
              as int,
      partnerName: null == partnerName
          ? _value.partnerName
          : partnerName // ignore: cast_nullable_to_non_nullable
              as String,
      partnerAvatar: freezed == partnerAvatar
          ? _value.partnerAvatar
          : partnerAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageSenderId: null == lastMessageSenderId
          ? _value.lastMessageSenderId
          : lastMessageSenderId // ignore: cast_nullable_to_non_nullable
              as int,
      lastMessageSenderName: null == lastMessageSenderName
          ? _value.lastMessageSenderName
          : lastMessageSenderName // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessageSenderAvatar: freezed == lastMessageSenderAvatar
          ? _value.lastMessageSenderAvatar
          : lastMessageSenderAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageMessage: freezed == lastMessageMessage
          ? _value.lastMessageMessage
          : lastMessageMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageCreatedAt: null == lastMessageCreatedAt
          ? _value.lastMessageCreatedAt
          : lastMessageCreatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessageUnRead: null == lastMessageUnRead
          ? _value.lastMessageUnRead
          : lastMessageUnRead // ignore: cast_nullable_to_non_nullable
              as int,
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
}

/// @nodoc
abstract class _$$GroupChatInfoMessageNotReadImplCopyWith<$Res>
    implements $GroupChatInfoMessageNotReadCopyWith<$Res> {
  factory _$$GroupChatInfoMessageNotReadImplCopyWith(
          _$GroupChatInfoMessageNotReadImpl value,
          $Res Function(_$GroupChatInfoMessageNotReadImpl) then) =
      __$$GroupChatInfoMessageNotReadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int groupId,
      int partnerId,
      String partnerName,
      String? partnerAvatar,
      int lastMessageSenderId,
      String lastMessageSenderName,
      String? lastMessageSenderAvatar,
      String? lastMessageMessage,
      String lastMessageCreatedAt,
      int lastMessageUnRead,
      String createdAt,
      String updatedAt});
}

/// @nodoc
class __$$GroupChatInfoMessageNotReadImplCopyWithImpl<$Res>
    extends _$GroupChatInfoMessageNotReadCopyWithImpl<$Res,
        _$GroupChatInfoMessageNotReadImpl>
    implements _$$GroupChatInfoMessageNotReadImplCopyWith<$Res> {
  __$$GroupChatInfoMessageNotReadImplCopyWithImpl(
      _$GroupChatInfoMessageNotReadImpl _value,
      $Res Function(_$GroupChatInfoMessageNotReadImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupChatInfoMessageNotRead
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? partnerId = null,
    Object? partnerName = null,
    Object? partnerAvatar = freezed,
    Object? lastMessageSenderId = null,
    Object? lastMessageSenderName = null,
    Object? lastMessageSenderAvatar = freezed,
    Object? lastMessageMessage = freezed,
    Object? lastMessageCreatedAt = null,
    Object? lastMessageUnRead = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$GroupChatInfoMessageNotReadImpl(
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as int,
      partnerId: null == partnerId
          ? _value.partnerId
          : partnerId // ignore: cast_nullable_to_non_nullable
              as int,
      partnerName: null == partnerName
          ? _value.partnerName
          : partnerName // ignore: cast_nullable_to_non_nullable
              as String,
      partnerAvatar: freezed == partnerAvatar
          ? _value.partnerAvatar
          : partnerAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageSenderId: null == lastMessageSenderId
          ? _value.lastMessageSenderId
          : lastMessageSenderId // ignore: cast_nullable_to_non_nullable
              as int,
      lastMessageSenderName: null == lastMessageSenderName
          ? _value.lastMessageSenderName
          : lastMessageSenderName // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessageSenderAvatar: freezed == lastMessageSenderAvatar
          ? _value.lastMessageSenderAvatar
          : lastMessageSenderAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageMessage: freezed == lastMessageMessage
          ? _value.lastMessageMessage
          : lastMessageMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageCreatedAt: null == lastMessageCreatedAt
          ? _value.lastMessageCreatedAt
          : lastMessageCreatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessageUnRead: null == lastMessageUnRead
          ? _value.lastMessageUnRead
          : lastMessageUnRead // ignore: cast_nullable_to_non_nullable
              as int,
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
@JsonSerializable()
class _$GroupChatInfoMessageNotReadImpl
    implements _GroupChatInfoMessageNotRead {
  const _$GroupChatInfoMessageNotReadImpl(
      {required this.groupId,
      required this.partnerId,
      required this.partnerName,
      this.partnerAvatar,
      required this.lastMessageSenderId,
      required this.lastMessageSenderName,
      this.lastMessageSenderAvatar,
      this.lastMessageMessage,
      required this.lastMessageCreatedAt,
      required this.lastMessageUnRead,
      required this.createdAt,
      required this.updatedAt});

  factory _$GroupChatInfoMessageNotReadImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$GroupChatInfoMessageNotReadImplFromJson(json);

  @override
  final int groupId;
// id of chat
  @override
  final int partnerId;
// info of người chat vs mình: id, name, avatar
  @override
  final String partnerName;
  @override
  final String? partnerAvatar;
  @override
  final int lastMessageSenderId;
// last message: sender(id, name, avatar), message, created_at, unread
  @override
  final String lastMessageSenderName;
  @override
  final String? lastMessageSenderAvatar;
  @override
  final String? lastMessageMessage;
  @override
  final String lastMessageCreatedAt;
  @override
  final int lastMessageUnRead;
  @override
  final String createdAt;
  @override
  final String updatedAt;

  @override
  String toString() {
    return 'GroupChatInfoMessageNotRead(groupId: $groupId, partnerId: $partnerId, partnerName: $partnerName, partnerAvatar: $partnerAvatar, lastMessageSenderId: $lastMessageSenderId, lastMessageSenderName: $lastMessageSenderName, lastMessageSenderAvatar: $lastMessageSenderAvatar, lastMessageMessage: $lastMessageMessage, lastMessageCreatedAt: $lastMessageCreatedAt, lastMessageUnRead: $lastMessageUnRead, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupChatInfoMessageNotReadImpl &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.partnerId, partnerId) ||
                other.partnerId == partnerId) &&
            (identical(other.partnerName, partnerName) ||
                other.partnerName == partnerName) &&
            (identical(other.partnerAvatar, partnerAvatar) ||
                other.partnerAvatar == partnerAvatar) &&
            (identical(other.lastMessageSenderId, lastMessageSenderId) ||
                other.lastMessageSenderId == lastMessageSenderId) &&
            (identical(other.lastMessageSenderName, lastMessageSenderName) ||
                other.lastMessageSenderName == lastMessageSenderName) &&
            (identical(
                    other.lastMessageSenderAvatar, lastMessageSenderAvatar) ||
                other.lastMessageSenderAvatar == lastMessageSenderAvatar) &&
            (identical(other.lastMessageMessage, lastMessageMessage) ||
                other.lastMessageMessage == lastMessageMessage) &&
            (identical(other.lastMessageCreatedAt, lastMessageCreatedAt) ||
                other.lastMessageCreatedAt == lastMessageCreatedAt) &&
            (identical(other.lastMessageUnRead, lastMessageUnRead) ||
                other.lastMessageUnRead == lastMessageUnRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      groupId,
      partnerId,
      partnerName,
      partnerAvatar,
      lastMessageSenderId,
      lastMessageSenderName,
      lastMessageSenderAvatar,
      lastMessageMessage,
      lastMessageCreatedAt,
      lastMessageUnRead,
      createdAt,
      updatedAt);

  /// Create a copy of GroupChatInfoMessageNotRead
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupChatInfoMessageNotReadImplCopyWith<_$GroupChatInfoMessageNotReadImpl>
      get copyWith => __$$GroupChatInfoMessageNotReadImplCopyWithImpl<
          _$GroupChatInfoMessageNotReadImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupChatInfoMessageNotReadImplToJson(
      this,
    );
  }
}

abstract class _GroupChatInfoMessageNotRead
    implements GroupChatInfoMessageNotRead {
  const factory _GroupChatInfoMessageNotRead(
      {required final int groupId,
      required final int partnerId,
      required final String partnerName,
      final String? partnerAvatar,
      required final int lastMessageSenderId,
      required final String lastMessageSenderName,
      final String? lastMessageSenderAvatar,
      final String? lastMessageMessage,
      required final String lastMessageCreatedAt,
      required final int lastMessageUnRead,
      required final String createdAt,
      required final String updatedAt}) = _$GroupChatInfoMessageNotReadImpl;

  factory _GroupChatInfoMessageNotRead.fromJson(Map<String, dynamic> json) =
      _$GroupChatInfoMessageNotReadImpl.fromJson;

  @override
  int get groupId; // id of chat
  @override
  int get partnerId; // info of người chat vs mình: id, name, avatar
  @override
  String get partnerName;
  @override
  String? get partnerAvatar;
  @override
  int get lastMessageSenderId; // last message: sender(id, name, avatar), message, created_at, unread
  @override
  String get lastMessageSenderName;
  @override
  String? get lastMessageSenderAvatar;
  @override
  String? get lastMessageMessage;
  @override
  String get lastMessageCreatedAt;
  @override
  int get lastMessageUnRead;
  @override
  String get createdAt;
  @override
  String get updatedAt;

  /// Create a copy of GroupChatInfoMessageNotRead
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupChatInfoMessageNotReadImplCopyWith<_$GroupChatInfoMessageNotReadImpl>
      get copyWith => throw _privateConstructorUsedError;
}
