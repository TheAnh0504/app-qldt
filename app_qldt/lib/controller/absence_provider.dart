import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/error/error.dart';
import '../model/repositories/auth_repository.dart';

final absenceProvider =
AsyncNotifierProvider<AsyncAbsenceNotifier, Map<String, dynamic>?>(
    AsyncAbsenceNotifier.new);
// chơi ko đồng bộ: call api, get data from database
class AsyncAbsenceNotifier extends AsyncNotifier<Map<String, dynamic>?> {
  // hàm khởi tạo cho AsyncNotifier, đc gọi khi provider được khởi tạo
  @override
  Future<Map<String, dynamic>?> build() async {
    // khởi tạo null cho AccountModel khi ứng dụng run
    return null;
  }

  Future<bool> requestAbsence(String classId, String date, String reason, File? file, String title) async {
    state = const AsyncValue.loading();
    try {
      var authRepository = (await ref.read(authRepositoryProvider.future));
      state = await authRepository.api.requestAbsence(classId, date, reason, file, title)
          .then((value) async {
        // 1 data success from async
        return AsyncData(value);
      });
      return true;
      // bắt lỗi Map<String, dynamic> map
    } on Map<String, dynamic> catch (map) {
      state = AsyncError(errorMap[map["code"]].toString(), StackTrace.current);
      return false;
    }
  }

  Future<void> sendNotify(String message, String toUser, String type) async {
    try {
      var authRepository = (await ref.read(authRepositoryProvider.future));
      await authRepository.api.sendNotify(message, toUser, type)
          .then((value) async {
            print('value');
      });
      // bắt lỗi Map<String, dynamic> map
    } on Map<String, dynamic> catch (map) {
      print('error');
    }
  }


  // Future<bool> addStudent(String classId, String accountId) async {
  //   try {
  //     var authRepository = (await ref.read(authRepositoryProvider.future));
  //     await authRepository.api.addStudent(classId, accountId).then((value) async {
  //       print('giá trị $value');
  //     });
  //     return true;
  //     // bắt lỗi Map<String, dynamic> map
  //   } on Map<String, dynamic> catch (map) {
  //     return false;
  //   }
  // }

  // update state với AccountModel mới
  void forward(AsyncValue<Map<String, dynamic>?> value) => state = value;
}