import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final downloaderRepositoryProvider = Provider((ref) {
  return DownloaderRepository();
});

class DownloaderRepository {
  Future<void> download(String url) async {
    try {
      await FlutterDownloader.enqueue(
          url: url,
          saveInPublicStorage: true,
          savedDir: await getDownloadsDirectory()
              .then((value) => value!.path)
              .onError((error, stackTrace) => ""));
    } finally {}
  }
}
