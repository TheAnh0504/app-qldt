import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:go_router/go_router.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/router/url.dart";
import "package:app_qldt/core/theme/component.dart";
import "package:app_qldt/core/theme/palette.dart";
import "package:app_qldt/core/theme/typestyle.dart";
import "package:app_qldt/controller/account_provider.dart";
import "package:app_qldt/controller/verify_code_provider.dart";

class VerifyForgetPasPage extends StatelessWidget {
  const VerifyForgetPasPage({super.key});

  void _onBack(BuildContext context) {
    showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog.adaptive(
                title: const Text("Xác nhận thoát"),
                content: const Text(
                    "Nếu thoát, bạn sẽ phải nhập mã xác nhận trong lần đăng nhập kế tiếp. Bạn có chắc chắn muốn thoát?"),
                actions: [
                  TextButton(
                      onPressed: () => context.pop(false),
                      child: const Text("Hủy")),
                  FilledButton(
                      onPressed: () => context.pop(true),
                      child: const Text("Xác nhận")),
                ])).then((value) {
      if (value ?? false) context.go(loginRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) => _onBack(context),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                  onPressed: () => _onBack(context),
                  icon: const FaIcon(FaIcons.arrowLeft))),
          body: const _BuildBody(),
        ));
  }
}

class _BuildBody extends ConsumerStatefulWidget {
  const _BuildBody();

  @override
  ConsumerState<_BuildBody> createState() => _BuildBodyState();
}

class _BuildBodyState extends ConsumerState<_BuildBody> {
  Timer? _timer;
  int remainingSeconds = 180;

  @override
  void initState() {
    super.initState();
    setTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void setTimer() {
    _timer?.cancel();
    remainingSeconds = 180;
    SchedulerBinding.instance.addPostFrameCallback((timestamp) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        if (remainingSeconds <= 0) return timer.cancel();
        remainingSeconds--;
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(verifyCodeProvider(VerifyCodeType.forget_pas), (prev, next) {
      if (next.value == VerifyCodeState.success) {
        Fluttertoast.showToast(
            msg:
                "Tài khoản đã được làm mới mật khẩu. Hãy đăng nhập với mật khẩu mới.");
        context.go(loginRoute);
      } else if (next.value == VerifyCodeState.sent) {
        setTimer();
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
                              text: ref.watch(accountProvider).value?.email,
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
                        .read(verifyCodeProvider(VerifyCodeType.forget_pas)
                            .notifier)
                        .checkVerifyCode(code);
                  },
                  onChanged: (_) {
                    ref.invalidate(
                        verifyCodeProvider(VerifyCodeType.forget_pas));
                  },
                  isError: ref
                      .watch(verifyCodeProvider(VerifyCodeType.forget_pas))
                      .hasError,
                  errorText: ref
                      .watch(verifyCodeProvider(VerifyCodeType.forget_pas))
                      .error
                      ?.toString(),
                );
              }),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("Không nhận được mã?"),
                TextButton(
                    onPressed: () async {
                      if (remainingSeconds == 0) {
                        ref
                            .read(verifyCodeProvider(VerifyCodeType.forget_pas)
                                .notifier)
                            .getVerifyCode();
                      }
                    },
                    child: remainingSeconds != 0
                        ? Text("Gửi lại sau ${remainingSeconds}s.")
                        : const Text("Gửi lại."))
              ]),
            ]));
  }
}
