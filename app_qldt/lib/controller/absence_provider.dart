import 'dart:io';

import 'package:app_qldt/model/entities/absence_request_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/error/error.dart';
import '../model/repositories/auth_repository.dart';

final absenceProvider =
AsyncNotifierProvider<AsyncAbsenceNotifier, List<AbsenceRequestModel>?>(
    AsyncAbsenceNotifier.new);
// chơi ko đồng bộ: call api, get data from database
class AsyncAbsenceNotifier extends AsyncNotifier<List<AbsenceRequestModel>?> {
  // hàm khởi tạo cho AsyncNotifier, đc gọi khi provider được khởi tạo
  @override
  Future<List<AbsenceRequestModel>?> build() async {
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
        return const AsyncData(null);
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

  Future<List<AbsenceRequestModel>?> getAbsenceRequestStudent(String? classId, String? status, String? date) async {
    try {
      List<AbsenceRequestModel> res = [];
      var authRepository = (await ref.read(authRepositoryProvider.future));
      res = await authRepository.api.getAbsenceRequestStudent(classId, status, date)
          .then((value) async {
            if (classId != null && classId.isNotEmpty) {
              value = value.map((absence) => absence.copyWith(class_id: classId)).toList();
            }
            return value;
      });
      state = AsyncData(res);
      return res;
    } on Map<String, dynamic> catch (map) {
      print('error');
      return null;
    }
  }

  Future<List<AbsenceRequestModel>?> getAbsenceRequestLecture(String? classId, String? status, String? date) async {
    try {
      List<AbsenceRequestModel> res = [];
      var authRepository = (await ref.read(authRepositoryProvider.future));
      res = await authRepository.api.getAbsenceRequestLecture(classId, status, date)
          .then((value) async {
        if (classId != null && classId.isNotEmpty) {
          value = value.map((absence) => absence.copyWith(class_id: classId)).toList();
        }
        return value;
      });
      state = AsyncData(res);
      return res;
    } on Map<String, dynamic> catch (map) {
      print('error');
      return null;
    }
  }

  Future<bool> reviewAbsenceRequest(String requestId, String status) async {
    try {
      var authRepository = (await ref.read(authRepositoryProvider.future));
      await authRepository.api.reviewAbsenceRequest(requestId, status).then((value) {
            print(value);
      });
      return true;
      // bắt lỗi Map<String, dynamic> map
    } on Map<String, dynamic> catch (map) {
      return false;
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
  void forward(AsyncValue<List<AbsenceRequestModel>?> value) => state = value;
}

final absenceProvider1 =
AsyncNotifierProvider<AsyncAbsenceNotifier1, List<AbsenceRequestModel>?>(
    AsyncAbsenceNotifier1.new);
// chơi ko đồng bộ: call api, get data from database
class AsyncAbsenceNotifier1 extends AsyncNotifier<List<AbsenceRequestModel>?> {
  // hàm khởi tạo cho AsyncNotifier, đc gọi khi provider được khởi tạo
  @override
  Future<List<AbsenceRequestModel>?> build() async {
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
        return const AsyncData(null);
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

  Future<List<AbsenceRequestModel>?> getAbsenceRequestStudent(String? classId, String? status, String? date) async {
    try {
      List<AbsenceRequestModel> res = [];
      var authRepository = (await ref.read(authRepositoryProvider.future));
      res = await authRepository.api.getAbsenceRequestStudent(classId, status, date)
          .then((value) async {
        if (classId != null && classId.isNotEmpty) {
          value = value.map((absence) => absence.copyWith(class_id: classId)).toList();
        }
        return value;
      });
      state = AsyncData(res);
      return res;
    } on Map<String, dynamic> catch (map) {
      print('error');
      return null;
    }
  }

  Future<List<AbsenceRequestModel>?> getAbsenceRequestLecture(String? classId, String? status, String? date) async {
    try {
      List<AbsenceRequestModel> res = [];
      var authRepository = (await ref.read(authRepositoryProvider.future));
      res = await authRepository.api.getAbsenceRequestLecture(classId, status, date)
          .then((value) async {
        if (classId != null && classId.isNotEmpty) {
          value = value.map((absence) => absence.copyWith(class_id: classId)).toList();
        }
        return value;
      });
      state = AsyncData(res);
      return res;
    } on Map<String, dynamic> catch (map) {
      print('error');
      return null;
    }
  }

  Future<bool> reviewAbsenceRequest(String requestId, String status) async {
    try {
      var authRepository = (await ref.read(authRepositoryProvider.future));
      await authRepository.api.reviewAbsenceRequest(requestId, status).then((value) {
        print(value);
      });
      return true;
      // bắt lỗi Map<String, dynamic> map
    } on Map<String, dynamic> catch (map) {
      return false;
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
  void forward(AsyncValue<List<AbsenceRequestModel>?> value) => state = value;
}