import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_qldt/model/repositories/student_repository.dart';

final studentProvider =
    FutureProvider.autoDispose.family<List<dynamic>, String>((ref, params) {
  return ref.read(studentRepositoryProvider).getListStudent(params);
});

final notifyByStudentProvider =
    FutureProvider.autoDispose.family<List<dynamic>, String>((ref, params) {
  return ref.read(studentRepositoryProvider).getNotifyByStudentId(params);
});
