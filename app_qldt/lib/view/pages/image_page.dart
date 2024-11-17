import "dart:async";

import "package:dio/dio.dart";
import "package:extended_image/extended_image.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:permission_handler/permission_handler.dart";
import "package:share_plus/share_plus.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/model/repositories/downloader_repository.dart";

class ImagePage extends ConsumerWidget {
  const ImagePage({required this.url, super.key});

  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              onPressed: () => context.pop(),
              icon: const FaIcon(FaIcons.arrowLeft,
                  shadows: [Shadow(blurRadius: 1)]),
              color: Colors.white),
          actions: [
            IconButton(
                onPressed: () => handleDownload(context, ref),
                icon: const FaIcon(FaIcons.download,
                    shadows: [Shadow(blurRadius: 1)]),
                color: Colors.white),
            IconButton(
                onPressed: handleShare,
                icon: const FaIcon(FaIcons.share,
                    shadows: [Shadow(blurRadius: 1)]),
                color: Colors.white)
          ],
        ),
        body: _BuildBody(url: url));
  }

  Future<void> handleShare() async {
    Fluttertoast.showToast(msg: "Đang chuẩn bị...");
    final response = await Dio().get<Uint8List>(url,
        options: Options(responseType: ResponseType.bytes));
    final result = await Share.shareXFiles([
      XFile.fromData(response.data!,
          mimeType: response.headers["content-type"]?.last)
    ]);
    if (result.status == ShareResultStatus.success) {
      Fluttertoast.showToast(msg: "Chia sẻ ảnh thành công.");
    }
  }

  Future<void> handleDownload(BuildContext context, WidgetRef ref) async {
    if (kIsWeb) return;
    if (await Permission.storage.isPermanentlyDenied && context.mounted) {
      showDialog(
          context: context,
          builder: (context) => const _PermanentlyDeniedAlertDialog());
      return;
    }
    Permission.storage
      ..onGrantedCallback(() => ref
          .read(downloaderRepositoryProvider)
          .download(url)
          .then((_) =>
              Fluttertoast.showToast(msg: "Đang tiến hành tải ảnh xuống...")))
      ..onDeniedCallback(
          () => Fluttertoast.showToast(msg: "Quyền truy cập bị từ chối."))
      ..request();
  }
}

class _BuildBody extends StatelessWidget {
  const _BuildBody({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
          tag: url,
          child: ExtendedImage(
            image: ExtendedNetworkImageProvider(url, cache: true),
            mode: ExtendedImageMode.gesture,
            gaplessPlayback: true,
            initGestureConfigHandler: (state) {
              return GestureConfig(
                minScale: 0.9,
                animationMinScale: 0.7,
                maxScale: 3.0,
                animationMaxScale: 3.5,
                speed: 1.0,
                inertialSpeed: 100.0,
                initialScale: 1.0,
                inPageView: false,
                initialAlignment: InitialAlignment.center,
              );
            },
          )),
    );
  }
}

class _PermanentlyDeniedAlertDialog extends StatelessWidget {
  const _PermanentlyDeniedAlertDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: const Text("Không có quyền truy cập bộ nhớ"),
      content: const Text(
          "Để tải ảnh xuống, ứng dụng cần có quyền truy cập bộ nhớ của thiết bị."),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text("Hủy")),
        const TextButton(onPressed: openAppSettings, child: Text("Tới Cài đặt"))
      ],
    );
  }
}
