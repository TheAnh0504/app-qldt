import 'package:app_qldt/model/entities/class_info_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/error/error.dart';
import '../model/repositories/auth_repository.dart';

final listClassProvider =
AsyncNotifierProvider<AsyncClassInfoNotifier, List<ClassInfoModel>?>(
    AsyncClassInfoNotifier.new);
// chơi ko đồng bộ: call api, get data from database
class AsyncClassInfoNotifier extends AsyncNotifier<List<ClassInfoModel>?> {
  // hàm khởi tạo cho AsyncNotifier, đc gọi khi provider được khởi tạo
  @override
  Future<List<ClassInfoModel>?> build() async {
    // khởi tạo null cho AccountModel khi ứng dụng run
    return null;
  }

  // update state với AccountModel mới
  void forward(AsyncValue<List<ClassInfoModel>?> value) => state = value;

  Future<void> getListClassInfo() async {
    state = const AsyncValue.loading();
    try {
      var authRepository = (await ref.read(authRepositoryProvider.future));
      state = await authRepository.api.getListClassInfo()
          .then((value) async {
        // 1 data success from async
        return AsyncData(value);
      });
      // bắt lỗi Map<String, dynamic> map
    } on Map<String, dynamic> catch (map) {
      state = AsyncError(errorMap[map["code"]].toString(), StackTrace.current);
    }
  }

  Future<void> getListClassInfoBy(String? classId, String? className, String? status, String? classType) async {
    state = const AsyncValue.loading();
    try {
      var authRepository = (await ref.read(authRepositoryProvider.future));
      state = await authRepository.api.getListClassInfoBy(classId, className, status, classType)
          .then((value) async {
        // 1 data success from async
        return AsyncData(value);
      });
      // bắt lỗi Map<String, dynamic> map
    } on Map<String, dynamic> catch (map) {
      state = AsyncError(errorMap[map["code"]].toString(), StackTrace.current);
    }
  }
}

final listClassRegisterNowProvider =
AsyncNotifierProvider<AsyncClassInfoFilterNotifier, List<ClassInfoModel>?>(
    AsyncClassInfoFilterNotifier.new);
// chơi ko đồng bộ: call api, get data from database
class AsyncClassInfoFilterNotifier extends AsyncNotifier<List<ClassInfoModel>?> {
  // hàm khởi tạo cho AsyncNotifier, đc gọi khi provider được khởi tạo
  @override
  Future<List<ClassInfoModel>?> build() async {
    // khởi tạo null cho AccountModel khi ứng dụng run
    return null;
  }

  Future<void> getRegisterClassNow() async {
    state = const AsyncValue.loading();
    try {
      var authRepository = (await ref.read(authRepositoryProvider.future));
      state = await authRepository.api.getRegisterClassNow()
          .then((value) async {
        // 1 data success from async
        return AsyncData(value);
      });
      // bắt lỗi Map<String, dynamic> map
    } on Map<String, dynamic> catch (map) {
      state = AsyncError(errorMap[map["code"]].toString(), StackTrace.current);
    }
  }

  Future<List<ClassInfoModel>?> registerClass(List<String> classId, List<ClassInfoModel> allClass) async {
    state = const AsyncValue.loading();
    try {
      var authRepository = (await ref.read(authRepositoryProvider.future));
      List<ClassInfoModel> response = [];
      state = await authRepository.api.registerClass(classId, allClass)
          .then((value) async {
            response = value;
            print('giá trị $value');
        // 1 data success from async
        return AsyncData(value);
      });
      return response;
      // bắt lỗi Map<String, dynamic> map
    } on Map<String, dynamic> catch (map) {
      state = AsyncError(errorMap[map["code"]].toString(), StackTrace.current);
      return [];
    }
  }

  Future<bool> addStudent(String classId, String accountId) async {
    try {
      var authRepository = (await ref.read(authRepositoryProvider.future));
      await authRepository.api.addStudent(classId, accountId).then((value) async {
        print('giá trị $value');
      });
      return true;
      // bắt lỗi Map<String, dynamic> map
    } on Map<String, dynamic> catch (map) {
      return false;
    }
  }

  Future<bool> deleteClass(String classId) async {
    try {
      var authRepository = (await ref.read(authRepositoryProvider.future));
      await authRepository.api.deleteClass(classId).then((value) async {
        print('giá trị $value');
      });
      return true;
      // bắt lỗi Map<String, dynamic> map
    } on Map<String, dynamic> catch (map) {
      return false;
    }
  }

  // update state với AccountModel mới
  void forward(AsyncValue<List<ClassInfoModel>?> value) => state = value;
}

final listClassAllProvider =
AsyncNotifierProvider<AsyncClassInfoAllNotifier, List<ClassInfoModel>?>(
    AsyncClassInfoAllNotifier.new);
// chơi ko đồng bộ: call api, get data from database
class AsyncClassInfoAllNotifier extends AsyncNotifier<List<ClassInfoModel>?> {
  // hàm khởi tạo cho AsyncNotifier, đc gọi khi provider được khởi tạo
  @override
  Future<List<ClassInfoModel>?> build() async {
    // khởi tạo null cho AccountModel khi ứng dụng run
    return null;
  }

  // update state với AccountModel mới
  void forward(AsyncValue<List<ClassInfoModel>?> value) => state = value;

  Future<void> getListClassInfo() async {
    state = const AsyncValue.loading();
    try {
      var authRepository = (await ref.read(authRepositoryProvider.future));
      state = await authRepository.api.getListClassInfo()
          .then((value) async {
        // 1 data success from async
        return AsyncData(value);
      });
      // bắt lỗi Map<String, dynamic> map
    } on Map<String, dynamic> catch (map) {
      state = AsyncError(errorMap[map["code"]].toString(), StackTrace.current);
    }
  }
}

final infoClassDataProvider =
AsyncNotifierProvider<AsyncInfoClassNotifier, ClassInfoModel?>(AsyncInfoClassNotifier.new);
class AsyncInfoClassNotifier extends AsyncNotifier<ClassInfoModel?> {
  @override
  Future<ClassInfoModel?> build() async {
    return null;
  }

  void forward(AsyncValue<ClassInfoModel?> value) => state = value;

  Future<ClassInfoModel?> getClassInfo(String classId) async {
    state = const AsyncValue.loading();
    try {
      ClassInfoModel? res;
      String? max_student_amount;
      var authRepository = (await ref.read(authRepositoryProvider.future));
      await authRepository.api.getClassBasicInfo(classId).then((value) {
        max_student_amount = value.max_student_amount;
      });
      state = await authRepository.api.getClassInfo(classId).then((value) {
        res = value.copyWith(max_student_amount: max_student_amount);
        return AsyncData(value);
      });
      return res;
    } on Map<String, dynamic> catch (map) {
      state = AsyncError(errorMap[map["code"]].toString(), StackTrace.current);
      return null;
    }
  }
}