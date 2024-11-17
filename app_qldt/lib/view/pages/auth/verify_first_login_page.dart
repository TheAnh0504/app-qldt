import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/theme/component.dart";
import "package:app_qldt/core/theme/palette.dart";
import "package:app_qldt/core/theme/typestyle.dart";
import "package:app_qldt/controller/account_provider.dart";
import "package:app_qldt/controller/verify_code_provider.dart";

class VerifyFirstLoginPage extends StatelessWidget {
  const VerifyFirstLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
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
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(verifyCodeProvider(VerifyCodeType.first_login), (prev, next) {
      if (next.value == VerifyCodeState.success) {
        Fluttertoast.showToast(msg: "Đã cấp phép cho thiết bị truy cập.");
      }
    });

    return Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
            color: Palette.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        margin: EdgeInsets.only(top: MediaQuery.sizeOf(context).width / 3),
        padding: const EdgeInsets.all(32),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text("NHẬP MÃ XÁC NHẬN",
                    style: TypeStyle.title2.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
              ),
              const SizedBox(height: 32),
              Builder(builder: (context) {
                return Card(
                  elevation: 0,
                  color: Palette.grey25,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: Text.rich(
                        TextSpan(children: [
                          const TextSpan(
                              text:
                                  "Mã xác nhận đã được gửi tới địa chỉ email "),
                          TextSpan(
                              text: ref.watch(accountProvider).value?.username,
                              style: TypeStyle.body2
                                  .copyWith(fontStyle: FontStyle.italic)),
                          const TextSpan(text: ".")
                        ], style: TypeStyle.body2),
                        textAlign: TextAlign.center),
                  ),
                );
              }),
              const SizedBox(height: 32),
              Builder(builder: (context) {
                return VerifyCodeInput(
                  onCompleted: (code) {
                    ref
                        .read(verifyCodeProvider(VerifyCodeType.first_login)
                            .notifier)
                        .checkVerifyCode(code);
                  },
                  onChanged: (_) {
                    ref.invalidate(
                        verifyCodeProvider(VerifyCodeType.first_login));
                  },
                  isError: ref
                      .watch(verifyCodeProvider(VerifyCodeType.first_login))
                      .hasError,
                  errorText: ref
                      .watch(verifyCodeProvider(VerifyCodeType.first_login))
                      .error
                      ?.toString(),
                );
              }),
              const SizedBox(height: 16),
            ]));
  }
}
