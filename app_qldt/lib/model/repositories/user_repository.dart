import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_qldt/model/datastores/swapi.dart';
import 'package:app_qldt/model/entities/post_model.dart';
import 'package:app_qldt/model/entities/push_notification_settings_model.dart';
import 'package:app_qldt/model/entities/user_model.dart';

final userRepositoryProvider = Provider(
    (ref) => UserRepository(UserApiRepository(ref.watch(swapiProvider))));

class UserRepository {
  final UserApiRepository api;
  final UserLocalRepository local;

  UserRepository(this.api) : local = UserLocalRepository();
}

class UserApiRepository {
  final SWApi swapi;

  UserApiRepository(this.swapi);

  Future<PushNotificationSettingsModel> getPushSetting() {
    return swapi.getPushSetting().then((value) {
      if (value["code"] == 1000) {
        return PushNotificationSettingsModel.fromJson(value["data"]);
      }
      throw value;
    });
  }

  Future<Map<String, dynamic>> setPushSetting(
      {required bool ledOn,
      required bool vibrantOn,
      required bool notificationOn,
      required bool soundOn}) {
    return swapi
        .setPushSetting(
            ledOn: ledOn,
            vibrantOn: vibrantOn,
            notificationOn: notificationOn,
            soundOn: soundOn)
        .then((value) {
      if (value["code"] == 1000) return value;

      throw value;
    });
  }

  Future<List<InfoAuthorModel>> getListFollowing() {
    return swapi.getListFollowing().then((value) {
      if (value["code"] == 1000) {
        return (value["data"] as List<dynamic>)
            .map((e) => InfoAuthorModel.fromJson(e))
            .toList();
      }
      throw value;
    });
  }

  Future<List<InfoAuthorModel>> getListFollower() {
    return swapi.getListFollower().then((value) {
      if (value["code"] == 1000) {
        return (value["data"] as List<dynamic>)
            .map((e) => InfoAuthorModel.fromJson(e))
            .toList();
      }
      throw value;
    });
  }

  Future<UserModel> getUserInfo(String userId) {
    return swapi.getUserInfo(userId).then((value) {
      if (value["code"] == 1000) return UserModel.fromJson(value["data"]);
      throw value;
    });
  }

  Future<void> following(String userId) {
    return swapi.following(userId).then((value) {
      if (value["code"] == 1000) return;
      throw value;
    });
  }

  Future<void> unFollowing(String userId) {
    return swapi.unFollowing(userId).then((value) {
      if (value["code"] == 1000) return;
      throw value;
    });
  }

  Future<(List<String> check, UserModel userInfo)> getOtherUserInfo(
      String userId) {
    return swapi.getFollowInfo(userId).then((value) {
      if (value["code"] == 1000) {
        return (
          (value["data"]["check"] as List<dynamic>)
              .map((e) => e.toString())
              .toList(),
          UserModel.fromJson(value["data"]["userInfo"])
        );
      }
      throw value;
    });
  }

  Future<Map<String, dynamic>> setUserInfo(
      {required String firstName,
      required String lastName,
      required String phoneNumber,
      required String address,
      required DateTime dateOfBirth,
      required String gender,
      required List<String> school,
      String? avatar,
      String? email}) {
    return swapi
        .setUserInfo(
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            address: address,
            dateOfBirth: dateOfBirth,
            gender: gender,
            avatar: avatar,
            school: school,
            email: email == "" ? null : email)
        .then((value) {
      if (value["code"] == 1000) return value;
      throw value;
    });
  }
}

class UserLocalRepository {}
