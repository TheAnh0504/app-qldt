import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:app_qldt/model/datastores/sw_shared_preferences.dart";
import "package:app_qldt/model/datastores/swapi.dart";
import "package:app_qldt/model/entities/message_model.dart";
import "package:app_qldt/model/entities/post_model.dart";

final searchRepositoryProvider = FutureProvider((ref) async => SearchRepository(
    api: SearchRepositoryApi(ref.read(swapiProvider)),
    local: SearchRepositoryLocal(await SharedPreferences.getInstance())));

class SearchRepository {
  final SearchRepositoryApi api;
  final SearchRepositoryLocal local;

  SearchRepository({required this.api, required this.local});
}

class SearchRepositoryApi {
  final SWApi swapi;

  SearchRepositoryApi(this.swapi);

  Future<List<MessageUserModel>> searchUser(String find) {
    return swapi.searchUser(find).then((value) {
      if (value["code"] == 1000) {
        return (value["data"] as List<dynamic>)
            .map((e) => MessageUserModel.fromJson(e))
            .toList();
      }
      throw value;
    });
  }

  Future<List<InfoPostModel>> searchPost(String find) {
    return swapi.searchPost(find).then((value) {
      if (value["code"] == 1000) {
        return (value["data"] as List<dynamic>)
            .map((e) => InfoPostModel.fromJson(e))
            .toList();
      }
      throw value;
    });
  }
}

class SearchRepositoryLocal {
  final SharedPreferences pref;

  const SearchRepositoryLocal(this.pref);

  List<String> getOldSearches() => pref.getOldSearches();

  Future<bool> setOldSearches(List<String> value) => pref.setOldSearches(value);
}
