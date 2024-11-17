import "dart:io";

import "package:device_info_plus/device_info_plus.dart";
import "package:dio/dio.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:app_qldt/core/extension/extension.dart";
import "package:app_qldt/core/log/logger.dart";
import "package:app_qldt/model/datastores/sw_shared_preferences.dart";
import "package:app_qldt/model/entities/account_model.dart";
import "package:app_qldt/controller/account_provider.dart";

final swapiProvider = Provider<SWApi>((ref) => SWApi(ref));

class SWApi {
  final ProviderRef<SWApi> ref;

  SWApi(this.ref) {
    refreshTokenDio = Dio(BaseOptions(
        baseUrl: "https://f8a8-58-186-78-110.ngrok-free.app/",
        validateStatus: (status) => true));
    dio = Dio(BaseOptions(
        baseUrl: "https://f8a8-58-186-78-110.ngrok-free.app/",
        validateStatus: (status) => true))
      ..interceptors.add(QueuedInterceptorsWrapper(onRequest: (req, handler) {
        Logger.httpRequest(req);
        return handler.next(req);
      }, onResponse: (res, handler) async {
        Logger.httpResponse(res);

        if (res.data is String) {
          res.data = {"code": 0, "message": "Lỗi không xác định"};
          return handler.resolve(res);
        }

        if (res.data["code"] == 1009) {
          ref.read(accountProvider.notifier).logout(isSaved: false);
          return handler.next(res);
        }

        if (res.data["code"] == 1007 || res.data["code"] == 1004) {
          if (await accessToken.then((value) => value.toString()) ==
                  res.requestOptions.headers["Authorization"].split(" ")[1] &&
              await refreshToken != null) {
            try {
              var data = await refreshTokenDio.post("/sw3/auth/refresh", data: {
                "refreshToken": await refreshToken
              }).then((value) => value.data);
              await setToken(
                  data["data"]["accessToken"], data["data"]["refreshToken"]);
            } catch (e) {
              ref
                  .read(accountProvider.notifier)
                  .forward(const AsyncValue.data(null));
              return handler.next(res);
            }
          }
          res.requestOptions.headers["Authorization"] =
              "Bearer ${await accessToken}";
          return handler.resolve(await _retry(res.requestOptions));
        }
        return handler.next(res);
      }));
  }

  late final Dio dio;
  late final Dio refreshTokenDio;

  Future<String?> get accessToken async =>
      SharedPreferences.getInstance().then((pref) => pref.getAccessToken());

  Future<String?> get refreshToken async =>
      SharedPreferences.getInstance().then((pref) => pref.getRefreshToken());

  Future<AccountModel?> get currentAccount async =>
      SharedPreferences.getInstance().then((pref) => pref.getCurrentAccount());

  Future<void> setToken(String accessToken, String refreshToken) async {
    final pref = await SharedPreferences.getInstance();
    pref
      ..setAccessToken(accessToken)
      ..setRefreshToken(refreshToken);
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options =
        Options(method: requestOptions.method, headers: requestOptions.headers);
    try {
      return refreshTokenDio.request<dynamic>(requestOptions.path,
          data: requestOptions.data is FormData
              ? FormData.fromMap(
                  Map.fromEntries((requestOptions.data as FormData).files))
              : requestOptions.data,
          queryParameters: requestOptions.queryParameters,
          options: options);
    } on DioException catch (e) {
      return Response(requestOptions: e.requestOptions);
    }
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    final plugin = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var info = await plugin.iosInfo;
      return {
        "uuid": await FirebaseMessaging.instance.getToken(),
        "type": "mobile",
        "model": info.model,
        "version": info.systemVersion,
        "serial": info.identifierForVendor,
        "OS": "iOS",
        "deviceName": info.name
      };
    } else if (Platform.isAndroid) {
      // var info = await plugin.androidInfo;
      // return {
      //   "uuid": await FirebaseMessaging.instance.getToken(),
      //   "type": "mobile",
      //   "model": info.model,
      //   "version": info.version.release,
      //   "serial": info.serialNumber,
      //   "OS": "Android",
      //   "deviceName": info.device
      // };
      return {
        "uuid": await FirebaseMessaging.instance.getToken(),
        "type": "mobile",
        "model": "SM-N770F",
        "version": "12",
        "serial": "ecc09b189cd99c4b",
        "OS": "android",
        "deviceName": "N10"
      };
    } else {
      return {};
    }
  }

  Future<Map<String, dynamic>> signup(String username, String password) async {
    return dio.post<Map<String, dynamic>>("/sw3/auth/signup", data: {
      "username": username,
      "password": password,
      "device_info": await _getDeviceInfo()
    }).then((value) {
      return value.data!;
    });
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    return dio.post("/sw3/auth/login", data: {
      "username": username,
      "password": password,
      "device_info": await _getDeviceInfo()
    }).then((value) {
      return value.data;
    });
  }

  Future<Map<String, dynamic>> getVerifyCode(String confirmWhat) async {
    try {
      if (confirmWhat != "first_login") throw 0;
      final res = await dio.post("/sw3/auth/get_verify_code",
          data: {
            "confirmWhat": confirmWhat,
            "confirmBy": "confirm_by_root_device"
          },
          options: Options(
              headers: {"Authorization": "Bearer ${await accessToken}"}));
      if (res.data["code"] != 1000) {
        throw 0;
      } else {
        return res.data;
      }
    } catch (_) {
      return dio
          .post("/sw3/auth/get_verify_code",
              data: {
                "confirmWhat": confirmWhat,
                "confirmBy": "confirm_by_mail"
              },
              options: Options(
                  headers: {"Authorization": "Bearer ${await accessToken}"}))
          .then((value) => value.data);
    }
  }

  /// [confirmWhat] : "unlock_acc" || "add_user"
  Future<Map<String, dynamic>> checkVerifyCode(
      String code, String confirmWhat) async {
    return dio
        .post("/sw3/auth/check_verify_code",
            data: {
              "codeVerify": code,
              "confirmWhat": confirmWhat,
              "confirmBy": "confirm_by_mail"
            },
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> logout() async {
    return dio
        .post("/sw3/auth/logout",
            data: {"refreshToken": await refreshToken},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> refresh() async {
    return dio.post("/sw3/auth/refresh",
        data: {"refreshToken": await refreshToken}).then((value) => value.data);
  }

  Future<Map<String, dynamic>> changeInfoAfterSignup(
      {required String firstName,
      required String lastName,
      required String phoneNumber,
      required String address,
      required DateTime dateOfBirth,
      required String gender,
      required String? avatar,
      String? email}) async {
    return dio
        .post("/sw3/auth/change_info_after_signup",
            data: {
              "firstName": firstName,
              "lastName": lastName,
              "displayName": "$firstName $lastName",
              "email": email,
              "phoneNumber": phoneNumber,
              "address": address,
              "dateOfBirth": dateOfBirth.toIso8601String(),
              "gender": gender,
              "subject": "subject",
              "avatar": avatar,
              "school": const <String>[]
            },
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data!);
  }

  Future<Map<String, dynamic>> changePassword(
      String oldPassword, String newPassword) async {
    return dio
        .post("/sw3/auth/change_password",
            data: {"oldPassword": oldPassword, "newPassword": newPassword},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> forgetPassword(String username) async {
    return dio.post("/sw3/auth/forget_password",
        data: {"username": username}).then((value) => value.data);
  }

  Future<Map<String, dynamic>> lockAccount() async {
    return dio
        .get("/sw3/auth/lock_account",
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> unlockAccount(
      String username, String password) async {
    return dio.post<Map<String, dynamic>>("/sw3/auth/unlock_account", data: {
      "username": username,
      "password": password,
      "device_info": await _getDeviceInfo()
    }).then((value) {
      return value.data!;
    });
  }

  Future<Map<String, dynamic>> firstLogin(
      String username, String password) async {
    return dio.post<Map<String, dynamic>>("/sw3/auth/first_login", data: {
      "username": username,
      "password": password,
      "device_info": await _getDeviceInfo()
    }).then((value) {
      return value.data!;
    });
  }

  Future<Map<String, dynamic>> getAccessDevice() async {
    return dio
        .get("/sw3/auth/get_access_device",
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> getRootDevice() async {
    return dio
        .get("/sw3/auth/get_root_device",
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> getInfoDevice(String deviceId) async {
    return dio
        .post("/sw3/auth/get_info_device",
            data: {"deviceId": deviceId},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> getListInfoDevice() async {
    return dio
        .get("/sw3/auth/get_list_info_device",
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> changeRootDevice(String newRootDeviceId) async {
    return dio
        .post("/sw3/auth/change_root_device",
            data: {"newRootDeviceId": newRootDeviceId},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>?> getListNotify() async {
    return dio
        .get<Map<String, dynamic>?>("/sw3/auth/get_list_notify",
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> deleteAccessDevice() async {
    return dio
        .get("/sw3/auth/delete_access_device",
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> deleteOneAccessDevice(String deviceId) async {
    return dio
        .post("/sw3/auth/delete_one_access_device",
            data: {"deviceId": deviceId},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> deleteToken() async {
    return dio
        .get("/sw3/auth/delete_token",
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> getUserInfo() async {
    return dio
        .get("/sw3/user/get_user_info",
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> setUserInfo(
      {required String firstName,
      required String lastName,
      required String phoneNumber,
      required String address,
      required DateTime dateOfBirth,
      required String gender,
      required String? avatar,
      required List<String> school,
      String? email}) async {
    return dio
        .post("/sw3/user/set_user_info",
            data: {
              "firstName": firstName,
              "lastName": lastName,
              "displayName": "$firstName $lastName",
              "email": email,
              "phoneNumber": phoneNumber,
              "address": address,
              "dateOfBirth": dateOfBirth.toIso8601String(),
              "gender": gender,
              "subject": "subject",
              "avatar": avatar,
              "school": school
            },
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> getSchoolInfo() async {
    return dio
        .get("/sw3/user/get_school_info",
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> searchSchool(String find) async {
    return dio
        .get("/sw3/school/search?find=$find",
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> addBlock(String userId) async {
    return dio
        .post("/sw3/user/add_block",
            data: {"userId": userId},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> deleteBlock(String userId) async {
    return dio
        .post("/sw3/user/delete_block",
            data: {"userId": userId},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> getListFollowing() async {
    return dio
        .get("/sw3/user/get_list_following",
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> following(String userId) async {
    return dio
        .post("/sw3/user/following",
            data: {"userId": userId},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> unFollowing(String userId) async {
    return dio
        .post("/sw3/user/un_following",
            data: {"userId": userId},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> getListFollower() async {
    return dio
        .get("/sw3/user/get_list_follower",
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> getFollowInfo(String userId) async {
    return dio
        .post("/sw3/user/get_follow_info",
            data: {"userId": userId},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> searchUser(String find) async {
    return dio
        .get("/sw3/user/search_user",
            queryParameters: {"find": find},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> getListStudent(String teacherId) async {
    return dio
        .post("/sw3/user/get_students",
            data: {"teacherId": teacherId, "limit": 100, "offset": 0},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> getNotifyByStudentId(String studentId) async {
    return dio
        .post("/sw1/get_notify_by_student_id",
            data: {"studentId": studentId, "limit": 100, "offset": 0},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> getListTeacher(String find) async {
    return dio
        .get("/sw3/user/get_list_follower",
            data: {"find": find},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> addImage(File file) async {
    return dio
        .post("/sw3/post/add_image",
            data: FormData.fromMap(
                {"image": await MultipartFile.fromFile(file.path)}),
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> addImages(List<File> files) async {
    List<MultipartFile> images = [];
    for (var f in files) {
      images.add(await MultipartFile.fromFile(f.path));
    }
    return dio
        .post("/sw3/post/add_images",
            data: FormData.fromMap({"images": images}),
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> getListNotification(int offset) async {
    return dio
        .post("/sw3/user/get_list_notification",
            data: {"limit": 15, "offset": offset},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> setReadNotification(
      String notificationId) async {
    return dio
        .post("/sw3/user/set_read_notification",
            data: {"notificationId": notificationId},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> setPushSetting(
      {required bool ledOn,
      required bool vibrantOn,
      required bool notificationOn,
      required bool soundOn}) async {
    return dio
        .post("/sw3/user/set_push_setting",
            data: {
              "ledOn": ledOn,
              "vibrantOn": vibrantOn,
              "notificationOn": notificationOn,
              "soundOn": soundOn
            },
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> getPushSetting() async {
    return dio
        .get("/sw3/user/get_push_setting",
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> addPost(
      {required String description,
      List<String>? tag,
      required String status,
      List<String>? media}) async {
    return dio
        .post("/sw3/post/add_post",
            data: {
              "description": description,
              "tag": tag,
              "status": status,
              "media": media == null
                  ? null
                  : Map<String, String>.fromEntries(media.mapIndexed(
                      (i, e) => MapEntry<String, String>(i.toString(), e)))
            },
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> setPost(
      {required String postId,
      required String description,
      List<String>? tag,
      required String status,
      List<String>? media}) async {
    return dio
        .post("/sw3/post/set_post",
            data: {
              "postId": postId,
              "description": description,
              "tag": tag,
              "status": status,
              "media": media == null
                  ? null
                  : Map<String, String>.fromEntries(media.mapIndexed(
                      (i, e) => MapEntry<String, String>(i.toString(), e)))
            },
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> deletePost(String postId) async {
    return dio
        .post("/sw3/post/delete_post",
            data: {"postId": postId},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> getPostByPostId(String postId,
      {int offset = 0}) async {
    return dio
        .get("/sw3/post/$postId",
            queryParameters: {"offset": offset, "limit": 10},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> getPostByTag(int offset) async {
    return dio
        .post("/sw3/post/by_tag",
            data: {"limit": 10, "offset": offset},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> getPostByFollow(int offset) async {
    return dio
        .post("/sw3/post/by_follow",
            data: {"limit": 10, "offset": offset},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> getPostByRandom(int offset) async {
    return dio
        .post("/sw3/post/by_random",
            data: {"limit": 10, "offset": offset},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> getCommentInComment(
      {required String commentId, int offset = 0}) async {
    return dio
        .post("/sw3/post/get_comment",
            queryParameters: {
              "commentId": commentId,
              "limit": 10,
              "offset": offset
            },
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> searchPost(String find) async {
    return dio
        .get("/sw3/post/search",
            queryParameters: {"find": find},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> reportPost(String postId) async {
    return dio
        .post("/sw3/post/report_post",
            data: {
              "postId": postId,
            },
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> reportComment(String commentId) async {
    return dio
        .post("/sw3/post/report_comment",
            data: {
              "commentId": commentId,
            },
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> like(
      {required String postId, String? commentId, required bool like}) async {
    return dio
        .post("/sw3/post/like",
            data: {"postId": postId, "commentId": commentId, "like": like},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> comment(
      {required String postId,
      String? commentId,
      required String description,
      List<String>? tag,
      List<String>? media}) async {
    return dio
        .post("/sw3/post/comment",
            data: {
              "postId": postId,
              "commentId": commentId,
              "tag": tag,
              "description": description,
              "media": media == null
                  ? null
                  : Map<String, String>.fromEntries(media.mapIndexed(
                      (i, e) => MapEntry<String, String>(i.toString(), e)))
            },
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> setComment(
      {String? commentId,
      required bool description,
      List<String>? tag,
      List<String>? media}) async {
    return dio
        .post("/sw3/post/set_comment",
            data: {
              "commentId": commentId,
              "tag": tag,
              "description": description,
              "media": media == null
                  ? null
                  : Map<String, String>.fromEntries(media.mapIndexed(
                      (i, e) => MapEntry<String, String>(i.toString(), e)))
            },
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> deleteComment(String commentId) async {
    return dio
        .post("/sw3/post/delete_comment",
            data: {
              "commentId": commentId,
            },
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> getMessage(
      {required String groupId, int offset = 0}) async {
    return dio
        .post("/sw3/message/get_message",
            data: {"groupId": groupId, "limit": 20, "offset": offset},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> addMessage(String groupId,
      {String? message, String? media}) async {
    return dio
        .post("/sw3/message/add_message",
            data: {"groupId": groupId, "message": message, "media": media},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> addNewGroupChat(
      {String? groupName,
      required List<String> listUserId,
      List<String> listAdmin = const [],
      required String type}) async {
    return dio
        .post("/sw3/message/add_group",
            data: {
              "groupName": groupName,
              "listUserId": listUserId,
              "listAdmin": listAdmin,
              "type": type
            },
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> getListGroup({int offset = 0}) async {
    return dio
        .post("/sw3/message/get_list_group",
            data: {"limit": 10, "offset": offset},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> addPublicKey(String publicKey) async {
    return dio
        .post("/sw3/auth/add_public_key",
            data: {"publickey": publicKey},
            options: Options(
                headers: {"Authorization": "Bearer ${await accessToken}"}))
        .then((value) => value.data);
  }
}
