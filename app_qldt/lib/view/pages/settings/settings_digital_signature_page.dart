import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:pointycastle/asymmetric/api.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/security/rsa.dart";
import "package:app_qldt/core/theme/palette.dart";
import "package:app_qldt/model/datastores/sw_secure_storage.dart";
import "package:app_qldt/model/datastores/swapi.dart";

class SettingsDigitalSignaturePage extends StatelessWidget {
  const SettingsDigitalSignaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Xác thực trên thiết bị gốc"),
          leading: IconButton(
              onPressed: () => context.pop(),
              icon: const FaIcon(FaIcons.arrowLeft))),
      body: const _BuildBody(),
    );
  }
}

class _BuildBody extends ConsumerStatefulWidget {
  const _BuildBody();

  @override
  ConsumerState<_BuildBody> createState() => _BuildBodyState();
}

class _BuildBodyState extends ConsumerState<_BuildBody> {
  bool isLoading = false;
  late Future<(RSAPublicKey?, DateTime)?> getDataFuture;

  @override
  void initState() {
    super.initState();
    getDataFuture = swSecureStorage.getPublicKey();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
          future: getDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done || isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (true) {
              return Column(children: [
                Card(
                  elevation: 0,
                  color: Palette.grey25,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Text(
                        "Xác thực trên thiết bị gốc chưa được kích hoạt trên thiết bị này. Kích hoạt sẽ cho phép bạn phê duyệt nhanh các thiết bị mới yêu cầu đăng nhập."),
                  ),
                ),
                const Spacer(),
                FilledButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await ref.read(swapiProvider).addPublicKey(
                          RSA.encodePublicKeyToPem(
                              (await RSA.generatekeyPair()).$1));
                      setState(() {
                        getDataFuture = swSecureStorage.getPublicKey();
                        isLoading = false;
                      });
                    },
                    child: const Text("Kích hoạt"))
              ]);
            }
            // else {
            //   return Column(children: [
            //     Card(
            //       elevation: 0,
            //       color: Palette.grey25,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(12)),
            //       child: const Padding(
            //         padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            //         child: Text("Xác thực thiết bị gốc đã được kích hoạt."),
            //       ),
            //     )
            //   ]);
            // }
          }),
    );
  }
}
