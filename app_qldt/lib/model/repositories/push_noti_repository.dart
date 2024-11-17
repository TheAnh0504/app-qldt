import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_qldt/model/datastores/swapi.dart';
import 'package:app_qldt/model/entities/push_noti.dart';

final pushNotiRepositoryProvider = Provider((ref) {
  return PushNotiRepository(ref.watch(swapiProvider));
});

class PushNotiRepository {
  final SWApi swapi;

  PushNotiRepository(this.swapi);

  Future<List<PushNoti>> getListNotification(int offset) async {
    return swapi.getListNotification(offset).then((value) {
      if (value["code"] == 1000) {
        return (value["data"] as List<dynamic>)
            .map((e) => PushNoti.fromJson(e))
            .toList();
      }
      throw value;
    });
  }
}
