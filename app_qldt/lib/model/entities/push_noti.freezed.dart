// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_noti.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PushNoti _$PushNotiFromJson(Map<String, dynamic> json) {
  return _PushNoti.fromJson(json);
}

/// @nodoc
mixin _$PushNoti {
  Map<String, dynamic> get notification => throw _privateConstructorUsedError;
  Map<String, dynamic> get author => throw _privateConstructorUsedError;
  Map<String, dynamic> get user => throw _privateConstructorUsedError;

  /// Serializes this PushNoti to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PushNoti
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PushNotiCopyWith<PushNoti> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PushNotiCopyWith<$Res> {
  factory $PushNotiCopyWith(PushNoti value, $Res Function(PushNoti) then) =
      _$PushNotiCopyWithImpl<$Res, PushNoti>;
  @useResult
  $Res call(
      {Map<String, dynamic> notification,
      Map<String, dynamic> author,
      Map<String, dynamic> user});
}

/// @nodoc
class _$PushNotiCopyWithImpl<$Res, $Val extends PushNoti>
    implements $PushNotiCopyWith<$Res> {
  _$PushNotiCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PushNoti
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notification = null,
    Object? author = null,
    Object? user = null,
  }) {
    return _then(_value.copyWith(
      notification: null == notification
          ? _value.notification
          : notification // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PushNotiImplCopyWith<$Res>
    implements $PushNotiCopyWith<$Res> {
  factory _$$PushNotiImplCopyWith(
          _$PushNotiImpl value, $Res Function(_$PushNotiImpl) then) =
      __$$PushNotiImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, dynamic> notification,
      Map<String, dynamic> author,
      Map<String, dynamic> user});
}

/// @nodoc
class __$$PushNotiImplCopyWithImpl<$Res>
    extends _$PushNotiCopyWithImpl<$Res, _$PushNotiImpl>
    implements _$$PushNotiImplCopyWith<$Res> {
  __$$PushNotiImplCopyWithImpl(
      _$PushNotiImpl _value, $Res Function(_$PushNotiImpl) _then)
      : super(_value, _then);

  /// Create a copy of PushNoti
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notification = null,
    Object? author = null,
    Object? user = null,
  }) {
    return _then(_$PushNotiImpl(
      notification: null == notification
          ? _value._notification
          : notification // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      author: null == author
          ? _value._author
          : author // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      user: null == user
          ? _value._user
          : user // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PushNotiImpl implements _PushNoti {
  const _$PushNotiImpl(
      {required final Map<String, dynamic> notification,
      required final Map<String, dynamic> author,
      required final Map<String, dynamic> user})
      : _notification = notification,
        _author = author,
        _user = user;

  factory _$PushNotiImpl.fromJson(Map<String, dynamic> json) =>
      _$$PushNotiImplFromJson(json);

  final Map<String, dynamic> _notification;
  @override
  Map<String, dynamic> get notification {
    if (_notification is EqualUnmodifiableMapView) return _notification;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_notification);
  }

  final Map<String, dynamic> _author;
  @override
  Map<String, dynamic> get author {
    if (_author is EqualUnmodifiableMapView) return _author;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_author);
  }

  final Map<String, dynamic> _user;
  @override
  Map<String, dynamic> get user {
    if (_user is EqualUnmodifiableMapView) return _user;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_user);
  }

  @override
  String toString() {
    return 'PushNoti(notification: $notification, author: $author, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PushNotiImpl &&
            const DeepCollectionEquality()
                .equals(other._notification, _notification) &&
            const DeepCollectionEquality().equals(other._author, _author) &&
            const DeepCollectionEquality().equals(other._user, _user));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_notification),
      const DeepCollectionEquality().hash(_author),
      const DeepCollectionEquality().hash(_user));

  /// Create a copy of PushNoti
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PushNotiImplCopyWith<_$PushNotiImpl> get copyWith =>
      __$$PushNotiImplCopyWithImpl<_$PushNotiImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PushNotiImplToJson(
      this,
    );
  }
}

abstract class _PushNoti implements PushNoti {
  const factory _PushNoti(
      {required final Map<String, dynamic> notification,
      required final Map<String, dynamic> author,
      required final Map<String, dynamic> user}) = _$PushNotiImpl;

  factory _PushNoti.fromJson(Map<String, dynamic> json) =
      _$PushNotiImpl.fromJson;

  @override
  Map<String, dynamic> get notification;
  @override
  Map<String, dynamic> get author;
  @override
  Map<String, dynamic> get user;

  /// Create a copy of PushNoti
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PushNotiImplCopyWith<_$PushNotiImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
