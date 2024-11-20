import "dart:async";

import "package:app_qldt/model/repositories/auth_repository.dart";
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:app_qldt/core/common/types.dart";
import "package:app_qldt/core/router/url.dart";
import "package:app_qldt/core/theme/component.dart";
import "package:app_qldt/core/theme/palette.dart";
import "package:app_qldt/core/theme/typestyle.dart";
import "package:app_qldt/controller/account_provider.dart";
import "package:app_qldt/controller/verify_code_provider.dart";

class VerifyUserPage extends StatelessWidget {
  const VerifyUserPage({super.key});

  void _onBack(BuildContext context) {
    showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog.adaptive(
                title: const Text("Xác nhận thoát"),
                content: const Text(
                    "Nếu thoát, bạn sẽ phải liên hệ nhân viên hỗ trợ để hoàn thành đăng ký. Bạn có chắc chắn muốn thoát?"),
                actions: [
                  TextButton(
                      onPressed: () => context.pop(false),
                      child: const Text("Hủy", style: TypeStyle.body4)),
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
            backgroundColor: Theme.of(context).colorScheme.primary,
            extendBodyBehindAppBar: true,
            body: const _BuildBody()));
  }
}

class _BuildBody extends ConsumerStatefulWidget {
  const _BuildBody();

  @override
  ConsumerState<_BuildBody> createState() => _BuildBodyState();
}

class _BuildBodyState extends ConsumerState<_BuildBody> {
  Timer? _timer;
  int remainingSeconds = 300;

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
    remainingSeconds = 300;
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
    ref.listen(verifyCodeProvider(VerifyCodeType.add_user), (prev, next) async {
      if (next.value == VerifyCodeState.success) {
        await ref.read(accountProvider.notifier).login(ref.watch(accountProvider).value!.email, ref.watch(accountProvider).value!.password);
        context.go("$signupRoute/info");
      } else if (next.value == VerifyCodeState.sent) {
        setTimer();
      }
    });
    return Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
            color: Palette.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0), topRight: Radius.circular(0))),
        margin: EdgeInsets.only(top: MediaQuery.sizeOf(context).width / 5),
        padding: const EdgeInsets.all(32),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text("NHẬP MÃ XÁC NHẬN",
                    style: TypeStyle.title1.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
              ),
              const SizedBox(height: 24),
              Center(
                child: Builder(builder: (context) {
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
                                "Mã xác nhận của bạn là "),
                            TextSpan(
                                text: ref.watch(accountProvider).value?.verifyCode,
                                style: TypeStyle.body2
                                    .copyWith(fontStyle: FontStyle.italic, color: Palette.red)),
                          ], style: TypeStyle.body2),
                          textAlign: TextAlign.center),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              Builder(builder: (context) {
                return VerifyCodeInput(
                  onCompleted: (code) {
                    ref
                        .read(verifyCodeProvider(VerifyCodeType.add_user)
                            .notifier)
                        .checkVerifyCode(code);
                  },
                  onChanged: (_) {
                    ref.invalidate(verifyCodeProvider(VerifyCodeType.add_user));
                  },
                  isError: ref
                      .watch(verifyCodeProvider(VerifyCodeType.add_user))
                      .hasError,
                  errorText: ref
                      .watch(verifyCodeProvider(VerifyCodeType.add_user))
                      .error
                      ?.toString(),
                );
              }),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("Mã xác nhận hết hạn?", style: TypeStyle.body3),
                TextButton(
                    onPressed: remainingSeconds == 0
                        ? () async {
                            ref
                                .read(
                                    verifyCodeProvider(VerifyCodeType.add_user)
                                        .notifier)
                                .getVerifyCode();
                          }
                        : null,
                    child: Text(remainingSeconds != 0
                        ? "Gửi lại (${remainingSeconds}s)."
                        : "Gửi lại."))
              ]),
            ]));
  }
}
