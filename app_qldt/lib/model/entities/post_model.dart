import 'package:freezed_annotation/freezed_annotation.dart';

part "post_model.freezed.dart";
part "post_model.g.dart";

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    required InfoPostModel infoPost,
    required List<InfoCommentModel> infoComment,
    required List<dynamic> countComments,
    required List<InfoAuthorModel> infoAuthor,
    required List<InfoAuthorModel> tagInfo,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}

@freezed
class InfoPostModel with _$InfoPostModel {
  @JsonSerializable(explicitToJson: true)
  const factory InfoPostModel(
      {required String postId,
      @Default("") String description,
      required String author,
      required List<dynamic> tag,
      required String status,
      String? media,
      String? report,
      List<String>? like,
      List<String>? comment,
      required bool lock,
      required String createdAt,
      required String updatedAt}) = _InfoPostModel;

  factory InfoPostModel.fromJson(Map<String, dynamic> json) =>
      _$InfoPostModelFromJson(json);
}

@freezed
class InfoCommentModel with _$InfoCommentModel {
  @JsonSerializable(explicitToJson: true)
  const factory InfoCommentModel(
      {required String commentId,
      @Default("") String description,
      required String author,
      required bool lock,
      required String createdAt,
      required String updatedAt}) = _InfoCommentModel;

  factory InfoCommentModel.fromJson(Map<String, dynamic> json) =>
      _$InfoCommentModelFromJson(json);
}

@freezed
class InfoAuthorModel with _$InfoAuthorModel {
  @JsonSerializable(explicitToJson: true)
  const factory InfoAuthorModel(
      {required String userId,
      String? avatar,
      required String displayName}) = _InfoAuthorModel;

  factory InfoAuthorModel.fromJson(Map<String, dynamic> json) =>
      _$InfoAuthorModelFromJson(json);
}
