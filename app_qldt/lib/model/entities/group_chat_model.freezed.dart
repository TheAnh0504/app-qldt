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
      GroupChatInfoMessageNotRead infoMessageNotRead});

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
      GroupChatInfoMessageNotRead infoMessageNotRead});

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
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$GroupChatModelImpl implements _GroupChatModel {
  const _$GroupChatModelImpl(
      {required this.infoGroup, required this.infoMessageNotRead});

  factory _$GroupChatModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupChatModelImplFromJson(json);

  @override
  final GroupChatInfoModel infoGroup;
  @override
  final GroupChatInfoMessageNotRead infoMessageNotRead;

  @override
  String toString() {
    return 'GroupChatModel(infoGroup: $infoGroup, infoMessageNotRead: $infoMessageNotRead)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupChatModelImpl &&
            (identical(other.infoGroup, infoGroup) ||
                other.infoGroup == infoGroup) &&
            (identical(other.infoMessageNotRead, infoMessageNotRead) ||
                other.infoMessageNotRead == infoMessageNotRead));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, infoGroup, infoMessageNotRead);

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
          required final GroupChatInfoMessageNotRead infoMessageNotRead}) =
      _$GroupChatModelImpl;

  factory _GroupChatModel.fromJson(Map<String, dynamic> json) =
      _$GroupChatModelImpl.fromJson;

  @override
  GroupChatInfoModel get infoGroup;
  @override
  GroupChatInfoMessageNotRead get infoMessageNotRead;

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
  String get groupId => throw _privateConstructorUsedError;
  Object get groupName => throw _privateConstructorUsedError;
  List<String> get listUserId => throw _privateConstructorUsedError;
  List<String> get listAdmin => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
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
      {String groupId,
      Object groupName,
      List<String> listUserId,
      List<String> listAdmin,
      String? image,
      String type,
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
    Object? groupName = null,
    Object? listUserId = null,
    Object? listAdmin = null,
    Object? image = freezed,
    Object? type = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      groupName: null == groupName ? _value.groupName : groupName,
      listUserId: null == listUserId
          ? _value.listUserId
          : listUserId // ignore: cast_nullable_to_non_nullable
              as List<String>,
      listAdmin: null == listAdmin
          ? _value.listAdmin
          : listAdmin // ignore: cast_nullable_to_non_nullable
              as List<String>,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
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
      {String groupId,
      Object groupName,
      List<String> listUserId,
      List<String> listAdmin,
      String? image,
      String type,
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
    Object? groupName = null,
    Object? listUserId = null,
    Object? listAdmin = null,
    Object? image = freezed,
    Object? type = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$GroupChatInfoModelImpl(
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      groupName: null == groupName ? _value.groupName : groupName,
      listUserId: null == listUserId
          ? _value._listUserId
          : listUserId // ignore: cast_nullable_to_non_nullable
              as List<String>,
      listAdmin: null == listAdmin
          ? _value._listAdmin
          : listAdmin // ignore: cast_nullable_to_non_nullable
              as List<String>,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
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
      required this.groupName,
      required final List<String> listUserId,
      final List<String> listAdmin = const [],
      this.image,
      required this.type,
      required this.createdAt,
      required this.updatedAt})
      : _listUserId = listUserId,
        _listAdmin = listAdmin;

  factory _$GroupChatInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupChatInfoModelImplFromJson(json);

  @override
  final String groupId;
  @override
  final Object groupName;
  final List<String> _listUserId;
  @override
  List<String> get listUserId {
    if (_listUserId is EqualUnmodifiableListView) return _listUserId;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_listUserId);
  }

  final List<String> _listAdmin;
  @override
  @JsonKey()
  List<String> get listAdmin {
    if (_listAdmin is EqualUnmodifiableListView) return _listAdmin;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_listAdmin);
  }

  @override
  final String? image;
  @override
  final String type;
  @override
  final String createdAt;
  @override
  final String updatedAt;

  @override
  String toString() {
    return 'GroupChatInfoModel(groupId: $groupId, groupName: $groupName, listUserId: $listUserId, listAdmin: $listAdmin, image: $image, type: $type, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupChatInfoModelImpl &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            const DeepCollectionEquality().equals(other.groupName, groupName) &&
            const DeepCollectionEquality()
                .equals(other._listUserId, _listUserId) &&
            const DeepCollectionEquality()
                .equals(other._listAdmin, _listAdmin) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.type, type) || other.type == type) &&
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
      const DeepCollectionEquality().hash(groupName),
      const DeepCollectionEquality().hash(_listUserId),
      const DeepCollectionEquality().hash(_listAdmin),
      image,
      type,
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
      {required final String groupId,
      required final Object groupName,
      required final List<String> listUserId,
      final List<String> listAdmin,
      final String? image,
      required final String type,
      required final String createdAt,
      required final String updatedAt}) = _$GroupChatInfoModelImpl;

  factory _GroupChatInfoModel.fromJson(Map<String, dynamic> json) =
      _$GroupChatInfoModelImpl.fromJson;

  @override
  String get groupId;
  @override
  Object get groupName;
  @override
  List<String> get listUserId;
  @override
  List<String> get listAdmin;
  @override
  String? get image;
  @override
  String get type;
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
  int get countMessageNotRead => throw _privateConstructorUsedError;
  String get groupId => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;

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
  $Res call({int countMessageNotRead, String groupId, String? avatar});
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
    Object? countMessageNotRead = null,
    Object? groupId = null,
    Object? avatar = freezed,
  }) {
    return _then(_value.copyWith(
      countMessageNotRead: null == countMessageNotRead
          ? _value.countMessageNotRead
          : countMessageNotRead // ignore: cast_nullable_to_non_nullable
              as int,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
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
  $Res call({int countMessageNotRead, String groupId, String? avatar});
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
    Object? countMessageNotRead = null,
    Object? groupId = null,
    Object? avatar = freezed,
  }) {
    return _then(_$GroupChatInfoMessageNotReadImpl(
      countMessageNotRead: null == countMessageNotRead
          ? _value.countMessageNotRead
          : countMessageNotRead // ignore: cast_nullable_to_non_nullable
              as int,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupChatInfoMessageNotReadImpl
    implements _GroupChatInfoMessageNotRead {
  const _$GroupChatInfoMessageNotReadImpl(
      {required this.countMessageNotRead, required this.groupId, this.avatar});

  factory _$GroupChatInfoMessageNotReadImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$GroupChatInfoMessageNotReadImplFromJson(json);

  @override
  final int countMessageNotRead;
  @override
  final String groupId;
  @override
  final String? avatar;

  @override
  String toString() {
    return 'GroupChatInfoMessageNotRead(countMessageNotRead: $countMessageNotRead, groupId: $groupId, avatar: $avatar)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupChatInfoMessageNotReadImpl &&
            (identical(other.countMessageNotRead, countMessageNotRead) ||
                other.countMessageNotRead == countMessageNotRead) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.avatar, avatar) || other.avatar == avatar));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, countMessageNotRead, groupId, avatar);

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
      {required final int countMessageNotRead,
      required final String groupId,
      final String? avatar}) = _$GroupChatInfoMessageNotReadImpl;

  factory _GroupChatInfoMessageNotRead.fromJson(Map<String, dynamic> json) =
      _$GroupChatInfoMessageNotReadImpl.fromJson;

  @override
  int get countMessageNotRead;
  @override
  String get groupId;
  @override
  String? get avatar;

  /// Create a copy of GroupChatInfoMessageNotRead
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupChatInfoMessageNotReadImplCopyWith<_$GroupChatInfoMessageNotReadImpl>
      get copyWith => throw _privateConstructorUsedError;
}
