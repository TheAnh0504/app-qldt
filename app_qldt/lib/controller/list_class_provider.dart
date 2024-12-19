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

final listClassFilterProvider =
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

  // update state với AccountModel mới
  void forward(AsyncValue<List<ClassInfoModel>?> value) => state = value;
}