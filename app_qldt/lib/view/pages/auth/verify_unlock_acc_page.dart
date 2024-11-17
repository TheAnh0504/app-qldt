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

class VerifyUnlockAccPage extends StatelessWidget {
  const VerifyUnlockAccPage({super.key});

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
    remainingSeconds = 180;
    SchedulerBinding.instance.addPostFrameCallback((timestamp) {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        setState(() {
          remainingSeconds--;
        });
        if (remainingSeconds == 0) timer.cancel();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(verifyCodeProvider(VerifyCodeType.unlock_acc), (prev, next) {
      if (next.value == VerifyCodeState.success) {
        Fluttertoast.showToast(
            msg: "Tài khoản đã được mở khóa. Hãy đăng nhập lại");
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
                        .read(verifyCodeProvider(VerifyCodeType.unlock_acc)
                            .notifier)
                        .checkVerifyCode(code);
                  },
                  onChanged: (_) {
                    ref.invalidate(
                        verifyCodeProvider(VerifyCodeType.unlock_acc));
                  },
                  isError: ref
                      .watch(verifyCodeProvider(VerifyCodeType.unlock_acc))
                      .hasError,
                  errorText: ref
                      .watch(verifyCodeProvider(VerifyCodeType.unlock_acc))
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
                            .read(verifyCodeProvider(VerifyCodeType.unlock_acc)
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
