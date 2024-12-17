import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_qldt/model/datastores/swapi.dart';
import 'package:app_qldt/model/entities/push_noti.dart';

final pushNotiRepositoryProvider = Provider((ref) {
  return PushNotiRepository(ref.watch(swapiProvider));
});

class PushNotiRepository {
  final SWApi swapi;

  PushNotiRepository(this.swapi);

  Future<List<PushNoti>> getListNotification(int count) async {
    return swapi.getListNotification(count).then((value) {
      if (value["meta"]["code"] == "1000") {
        return (value["data"] as List<dynamic>)
            .map((e) => PushNoti.fromJson(e))
            .toList();
      }
      throw value;
    });
  }

  Future<int> getCountNotification() async {
    return swapi.getCountNotification().then((value) {
      if (value["meta"]["code"] == "1000") {
        return (value["data"]);
      }
      throw value;
    });
  }

  Future<String> readCountNotification(int id) async {
    return swapi.readCountNotification(id).then((value) {
      if (value["meta"]["code"] == "1000") {
        return 'Đánh dấu thông báo là đã đọc thành công';
      }
      throw value;
    });
  }
}
