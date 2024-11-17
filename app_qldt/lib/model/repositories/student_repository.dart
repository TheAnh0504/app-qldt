import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_qldt/model/datastores/swapi.dart';

final studentRepositoryProvider = Provider((ref) {
  return StudentRepository(ref.watch(swapiProvider));
});

class StudentRepository {
  final SWApi swapi;

  StudentRepository(this.swapi);

  Future<List<dynamic>> getListStudent(String teacherId) async {
    return swapi.getListStudent(teacherId).then((value) {
      if (value["code"] == 1000) {
        return (value["data"] as List<dynamic>);
      }
      throw value;
    });
  }

  Future<List<dynamic>> getNotifyByStudentId(String studentId) async {
    return swapi.getNotifyByStudentId(studentId).then((value) {
      if (value["code"] == 1000) {
        return (value["data"] as List<dynamic>);
      }
      throw value;
    });
  }
}
