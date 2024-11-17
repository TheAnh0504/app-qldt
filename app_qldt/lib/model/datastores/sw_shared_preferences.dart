import "dart:convert";

import "package:shared_preferences/shared_preferences.dart";
import "package:app_qldt/model/entities/account_model.dart";

const spCurrentAccount = "currentAccount";
const spAccessToken = "accessToken";
const spRefreshToken = "refreshToken";
const spAccounts = "accounts";
const spTheme = "theme";
const spOldSearches = "oldSearches";

extension SWSPExtension on SharedPreferences {
  AccountModel? getCurrentAccount() {
    var value = getString(spCurrentAccount);
    return value == null ? null : AccountModel.fromJson(jsonDecode(value));
  }

  Future<bool> setCurrentAccount(AccountModel? value) => value == null
      ? remove(spCurrentAccount)
      : setString(spCurrentAccount, jsonEncode(value.toJson()));

  String? getAccessToken() => getString(spAccessToken);

  Future<bool> setAccessToken(String? value) =>
      value == null ? remove(spAccessToken) : setString(spAccessToken, value);

  String? getRefreshToken() => getString(spRefreshToken);

  Future<bool> setRefreshToken(String? value) =>
      value == null ? remove(spRefreshToken) : setString(spRefreshToken, value);

  List<AccountModel> getAccounts() {
    var value = getString(spAccounts);
    return value == null
        ? <AccountModel>[]
        : jsonDecode(value)
            .map<AccountModel>((e) => AccountModel.fromJson(e))
            .toList();
  }

  Future<bool> setAccounts(List<AccountModel> value) =>
      setString(spAccounts, jsonEncode(value.map((e) => e.toJson()).toList()));

  List<String> getOldSearches() {
    var value = getString(spOldSearches);
    return value == null
        ? <String>[]
        : jsonDecode(value).cast<String>().toList();
  }

  Future<bool> setOldSearches(List<String> value) =>
      setString(spOldSearches, jsonEncode(value));
}
