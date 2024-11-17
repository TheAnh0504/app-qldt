import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_qldt/model/entities/security_notification_model.dart';
import 'package:app_qldt/model/repositories/auth_repository.dart';
import 'package:app_qldt/controller/device_list_provider.dart';

final securityNotificationProvider = AsyncNotifierProvider.autoDispose<
    AsyncSecurityNotificationProvider,
    SecurityNotificationModel?>(AsyncSecurityNotificationProvider.new);

class AsyncSecurityNotificationProvider
    extends AutoDisposeAsyncNotifier<SecurityNotificationModel?> {
  @override
  FutureOr<SecurityNotificationModel?> build() async {
    return (await ref.watch(authRepositoryProvider.future)).api.getListNotify();
  }
}

final administratorProvider =
    AsyncNotifierProvider.autoDispose<AsyncAdministratorProvider, bool>(
        AsyncAdministratorProvider.new);

class AsyncAdministratorProvider extends AutoDisposeAsyncNotifier<bool> {
  @override
  FutureOr<bool> build() async {
    return await FirebaseMessaging.instance.getToken() ==
        ref.watch(rootDeviceProvider).value?.uuid;
  }
}
