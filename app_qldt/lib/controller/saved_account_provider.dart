import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:app_qldt/model/entities/account_model.dart";
import "package:app_qldt/model/repositories/auth_repository.dart";

final savedAccountProvider = AsyncNotifierProvider.autoDispose<
    AsyncSavedAccountProvider,
    List<AccountModel>>(AsyncSavedAccountProvider.new);

class AsyncSavedAccountProvider
    extends AutoDisposeAsyncNotifier<List<AccountModel>> {
  @override
  Future<List<AccountModel>> build() async {
    return (await ref.watch(authRepositoryProvider.future))
        .local
        .readAllSavedAccounts();
  }

  Future<void> deleteSavedAccount(AccountModel account) async {
    final repo = (await ref.read(authRepositoryProvider.future));
    repo.local.deleteAccount(account);
    state = AsyncData((state.value ?? [])
        .where((e) => e.email != account.email)
        .toList());
  }
}
