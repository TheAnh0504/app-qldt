import 'package:app_qldt/model/entities/attendance_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/error/error.dart';
import '../model/repositories/auth_repository.dart';

final listAttendanceProvider =
AsyncNotifierProvider<AsyncListAttendanceProviderNotifier, List<AttendanceModel>?>
  (AsyncListAttendanceProviderNotifier.new);
class AsyncListAttendanceProviderNotifier extends AsyncNotifier<List<AttendanceModel>?> {

  @override
  Future<List<AttendanceModel>?> build() async {
    return null;
  }

  void forward(AsyncValue<List<AttendanceModel>?> value) => state = value;

  Future<List<String>> getListDateAttendance(String class_id) async {
    state = const AsyncValue.loading();
    try {
      List<String> res = [];
      var authRepository = (await ref.read(authRepositoryProvider.future));
      await authRepository.api.getListDateAttendance(class_id).then((value) async {
        // res = value["data"] as List<String>;
        for (int j = 0; j < (value["data"] as List<dynamic>).length; j++) {
          res.add((value["data"] as List<dynamic>)[j]);
        }
      });
      return res;
    } on Map<String, dynamic> catch (map) {
      state = AsyncError(errorMap[map["code"]].toString(), StackTrace.current);
      return [];
    }
  }

  Future<List<AttendanceModel>> getListAttendanceOfDate(String class_id, String date) async {
    state = const AsyncValue.loading();
    try {
      var res = <AttendanceModel>[];
      var authRepository = (await ref.read(authRepositoryProvider.future));
      // for (int i = 0; i < class_id.length; i++) {
        await authRepository.api.getListAttendanceOfDate(class_id, date).then((value) async {
          for (int j = 0; j < (value["data"]["attendance_student_details"] as List<dynamic>).length; j++) {
            AttendanceModel attendanceModel = AttendanceModel.fromJson((value["data"]["attendance_student_details"] as List<dynamic>)[j]);
            res.add(attendanceModel.copyWith(class_id: class_id[j]));
          }
        });
      // }
      state = AsyncData(res);
      return res;
    } on Map<String, dynamic> catch (map) {
      state = AsyncError(errorMap[map["code"]].toString(), StackTrace.current);
      return [];
    }
  }

  Future<List<String>> getHistoryAttendanceStudent(String class_id) async {
    try {
      List<String> res = [];
      var authRepository = (await ref.read(authRepositoryProvider.future));
      await authRepository.api.getHistoryAttendanceStudent(class_id).then((value) async {
        // res = value["data"]["absent_dates"];
        for (int j = 0; j < (value["data"]["absent_dates"] as List<dynamic>).length; j++) {
          res.add((value["data"]["absent_dates"] as List<dynamic>)[j]);
        }
      });
      return res;
    } on Map<String, dynamic> catch (map) {
      return [];
    }
  }

  Future<bool> createAttendance(String class_id, String date, List<String> attendance_list) async {
    try {
      var authRepository = (await ref.read(authRepositoryProvider.future));
      await authRepository.api.createAttendance(class_id, date, attendance_list).then((value) async {
        print(value);
      });
      return true;
    } on Map<String, dynamic> catch (map) {
      return false;
    }
  }

  Future<bool> updateAttendance(String attendance_id, String status) async {
    try {
      var authRepository = (await ref.read(authRepositoryProvider.future));
      await authRepository.api.updateAttendance(attendance_id, status).then((value) async {
        print(value);
      });
      return true;
    } on Map<String, dynamic> catch (map) {
      return false;
    }
  }

}