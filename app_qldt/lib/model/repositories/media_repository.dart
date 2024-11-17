import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_qldt/model/datastores/swapi.dart';

final mediaRepositoryProvider = Provider(
    (ref) => MediaRepository(MediaApiRepository(ref.watch(swapiProvider))));

class MediaRepository {
  final MediaApiRepository api;

  MediaRepository(this.api);
}

class MediaApiRepository {
  final SWApi swapi;

  MediaApiRepository(this.swapi);

  Future<String> addImage(File image) {
    return swapi.addImage(image).then((value) {
      if (value["code"] == 1000) return value["data"]["url"];
      throw value;
    });
  }
}
