import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_qldt/model/datastores/swapi.dart';
import 'package:app_qldt/model/entities/post_model.dart';

final postRepositoryProvider = Provider(
    (ref) => PostRepository(PostApiRepository(ref.watch(swapiProvider))));

class PostRepository {
  final PostApiRepository api;

  PostRepository(this.api);
}

class PostApiRepository {
  final SWApi swapi;

  PostApiRepository(this.swapi);

  Future<String> addPost(
      {required String description,
      required List<String> media,
      required List<String> tag}) {
    return swapi
        .addPost(
            description: description, tag: tag, status: "public", media: media)
        .then((value) {
      if (value["code"] == 1000) return value["data"];
      throw value;
    });
  }

  Future<PostModel> getPostById(String postId, {int? offset}) {
    return swapi.getPostByPostId(postId, offset: offset ?? 0).then((value) {
      if (value["code"] == 1000) {
        var json = value["data"];
        json["infoPost"] = json["post"];
        json["infoAuthor"] = [json["infoAuthor"]];
        return PostModel.fromJson(json);
      }
      throw value;
    });
  }

  Future<List<PostModel>> getPostByRandom(int offset) {
    return swapi.getPostByRandom(offset).then((value) {
      if (value["code"] == 1000) {
        return (value["data"] as List<dynamic>)
            .map((e) => PostModel.fromJson(e))
            .toList();
      }
      throw value;
    });
  }

  Future<List<PostModel>> getPostByTag(int offset) {
    return swapi.getPostByTag(offset).then((value) {
      if (value["code"] == 1000) {
        return (value["data"] as List<dynamic>)
            .map((e) => PostModel.fromJson(e))
            .toList();
      }
      throw value;
    });
  }

  Future<List<PostModel>> getPostByFollow(int offset) {
    return swapi.getPostByFollow(offset).then((value) {
      if (value["code"] == 1000) {
        return (value["data"] as List<dynamic>)
            .map((e) => PostModel.fromJson(e))
            .toList();
      }
      throw value;
    });
  }

  Future<Map<String, dynamic>> like(
      {required String postId, String? commentId, required bool like}) {
    return swapi
        .like(postId: postId, commentId: commentId, like: like)
        .then((value) {
      if (value["code"] == 1000) return value;
      throw value;
    });
  }

  Future<Map<String, dynamic>> comment(
      {required String postId,
      String? commentId,
      required String description}) {
    return swapi
        .comment(postId: postId, commentId: commentId, description: description)
        .then((value) {
      if (value["code"] == 1000) return value;
      throw value;
    });
  }

  Future<Map<String, dynamic>> deletePost(postId) {
    return swapi.deletePost(postId).then((value) {
      if (value["code"] == 1000) return value;
      throw value;
    });
  }

  Future<Map<String, dynamic>> reportPost(postId) {
    return swapi.reportPost(postId).then((value) {
      if (value["code"] == 1000) return value;
      throw value;
    });
  }
}
