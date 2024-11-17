// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-model');

PostModel _$PostModelFromJson(Map<String, dynamic> json) {
  return _PostModel.fromJson(json);
}

/// @nodoc
mixin _$PostModel {
  InfoPostModel get infoPost => throw _privateConstructorUsedError;
  List<InfoCommentModel> get infoComment => throw _privateConstructorUsedError;
  List<dynamic> get countComments => throw _privateConstructorUsedError;
  List<InfoAuthorModel> get infoAuthor => throw _privateConstructorUsedError;
  List<InfoAuthorModel> get tagInfo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PostModelCopyWith<PostModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostModelCopyWith<$Res> {
  factory $PostModelCopyWith(PostModel value, $Res Function(PostModel) then) =
      _$PostModelCopyWithImpl<$Res, PostModel>;
  @useResult
  $Res call(
      {InfoPostModel infoPost,
      List<InfoCommentModel> infoComment,
      List<dynamic> countComments,
      List<InfoAuthorModel> infoAuthor,
      List<InfoAuthorModel> tagInfo});

  $InfoPostModelCopyWith<$Res> get infoPost;
}

/// @nodoc
class _$PostModelCopyWithImpl<$Res, $Val extends PostModel>
    implements $PostModelCopyWith<$Res> {
  _$PostModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? infoPost = null,
    Object? infoComment = null,
    Object? countComments = null,
    Object? infoAuthor = null,
    Object? tagInfo = null,
  }) {
    return _then(_value.copyWith(
      infoPost: null == infoPost
          ? _value.infoPost
          : infoPost // ignore: cast_nullable_to_non_nullable
              as InfoPostModel,
      infoComment: null == infoComment
          ? _value.infoComment
          : infoComment // ignore: cast_nullable_to_non_nullable
              as List<InfoCommentModel>,
      countComments: null == countComments
          ? _value.countComments
          : countComments // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      infoAuthor: null == infoAuthor
          ? _value.infoAuthor
          : infoAuthor // ignore: cast_nullable_to_non_nullable
              as List<InfoAuthorModel>,
      tagInfo: null == tagInfo
          ? _value.tagInfo
          : tagInfo // ignore: cast_nullable_to_non_nullable
              as List<InfoAuthorModel>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $InfoPostModelCopyWith<$Res> get infoPost {
    return $InfoPostModelCopyWith<$Res>(_value.infoPost, (value) {
      return _then(_value.copyWith(infoPost: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PostModelImplCopyWith<$Res>
    implements $PostModelCopyWith<$Res> {
  factory _$$PostModelImplCopyWith(
          _$PostModelImpl value, $Res Function(_$PostModelImpl) then) =
      __$$PostModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {InfoPostModel infoPost,
      List<InfoCommentModel> infoComment,
      List<dynamic> countComments,
      List<InfoAuthorModel> infoAuthor,
      List<InfoAuthorModel> tagInfo});

  @override
  $InfoPostModelCopyWith<$Res> get infoPost;
}

/// @nodoc
class __$$PostModelImplCopyWithImpl<$Res>
    extends _$PostModelCopyWithImpl<$Res, _$PostModelImpl>
    implements _$$PostModelImplCopyWith<$Res> {
  __$$PostModelImplCopyWithImpl(
      _$PostModelImpl _value, $Res Function(_$PostModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? infoPost = null,
    Object? infoComment = null,
    Object? countComments = null,
    Object? infoAuthor = null,
    Object? tagInfo = null,
  }) {
    return _then(_$PostModelImpl(
      infoPost: null == infoPost
          ? _value.infoPost
          : infoPost // ignore: cast_nullable_to_non_nullable
              as InfoPostModel,
      infoComment: null == infoComment
          ? _value._infoComment
          : infoComment // ignore: cast_nullable_to_non_nullable
              as List<InfoCommentModel>,
      countComments: null == countComments
          ? _value._countComments
          : countComments // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      infoAuthor: null == infoAuthor
          ? _value._infoAuthor
          : infoAuthor // ignore: cast_nullable_to_non_nullable
              as List<InfoAuthorModel>,
      tagInfo: null == tagInfo
          ? _value._tagInfo
          : tagInfo // ignore: cast_nullable_to_non_nullable
              as List<InfoAuthorModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostModelImpl implements _PostModel {
  const _$PostModelImpl(
      {required this.infoPost,
      required final List<InfoCommentModel> infoComment,
      required final List<dynamic> countComments,
      required final List<InfoAuthorModel> infoAuthor,
      required final List<InfoAuthorModel> tagInfo})
      : _infoComment = infoComment,
        _countComments = countComments,
        _infoAuthor = infoAuthor,
        _tagInfo = tagInfo;

  factory _$PostModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostModelImplFromJson(json);

  @override
  final InfoPostModel infoPost;
  final List<InfoCommentModel> _infoComment;
  @override
  List<InfoCommentModel> get infoComment {
    if (_infoComment is EqualUnmodifiableListView) return _infoComment;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_infoComment);
  }

  final List<dynamic> _countComments;
  @override
  List<dynamic> get countComments {
    if (_countComments is EqualUnmodifiableListView) return _countComments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_countComments);
  }

  final List<InfoAuthorModel> _infoAuthor;
  @override
  List<InfoAuthorModel> get infoAuthor {
    if (_infoAuthor is EqualUnmodifiableListView) return _infoAuthor;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_infoAuthor);
  }

  final List<InfoAuthorModel> _tagInfo;
  @override
  List<InfoAuthorModel> get tagInfo {
    if (_tagInfo is EqualUnmodifiableListView) return _tagInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tagInfo);
  }

  @override
  String toString() {
    return 'PostModel(infoPost: $infoPost, infoComment: $infoComment, countComments: $countComments, infoAuthor: $infoAuthor, tagInfo: $tagInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostModelImpl &&
            (identical(other.infoPost, infoPost) ||
                other.infoPost == infoPost) &&
            const DeepCollectionEquality()
                .equals(other._infoComment, _infoComment) &&
            const DeepCollectionEquality()
                .equals(other._countComments, _countComments) &&
            const DeepCollectionEquality()
                .equals(other._infoAuthor, _infoAuthor) &&
            const DeepCollectionEquality().equals(other._tagInfo, _tagInfo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      infoPost,
      const DeepCollectionEquality().hash(_infoComment),
      const DeepCollectionEquality().hash(_countComments),
      const DeepCollectionEquality().hash(_infoAuthor),
      const DeepCollectionEquality().hash(_tagInfo));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PostModelImplCopyWith<_$PostModelImpl> get copyWith =>
      __$$PostModelImplCopyWithImpl<_$PostModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostModelImplToJson(
      this,
    );
  }
}

abstract class _PostModel implements PostModel {
  const factory _PostModel(
      {required final InfoPostModel infoPost,
      required final List<InfoCommentModel> infoComment,
      required final List<dynamic> countComments,
      required final List<InfoAuthorModel> infoAuthor,
      required final List<InfoAuthorModel> tagInfo}) = _$PostModelImpl;

  factory _PostModel.fromJson(Map<String, dynamic> json) =
      _$PostModelImpl.fromJson;

  @override
  InfoPostModel get infoPost;
  @override
  List<InfoCommentModel> get infoComment;
  @override
  List<dynamic> get countComments;
  @override
  List<InfoAuthorModel> get infoAuthor;
  @override
  List<InfoAuthorModel> get tagInfo;
  @override
  @JsonKey(ignore: true)
  _$$PostModelImplCopyWith<_$PostModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InfoPostModel _$InfoPostModelFromJson(Map<String, dynamic> json) {
  return _InfoPostModel.fromJson(json);
}

/// @nodoc
mixin _$InfoPostModel {
  String get postId => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;
  List<dynamic> get tag => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get media => throw _privateConstructorUsedError;
  String? get report => throw _privateConstructorUsedError;
  List<String>? get like => throw _privateConstructorUsedError;
  List<String>? get comment => throw _privateConstructorUsedError;
  bool get lock => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InfoPostModelCopyWith<InfoPostModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InfoPostModelCopyWith<$Res> {
  factory $InfoPostModelCopyWith(
          InfoPostModel value, $Res Function(InfoPostModel) then) =
      _$InfoPostModelCopyWithImpl<$Res, InfoPostModel>;
  @useResult
  $Res call(
      {String postId,
      String description,
      String author,
      List<dynamic> tag,
      String status,
      String? media,
      String? report,
      List<String>? like,
      List<String>? comment,
      bool lock,
      String createdAt,
      String updatedAt});
}

/// @nodoc
class _$InfoPostModelCopyWithImpl<$Res, $Val extends InfoPostModel>
    implements $InfoPostModelCopyWith<$Res> {
  _$InfoPostModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postId = null,
    Object? description = null,
    Object? author = null,
    Object? tag = null,
    Object? status = null,
    Object? media = freezed,
    Object? report = freezed,
    Object? like = freezed,
    Object? comment = freezed,
    Object? lock = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      tag: null == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      media: freezed == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as String?,
      report: freezed == report
          ? _value.report
          : report // ignore: cast_nullable_to_non_nullable
              as String?,
      like: freezed == like
          ? _value.like
          : like // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      lock: null == lock
          ? _value.lock
          : lock // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$InfoPostModelImplCopyWith<$Res>
    implements $InfoPostModelCopyWith<$Res> {
  factory _$$InfoPostModelImplCopyWith(
          _$InfoPostModelImpl value, $Res Function(_$InfoPostModelImpl) then) =
      __$$InfoPostModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String postId,
      String description,
      String author,
      List<dynamic> tag,
      String status,
      String? media,
      String? report,
      List<String>? like,
      List<String>? comment,
      bool lock,
      String createdAt,
      String updatedAt});
}

/// @nodoc
class __$$InfoPostModelImplCopyWithImpl<$Res>
    extends _$InfoPostModelCopyWithImpl<$Res, _$InfoPostModelImpl>
    implements _$$InfoPostModelImplCopyWith<$Res> {
  __$$InfoPostModelImplCopyWithImpl(
      _$InfoPostModelImpl _value, $Res Function(_$InfoPostModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postId = null,
    Object? description = null,
    Object? author = null,
    Object? tag = null,
    Object? status = null,
    Object? media = freezed,
    Object? report = freezed,
    Object? like = freezed,
    Object? comment = freezed,
    Object? lock = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$InfoPostModelImpl(
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      tag: null == tag
          ? _value._tag
          : tag // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      media: freezed == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as String?,
      report: freezed == report
          ? _value.report
          : report // ignore: cast_nullable_to_non_nullable
              as String?,
      like: freezed == like
          ? _value._like
          : like // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      comment: freezed == comment
          ? _value._comment
          : comment // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      lock: null == lock
          ? _value.lock
          : lock // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _$InfoPostModelImpl implements _InfoPostModel {
  const _$InfoPostModelImpl(
      {required this.postId,
      this.description = "",
      required this.author,
      required final List<dynamic> tag,
      required this.status,
      this.media,
      this.report,
      final List<String>? like,
      final List<String>? comment,
      required this.lock,
      required this.createdAt,
      required this.updatedAt})
      : _tag = tag,
        _like = like,
        _comment = comment;

  factory _$InfoPostModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$InfoPostModelImplFromJson(json);

  @override
  final String postId;
  @override
  @JsonKey()
  final String description;
  @override
  final String author;
  final List<dynamic> _tag;
  @override
  List<dynamic> get tag {
    if (_tag is EqualUnmodifiableListView) return _tag;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tag);
  }

  @override
  final String status;
  @override
  final String? media;
  @override
  final String? report;
  final List<String>? _like;
  @override
  List<String>? get like {
    final value = _like;
    if (value == null) return null;
    if (_like is EqualUnmodifiableListView) return _like;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _comment;
  @override
  List<String>? get comment {
    final value = _comment;
    if (value == null) return null;
    if (_comment is EqualUnmodifiableListView) return _comment;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final bool lock;
  @override
  final String createdAt;
  @override
  final String updatedAt;

  @override
  String toString() {
    return 'InfoPostModel(postId: $postId, description: $description, author: $author, tag: $tag, status: $status, media: $media, report: $report, like: $like, comment: $comment, lock: $lock, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InfoPostModelImpl &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.author, author) || other.author == author) &&
            const DeepCollectionEquality().equals(other._tag, _tag) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.media, media) || other.media == media) &&
            (identical(other.report, report) || other.report == report) &&
            const DeepCollectionEquality().equals(other._like, _like) &&
            const DeepCollectionEquality().equals(other._comment, _comment) &&
            (identical(other.lock, lock) || other.lock == lock) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      postId,
      description,
      author,
      const DeepCollectionEquality().hash(_tag),
      status,
      media,
      report,
      const DeepCollectionEquality().hash(_like),
      const DeepCollectionEquality().hash(_comment),
      lock,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InfoPostModelImplCopyWith<_$InfoPostModelImpl> get copyWith =>
      __$$InfoPostModelImplCopyWithImpl<_$InfoPostModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InfoPostModelImplToJson(
      this,
    );
  }
}

abstract class _InfoPostModel implements InfoPostModel {
  const factory _InfoPostModel(
      {required final String postId,
      final String description,
      required final String author,
      required final List<dynamic> tag,
      required final String status,
      final String? media,
      final String? report,
      final List<String>? like,
      final List<String>? comment,
      required final bool lock,
      required final String createdAt,
      required final String updatedAt}) = _$InfoPostModelImpl;

  factory _InfoPostModel.fromJson(Map<String, dynamic> json) =
      _$InfoPostModelImpl.fromJson;

  @override
  String get postId;
  @override
  String get description;
  @override
  String get author;
  @override
  List<dynamic> get tag;
  @override
  String get status;
  @override
  String? get media;
  @override
  String? get report;
  @override
  List<String>? get like;
  @override
  List<String>? get comment;
  @override
  bool get lock;
  @override
  String get createdAt;
  @override
  String get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$InfoPostModelImplCopyWith<_$InfoPostModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InfoCommentModel _$InfoCommentModelFromJson(Map<String, dynamic> json) {
  return _InfoCommentModel.fromJson(json);
}

/// @nodoc
mixin _$InfoCommentModel {
  String get commentId => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;
  bool get lock => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InfoCommentModelCopyWith<InfoCommentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InfoCommentModelCopyWith<$Res> {
  factory $InfoCommentModelCopyWith(
          InfoCommentModel value, $Res Function(InfoCommentModel) then) =
      _$InfoCommentModelCopyWithImpl<$Res, InfoCommentModel>;
  @useResult
  $Res call(
      {String commentId,
      String description,
      String author,
      bool lock,
      String createdAt,
      String updatedAt});
}

/// @nodoc
class _$InfoCommentModelCopyWithImpl<$Res, $Val extends InfoCommentModel>
    implements $InfoCommentModelCopyWith<$Res> {
  _$InfoCommentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? commentId = null,
    Object? description = null,
    Object? author = null,
    Object? lock = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      commentId: null == commentId
          ? _value.commentId
          : commentId // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      lock: null == lock
          ? _value.lock
          : lock // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$InfoCommentModelImplCopyWith<$Res>
    implements $InfoCommentModelCopyWith<$Res> {
  factory _$$InfoCommentModelImplCopyWith(_$InfoCommentModelImpl value,
          $Res Function(_$InfoCommentModelImpl) then) =
      __$$InfoCommentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String commentId,
      String description,
      String author,
      bool lock,
      String createdAt,
      String updatedAt});
}

/// @nodoc
class __$$InfoCommentModelImplCopyWithImpl<$Res>
    extends _$InfoCommentModelCopyWithImpl<$Res, _$InfoCommentModelImpl>
    implements _$$InfoCommentModelImplCopyWith<$Res> {
  __$$InfoCommentModelImplCopyWithImpl(_$InfoCommentModelImpl _value,
      $Res Function(_$InfoCommentModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? commentId = null,
    Object? description = null,
    Object? author = null,
    Object? lock = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$InfoCommentModelImpl(
      commentId: null == commentId
          ? _value.commentId
          : commentId // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      lock: null == lock
          ? _value.lock
          : lock // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _$InfoCommentModelImpl implements _InfoCommentModel {
  const _$InfoCommentModelImpl(
      {required this.commentId,
      this.description = "",
      required this.author,
      required this.lock,
      required this.createdAt,
      required this.updatedAt});

  factory _$InfoCommentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$InfoCommentModelImplFromJson(json);

  @override
  final String commentId;
  @override
  @JsonKey()
  final String description;
  @override
  final String author;
  @override
  final bool lock;
  @override
  final String createdAt;
  @override
  final String updatedAt;

  @override
  String toString() {
    return 'InfoCommentModel(commentId: $commentId, description: $description, author: $author, lock: $lock, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InfoCommentModelImpl &&
            (identical(other.commentId, commentId) ||
                other.commentId == commentId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.lock, lock) || other.lock == lock) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, commentId, description, author, lock, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InfoCommentModelImplCopyWith<_$InfoCommentModelImpl> get copyWith =>
      __$$InfoCommentModelImplCopyWithImpl<_$InfoCommentModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InfoCommentModelImplToJson(
      this,
    );
  }
}

abstract class _InfoCommentModel implements InfoCommentModel {
  const factory _InfoCommentModel(
      {required final String commentId,
      final String description,
      required final String author,
      required final bool lock,
      required final String createdAt,
      required final String updatedAt}) = _$InfoCommentModelImpl;

  factory _InfoCommentModel.fromJson(Map<String, dynamic> json) =
      _$InfoCommentModelImpl.fromJson;

  @override
  String get commentId;
  @override
  String get description;
  @override
  String get author;
  @override
  bool get lock;
  @override
  String get createdAt;
  @override
  String get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$InfoCommentModelImplCopyWith<_$InfoCommentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InfoAuthorModel _$InfoAuthorModelFromJson(Map<String, dynamic> json) {
  return _InfoAuthorModel.fromJson(json);
}

/// @nodoc
mixin _$InfoAuthorModel {
  String get userId => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InfoAuthorModelCopyWith<InfoAuthorModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InfoAuthorModelCopyWith<$Res> {
  factory $InfoAuthorModelCopyWith(
          InfoAuthorModel value, $Res Function(InfoAuthorModel) then) =
      _$InfoAuthorModelCopyWithImpl<$Res, InfoAuthorModel>;
  @useResult
  $Res call({String userId, String? avatar, String displayName});
}

/// @nodoc
class _$InfoAuthorModelCopyWithImpl<$Res, $Val extends InfoAuthorModel>
    implements $InfoAuthorModelCopyWith<$Res> {
  _$InfoAuthorModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? avatar = freezed,
    Object? displayName = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InfoAuthorModelImplCopyWith<$Res>
    implements $InfoAuthorModelCopyWith<$Res> {
  factory _$$InfoAuthorModelImplCopyWith(_$InfoAuthorModelImpl value,
          $Res Function(_$InfoAuthorModelImpl) then) =
      __$$InfoAuthorModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId, String? avatar, String displayName});
}

/// @nodoc
class __$$InfoAuthorModelImplCopyWithImpl<$Res>
    extends _$InfoAuthorModelCopyWithImpl<$Res, _$InfoAuthorModelImpl>
    implements _$$InfoAuthorModelImplCopyWith<$Res> {
  __$$InfoAuthorModelImplCopyWithImpl(
      _$InfoAuthorModelImpl _value, $Res Function(_$InfoAuthorModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? avatar = freezed,
    Object? displayName = null,
  }) {
    return _then(_$InfoAuthorModelImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$InfoAuthorModelImpl implements _InfoAuthorModel {
  const _$InfoAuthorModelImpl(
      {required this.userId, this.avatar, required this.displayName});

  factory _$InfoAuthorModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$InfoAuthorModelImplFromJson(json);

  @override
  final String userId;
  @override
  final String? avatar;
  @override
  final String displayName;

  @override
  String toString() {
    return 'InfoAuthorModel(userId: $userId, avatar: $avatar, displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InfoAuthorModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userId, avatar, displayName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InfoAuthorModelImplCopyWith<_$InfoAuthorModelImpl> get copyWith =>
      __$$InfoAuthorModelImplCopyWithImpl<_$InfoAuthorModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InfoAuthorModelImplToJson(
      this,
    );
  }
}

abstract class _InfoAuthorModel implements InfoAuthorModel {
  const factory _InfoAuthorModel(
      {required final String userId,
      final String? avatar,
      required final String displayName}) = _$InfoAuthorModelImpl;

  factory _InfoAuthorModel.fromJson(Map<String, dynamic> json) =
      _$InfoAuthorModelImpl.fromJson;

  @override
  String get userId;
  @override
  String? get avatar;
  @override
  String get displayName;
  @override
  @JsonKey(ignore: true)
  _$$InfoAuthorModelImplCopyWith<_$InfoAuthorModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
