import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:app_qldt/model/entities/message_model.dart";
import "package:app_qldt/model/entities/post_model.dart";
import "package:app_qldt/model/repositories/search_repository.dart";

final oldSearchesProvider =
    AsyncNotifierProvider.autoDispose<AsyncOldSearchesProvider, List<String>>(
        AsyncOldSearchesProvider.new);

class AsyncOldSearchesProvider extends AutoDisposeAsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    return (await ref.watch(searchRepositoryProvider.future))
        .local
        .getOldSearches();
  }

  Future<void> insertOldSearch(String search) async {
    final repo = await ref.watch(searchRepositoryProvider.future);
    final searches = [search, ...?state.value];
    repo.local.setOldSearches(
        searches.length > 20 ? searches.sublist(0, 20) : searches);
    state = AsyncData(searches);
  }

  Future<void> deleteOldSearch(String search) async {
    final repo = await ref.watch(searchRepositoryProvider.future);
    final searches = state.value?.where((e) => e != search).toList() ?? [];
    repo.local.setOldSearches(searches);
    state = AsyncData(searches);
  }

  Future<void> deleteOldSearches() async {
    final repo = await ref.watch(searchRepositoryProvider.future);
    repo.local.setOldSearches([]);
    state = const AsyncData([]);
  }
}

final postSearchesProvider = FutureProvider.autoDispose
    .family<List<InfoPostModel>, String>((ref, find) async {
  final repo = await ref.watch(searchRepositoryProvider.future);
  return repo.api.searchPost(find);
});

final userSearchesProvider = FutureProvider.autoDispose
    .family<List<MessageUserModel>, String>((ref, find) async {
  final repo = await ref.watch(searchRepositoryProvider.future);
  return repo.api.searchUser(find);
});
