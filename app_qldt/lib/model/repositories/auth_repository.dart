import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:app_qldt/model/datastores/sw_shared_preferences.dart";
import "package:app_qldt/model/datastores/swapi.dart";
import "package:app_qldt/model/entities/account_model.dart";
import "package:app_qldt/model/entities/device_model.dart";
import "package:app_qldt/model/entities/security_notification_model.dart";

final authRepositoryProvider = FutureProvider((ref) async {
  return AuthRepository(
      swapi: ref.watch(swapiProvider),
      sharedPreferences: await SharedPreferences.getInstance());
});

class AuthRepository {
  final AuthLocalRepository local;
  final AuthApiRepository api;

  AuthRepository(
      {required SWApi swapi, required SharedPreferences sharedPreferences})
      : local = AuthLocalRepository(sharedPreferences),
        api = AuthApiRepository(swapi);
}

class AuthApiRepository {
  final SWApi api;

  const AuthApiRepository(this.api);

  Future<Map<String, dynamic>> signup(String username, String password) {
    return api.signup(username, password).then((value) {
      if (value["code"] == 1000) return value;
      throw value;
    });
  }

  Future<Map<String, dynamic>> login(String username, String password) {
    return api.login(username, password).then((value) async {
      if (value["code"] == 1000) return value;
      if (value["code"] == 1010) {
        final res = await api.firstLogin(username, password);
        if (res["code"] == 1000) {
          throw {...res, "type": "firstLogin"};
        }
        throw res;
      }
      if (value["code"] == 1014) {
        final res = await api.unlockAccount(username, password);
        if (res["code"] == 1000) {
          throw {...res, "type": "unlockAccount"};
        }
        throw res;
      }
      throw value;
    });
  }

  Future<Map<String, dynamic>> changePassword(
      String oldPassword, String newPassword) {
    return api.changePassword(oldPassword, newPassword).then((value) async {
      if (value["code"] == 1000) return value;
      throw value;
    });
  }

  Future<Map<String, dynamic>> forgetPassword(String oldPassword) {
    return api.forgetPassword(oldPassword).then((value) async {
      if (value["code"] == 1000) return value;
      throw value;
    });
  }

  Future<SecurityNotificationModel?> getListNotify() {
    return api.getListNotify().then((value) async {
      if (value == null || value["data"] == null) return null;
      if (value["code"] == 1000) {
        return SecurityNotificationModel.fromJson(value["data"]);
      }
      throw value;
    });
  }

  Future<Map<String, dynamic>> getVerifyCode(String confirmWhat) {
    return api.getVerifyCode(confirmWhat).then((value) {
      if (value["code"] == 1000) return value;
      throw value;
    });
  }

  Future<Map<String, dynamic>> checkVerifyCode(
      String verifyCode, String confirmWhat) {
    return api.checkVerifyCode(verifyCode, confirmWhat).then((value) {
      if (value["code"] == 1000) return value;
      throw value;
    });
  }

  Future<Map<String, dynamic>> changeInfoAfterSignup(
      {required String firstName,
      required String lastName,
      required String phoneNumber,
      required String address,
      required DateTime dateOfBirth,
      String? avatar,
      required String gender,
      String? email}) {
    return api
        .changeInfoAfterSignup(
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            address: address,
            dateOfBirth: dateOfBirth,
            avatar: avatar,
            gender: gender)
        .then((value) {
      if (value["code"] == 1000) return value;
      throw value;
    });
  }

  Future<Map<String, dynamic>> logout() {
    return api.logout().then((value) {
      if (value["code"] == 1000) return value;
      throw value;
    });
  }

  Future<DeviceModel> getRootDevice() async {
    return api.getRootDevice().then((value) {
      if (value["code"] == 1000) {
        return api
            .getInfoDevice(value["data"])
            .then((value) => DeviceModel.fromJson(value["data"]));
      }
      throw value;
    });
  }

  Future<Map<String, dynamic>> lockAccount() async {
    return api.lockAccount().then((value) {
      if (value["code"] == 1000) return value;
      throw value;
    });
  }

  Future<List<DeviceModel>> getAccessDevices() async {
    final listInfoDevice = await getListInfoDevice();
    return api.getAccessDevice().then((value) {
      if (value["code"] == 1000) {
        return value["data"]
            .map<DeviceModel>((id) =>
                listInfoDevice.firstWhere((device) => device.deviceId == id))
            .toList();
      }
      throw value;
    });
  }

  Future<Map<String, dynamic>> deleteAccessDevice(DeviceModel device) async {
    return api.deleteOneAccessDevice(device.deviceId).then((value) {
      if (value["code"] == 1000) return value;
      throw value;
    });
  }

  Future<Map<String, dynamic>> deleteAccessDevices() async {
    return api.deleteAccessDevice().then((value) {
      if (value["code"] == 1000) return value;
      throw value;
    });
  }

  Future<Map<String, dynamic>> changeRootDevice(DeviceModel device) async {
    return api.changeRootDevice(device.deviceId).then((value) {
      if (value["code"] == 1000) return value;
      throw value;
    });
  }

  Future<List<DeviceModel>> getListInfoDevice() async {
    return api.getListInfoDevice().then((value) {
      if (value["code"] == 1000) {
        return value["data"]
            .map<DeviceModel>((e) => DeviceModel.fromJson(e))
            .toList();
      }
      throw value;
    });
  }
}

class AuthLocalRepository {
  final SharedPreferences pref;

  const AuthLocalRepository(this.pref);

  Future<bool> updateToken(String accessToken, String refreshToken) =>
      Future.wait([
        pref.setAccessToken(accessToken),
        pref.setRefreshToken(refreshToken)
      ]).then((value) => value.reduce((e1, e2) => e1 && e2));

  Future<bool> deleteToken() =>
      Future.wait([pref.setAccessToken(null), pref.setRefreshToken(null)])
          .then((value) => value.reduce((e1, e2) => e1 && e2));

  List<AccountModel> readAllSavedAccounts() =>
      pref.getAccounts().where((e) => e.saved).toList();

  Future<bool> updateCurrentAccount(AccountModel account) =>
      pref.setCurrentAccount(account);

  AccountModel? readCurrentAccount() => pref.getCurrentAccount();

  Future<bool> deleteCurrentAccount() => pref.setCurrentAccount(null);

  Future<bool> updateAccount(AccountModel account) async {
    final currentAccounts = pref.getAccounts();
    final updateIndex = currentAccounts.indexOf(account);
    if (updateIndex == -1) {
      return pref.setAccounts([account, ...currentAccounts]);
    }

    currentAccounts[updateIndex] == account;
    return pref.setAccounts(currentAccounts);
  }

  void deleteAccount(AccountModel account) =>
      pref.setAccounts(pref.getAccounts().where((e) => e != account).toList());
}
