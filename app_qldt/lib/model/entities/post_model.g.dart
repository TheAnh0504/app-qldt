// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostModelImpl _$$PostModelImplFromJson(Map<String, dynamic> json) =>
    _$PostModelImpl(
      infoPost:
          InfoPostModel.fromJson(json['infoPost'] as Map<String, dynamic>),
      infoComment: (json['infoComment'] as List<dynamic>)
          .map((e) => InfoCommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      countComments: json['countComments'] as List<dynamic>,
      infoAuthor: (json['infoAuthor'] as List<dynamic>)
          .map((e) => InfoAuthorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      tagInfo: (json['tagInfo'] as List<dynamic>)
          .map((e) => InfoAuthorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PostModelImplToJson(_$PostModelImpl instance) =>
    <String, dynamic>{
      'infoPost': instance.infoPost,
      'infoComment': instance.infoComment,
      'countComments': instance.countComments,
      'infoAuthor': instance.infoAuthor,
      'tagInfo': instance.tagInfo,
    };

_$InfoPostModelImpl _$$InfoPostModelImplFromJson(Map<String, dynamic> json) =>
    _$InfoPostModelImpl(
      postId: json['postId'] as String,
      description: json['description'] as String? ?? "",
      author: json['author'] as String,
      tag: json['tag'] as List<dynamic>,
      status: json['status'] as String,
      media: json['media'] as String?,
      report: json['report'] as String?,
      like: (json['like'] as List<dynamic>?)?.map((e) => e as String).toList(),
      comment:
          (json['comment'] as List<dynamic>?)?.map((e) => e as String).toList(),
      lock: json['lock'] as bool,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$$InfoPostModelImplToJson(_$InfoPostModelImpl instance) =>
    <String, dynamic>{
      'postId': instance.postId,
      'description': instance.description,
      'author': instance.author,
      'tag': instance.tag,
      'status': instance.status,
      'media': instance.media,
      'report': instance.report,
      'like': instance.like,
      'comment': instance.comment,
      'lock': instance.lock,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

_$InfoCommentModelImpl _$$InfoCommentModelImplFromJson(
        Map<String, dynamic> json) =>
    _$InfoCommentModelImpl(
      commentId: json['commentId'] as String,
      description: json['description'] as String? ?? "",
      author: json['author'] as String,
      lock: json['lock'] as bool,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$$InfoCommentModelImplToJson(
        _$InfoCommentModelImpl instance) =>
    <String, dynamic>{
      'commentId': instance.commentId,
      'description': instance.description,
      'author': instance.author,
      'lock': instance.lock,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

_$InfoAuthorModelImpl _$$InfoAuthorModelImplFromJson(
        Map<String, dynamic> json) =>
    _$InfoAuthorModelImpl(
      userId: json['userId'] as String,
      avatar: json['avatar'] as String?,
      displayName: json['displayName'] as String,
    );

Map<String, dynamic> _$$InfoAuthorModelImplToJson(
        _$InfoAuthorModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'avatar': instance.avatar,
      'displayName': instance.displayName,
    };
