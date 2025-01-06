import "dart:io";

import "package:connectivity_plus/connectivity_plus.dart";
import "package:device_info_plus/device_info_plus.dart";
import "package:dio/dio.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:app_qldt/core/extension/extension.dart";
import "package:app_qldt/core/log/logger.dart";
import "package:app_qldt/model/datastores/sw_shared_preferences.dart";
import "package:app_qldt/model/entities/account_model.dart";
import "package:app_qldt/controller/account_provider.dart";

import "../repositories/auth_repository.dart";

final swapiProvider = Provider<SWApi>((ref) => SWApi(ref));

class SWApi {
  final ProviderRef<SWApi> ref;

  SWApi(this.ref) {
    refreshTokenDio = Dio(BaseOptions(
        baseUrl: "http://157.66.24.126:8080",
        validateStatus: (status) => true));
    dio = Dio(BaseOptions(
        baseUrl: "http://157.66.24.126:8080",
        validateStatus: (status) => true))
      ..interceptors.add(QueuedInterceptorsWrapper(onRequest: (req, handler) {
        Logger.httpRequest(req);
        return handler.next(req);
      }, onResponse: (res, handler) async {
        Logger.httpResponse(res);

        // bắt error access-token expired
        try {
          if (res.data["meta"]["code"].toString() == "9998") {
            print("check 345");
            ref.read(checkExpiredToken.notifier).forward(const AsyncValue.data(null));
            var repo = (await ref.read(authRepositoryProvider.future));
            await repo.local.deleteCheckTokenExpired();
            return handler.next(res);
          }
        } catch(_) {
          print("try-catch");
        }
        print("check 456");
        ref.read(checkExpiredToken.notifier).forward(const AsyncValue.data(true));
        return handler.next(res);
      }, onError: (DioError err, handler) async {
          final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
          if (connectivityResult.contains(ConnectivityResult.none)) {
            print('12345345435');
            Fluttertoast.showToast(msg: "Mạng không khả dụng, vui lòng thử lại sau");
          } else {
            Fluttertoast.showToast(msg: "Không lấy được dữ liệu từ server");
          }
          return handler.next(err); // Tiếp tục xử lý lỗi
        },));
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

  Future<Map<String, dynamic>> signup(String ho, String ten, String email, String password, String role) async {
    return dio.post<Map<String, dynamic>>("/it4788/signup", data: {
      "ho": ho,
      "ten": ten,
      "email": email,
      "password": password,
      "uuid": await FirebaseMessaging.instance.getToken(),
      "fcm_token": await FirebaseMessaging.instance.getToken(),
      "role": role
    }).then((value) {
      return value.data!;
    });
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    return dio.post("/it4788/login", data: {
      "email": email,
      "password": password,
      "device_id": await FirebaseMessaging.instance.getToken(),
      "fcm_token": await FirebaseMessaging.instance.getToken()
    }).then((value) {
      return value.data;
    });
  }

  Future<Map<String, dynamic>> getUserInfo1(String userId) async {
    return dio.post("/it4788/get_user_info", data: {
      "token": await accessToken,
      "user_id": userId,
    }).then((value) {
      return value.data;
    });
  }

  Future<Map<String, dynamic>> getUserInfo(String userId) async {
    return dio.post("/it4788/get_user_info", data: {
      "token": await accessToken,
      "user_id": userId,
    }).then((value) {
      return value.data;
    });
  }

  Future<Map<String, dynamic>> deleteMessage(dynamic messageId, dynamic conversationId) async {
    return dio.post("/it5023e/delete_message", data: {
      "token": await accessToken,
      "message_id": messageId,
      "conversation_id": conversationId
    }).then((value) {
      return value.data;
    });
  }

  Future<Map<String, dynamic>> getVerifyCode(String email, String password) async {
      final res = await dio.post("/it4788/get_verify_code",
          data: {
            "email": email,
            "password": password
          });
      if (res.data["code"] != "1000") {
        throw 0;
      } else {
        return res.data;
      }
  }

  Future<Map<String, dynamic>> checkVerifyCode(
      String code, String email) async {
    return dio
        .post("/it4788/check_verify_code",
            data: {
              "email": email,
              "verify_code": code
            })
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> logout() async {
    return dio
        .post("/it4788/logout",
            data: {"token": await accessToken})
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
        .post("/it4788/change_password",
            data: {"old_password": oldPassword, "new_password": newPassword, "token": await accessToken},
            )
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
      // "device_info": await _getDeviceInfo()
    }).then((value) {
      return value.data!;
    });
  }

  Future<Map<String, dynamic>> firstLogin(
      String username, String password) async {
    return dio.post<Map<String, dynamic>>("/sw3/auth/first_login", data: {
      "username": username,
      "password": password,
      // "device_info": await _getDeviceInfo()
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
        .post("/it4788/change_info_after_signup",
            data: FormData.fromMap(
                {"file": await MultipartFile.fromFile(file.path),
                "token": await accessToken}))
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

  Future<Map<String, dynamic>> getListNotification(int count) async {
    return dio
        .post("/it5023e/get_notifications",
            data: {"index": 20 * count, "count": 20, "token": await accessToken}
        ).then((value) => value.data);
  }

  Future<Map<String, dynamic>> getCountNotification() async {
    return dio
        .post("/it5023e/get_unread_notification_count",
        data: {"token": await accessToken}
    ).then((value) => value.data);
  }

  Future<Map<String, dynamic>> readCountNotification(int id) async {
    return dio
        .post("/it5023e/mark_notification_as_read",
        data: {"token": await accessToken, "notification_id": id}
    ).then((value) => value.data);
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

  Future<Map<String, dynamic>> getMessage(int groupId, int count, String read) async {
    print('count:1 $count');
    return dio
        .post("/it5023e/get_conversation",
            data: {
              "token": await accessToken,
              "index": 20 * count,
              "count": 20,
              "conversation_id": groupId,
              "mark_as_read": read
            })
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

  Future<Map<String, dynamic>> addNewGroupChat(String? search) async {
    return dio
        .post("/it5023e/search_account",
            data: {
              "search": search
              // "pageable_request": {
              //   "page": 1,
              //   "page_size": 2
              // }
            })
        .then((value) => value.data);
  }

  Future<Map<String, dynamic>> getListGroup(int count) async {
    return dio
        .post("/it5023e/get_list_conversation",
            data: {"token": await accessToken, "index": 10 * count, "count": 10})
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

  Future<Map<String, dynamic>> getListClassInfo() async {
    return dio.post("/it5023e/get_open_classes",
      data: {
          "token": await accessToken,
          "pageable_request": {
            "page": "0",
            "page_size": "2000"
          }
      },
    ).then((value) => value.data);
  }

  Future<Map<String, dynamic>> getClassInfo(String classId) async {
    return dio.post("/it5023e/get_class_info",
      data: {
        "token": await accessToken,
        "class_id": classId
      },
    ).then((value) => value.data);
  }

  Future<Map<String, dynamic>> getClassBasicInfo(String classId) async {
    return dio.post("/it5023e/get_basic_class_info",
      data: {
        "token": await accessToken,
        "class_id": classId
      },
    ).then((value) => value.data);
  }

  Future<Map<String, dynamic>> getRegisterClassNow() async {
    return dio.post("/it5023e/get_class_list",
      data: {
        "token": await accessToken,
        "pageable_request": {
          "page": "0",
          "page_size": "2000"
        }
      },
    ).then((value) => value.data);
  }

  Future<Map<String, dynamic>> getListClassInfoBy(String? classId, String? className, String? status, String? classType) async {
    if (classId == "") classId = null;
    if (className == "") className = null;
    if (status == "") status = null;
    if (classType == "") classType = null;
    return dio.post("/it5023e/get_classes_by_filter",
      data: {
        "token": await accessToken,
        "status": status,
        "class_name": className,
        "class_type": classType,
        "pageable_request": {
          "page": "0",
          "page_size": "2000"
        }
      },
    ).then((value) => value.data);
  }

  Future<Map<String, dynamic>> registerClass(List<String> classId) async {
    return dio.post("/it5023e/register_class",
      data: {
        "token": await accessToken,
        "class_ids": classId
      },
    ).then((value) => value.data);
  }

  Future<Map<String, dynamic>> addStudent(String classId, String accountId) async {
    return dio.post("/it5023e/add_student",
      data: {
        "token": await accessToken,
        "class_id": classId,
        "account_id": accountId
      },
    ).then((value) => value.data);
  }

  Future<Map<String, dynamic>> deleteClass(String classId) async {
    return dio.post("/it5023e/delete_class",
      data: {
        "token": await accessToken,
        "class_id": classId,
      },
    ).then((value) => value.data);
  }

  Future<Map<String, dynamic>> addClass(String classId, String className, String classType, String startDate, String endDate, String maxStudentAmount) async {
    return dio.post("/it5023e/create_class",
      data: {
        "token": await accessToken,
        "class_id": classId,
        "class_name": className,
        "class_type": classType,
        "start_date": startDate,
        "end_date": endDate,
        "max_student_amount": int.parse(maxStudentAmount)
      },
    ).then((value) => value.data);
  }

  Future<Map<String, dynamic>> updateClass(String classId, String className, String classType, String startDate, String endDate, String maxStudentAmount, String status) async {
    return dio.post("/it5023e/edit_class",
      data: {
        "token": await accessToken,
        "class_id": classId,
        "class_name": className,
        "class_type": classType,
        "start_date": startDate,
        "end_date": endDate,
        "max_student_amount": int.parse(maxStudentAmount),
        "status": status
      },
    ).then((value) => value.data);
  }

  Future<Map<String, dynamic>> requestAbsence(String classId, String date, String reason, File? file, String title) async {
    return dio.post("/it5023e/request_absence",
      data: file != null
          ? FormData.fromMap(
            {
              "file": await MultipartFile.fromFile(file!.path),
              "token": await accessToken,
              "classId": classId,
              "date": date,
              "reason": reason,
              "title": title
            }
          ) : FormData.fromMap(
          {
            "token": await accessToken,
            "classId": classId,
            "date": date,
            "reason": reason,
            "title": title
          }),
    ).then((value) => value.data);
  }

  Future<Map<String, dynamic>> sendNotify(String message, String toUser, String type) async {
    return dio
        .post("/it5023e/send_notification",
        data: FormData.fromMap({
          "token": await accessToken,
          "message": message,
          "toUser": toUser,
          "type": type
        })
    ).then((value) => value.data);
  }

  Future<Map<String, dynamic>> getAbsenceRequestStudent(String? classId, String? status, String? date) async {
    if (classId == '') classId = null;
    if (status == '') status = null;
    if (date == '') date = null;
    return dio.post("/it5023e/get_student_absence_requests",
      data: {
        "token": await accessToken,
        "class_id": classId,
        "status": status,
        "date": date,
        "pageable_request": {
          "page": "0",
          "page_size": "2000"
        }
      },
    ).then((value) => value.data);
  }

  Future<Map<String, dynamic>> getAbsenceRequestLecture(String? classId, String? status, String? date) async {
    if (status == '') status = null;
    if (date == '') date = null;
    return dio.post("/it5023e/get_absence_requests",
      data: {
        "token": await accessToken,
        "class_id": classId,
        "status": status,
        "date": date,
        "pageable_request": {
          "page": "0",
          "page_size": "2000"
        }
      },
    ).then((value) => value.data);
  }

  Future<Map<String, dynamic>> reviewAbsenceRequest(String requestId, String status) async {
    return dio.post("/it5023e/review_absence_request",
      data: {
        "token": await accessToken,
        "request_id": requestId,
        "status": status
      },
    ).then((value) => value.data);
  }

  Future<Map<String, dynamic>> uploadMaterial(File file, String classId, String title, String description, String materialType) async {
    return dio.post("/it5023e/upload_material",
      data: FormData.fromMap(
          {
            "file": await MultipartFile.fromFile(file.path),
            "token": await accessToken,
            "classId": classId,
            "title": title,
            "description": description,
            "materialType": materialType
          }),
    ).then((value) => value.data);
  }

  Future<Map<String, dynamic>> editMaterial(File file, String materialId, String title, String description, String materialType) async {
    return dio.post("/it5023e/edit_material",
      data: FormData.fromMap(
          {
            "file": await MultipartFile.fromFile(file.path),
            "token": await accessToken,
            "materialId": materialId,
            "title": title,
            "description": description,
            "materialType": materialType
          }),
    ).then((value) => value.data);
  }

  Future<Map<String, dynamic>> deleteMaterial(String material_id) async {
    return dio.post("/it5023e/delete_material",
      data: {
            "token": await accessToken,
            "material_id": material_id,
      },
    ).then((value) => value.data);
  }

  Future<Map<String, dynamic>> getInfoMaterial(String material_id) async {
    return dio.post("/it5023e/get_material_info",
      data: {
        "token": await accessToken,
        "material_id": material_id,
      },
    ).then((value) => value.data);
  }

  Future<Map<String, dynamic>> getListMaterial(String class_id) async {
    return dio.post("/it5023e/get_material_list",
      data: {
        "token": await accessToken,
        "class_id": class_id,
      },
    ).then((value) => value.data);
  }

  Future<Map<String, dynamic>> getListDateAttendance(String class_id) async {
    return dio.post("/it5023e/get_attendance_dates",
      data: {
        "token": await accessToken,
        "class_id": class_id,
      },
    ).then((value) => value.data);
  }

  Future<Map<String, dynamic>> getListAttendanceOfDate(String class_id, String date) async {
    return dio.post("/it5023e/get_attendance_list",
      data: {
        "token": await accessToken,
        "class_id": class_id,
        "date": date,
        "pageable_request": {
          "page": "0",
          "page_size": "50"
        }
      },
    ).then((value) => value.data);
  }

  Future<Map<String, dynamic>> getHistoryAttendanceStudent(String class_id) async {
    return dio.post("/it5023e/get_attendance_record",
      data: {
        "token": await accessToken,
        "class_id": class_id,
      },
    ).then((value) => value.data);
  }

  Future<Map<String, dynamic>> createAttendance(String class_id, String date, List<String> attendance_list) async {
    return dio.post("/it5023e/take_attendance",
      data: {
        "token": await accessToken,
        "class_id": class_id,
        "date": date,
        "attendance_list": attendance_list
      },
    ).then((value) => value.data);
  }

  Future<Map<String, dynamic>> updateAttendance(String attendance_id, String status) async {
    return dio.post("/it5023e/set_attendance_status",
      data: {
        "token": await accessToken,
        "attendance_id": attendance_id,
        "status": status,
      },
    ).then((value) => value.data);
  }
}
