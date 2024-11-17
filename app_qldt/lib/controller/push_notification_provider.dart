import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_qldt/model/entities/push_noti.dart';
import 'package:app_qldt/model/entities/push_notification_settings_model.dart';
import 'package:app_qldt/model/repositories/push_noti_repository.dart';
import 'package:app_qldt/model/repositories/user_repository.dart';

final pushNotificationProvider = AsyncNotifierProvider.autoDispose<
    PushNotificationNotifier,
    PushNotificationSettingsModel>(PushNotificationNotifier.new);

class PushNotificationNotifier
    extends AutoDisposeAsyncNotifier<PushNotificationSettingsModel> {
  @override
  Future<PushNotificationSettingsModel> build() async {
    return ref.watch(userRepositoryProvider).api.getPushSetting();
  }

  Future<void> toggleSound(bool sound) async {
    await ref.read(userRepositoryProvider).api.setPushSetting(
        ledOn: state.value!.ledOn,
        vibrantOn: state.value!.vibrantOn,
        notificationOn: state.value!.notificationOn,
        soundOn: sound);
    ref.invalidateSelf();
  }

  Future<void> toggleLed(bool led) async {
    await ref.read(userRepositoryProvider).api.setPushSetting(
        ledOn: led,
        vibrantOn: state.value!.vibrantOn,
        notificationOn: state.value!.notificationOn,
        soundOn: state.value!.soundOn);
    ref.invalidateSelf();
  }

  Future<void> toggleNotification(bool push) async {
    await ref.read(userRepositoryProvider).api.setPushSetting(
        ledOn: state.value!.ledOn,
        vibrantOn: state.value!.vibrantOn,
        notificationOn: push,
        soundOn: state.value!.soundOn);
    ref.invalidateSelf();
  }

  Future<void> toggleVibrate(bool vibrate) async {
    await ref.read(userRepositoryProvider).api.setPushSetting(
        ledOn: state.value!.ledOn,
        vibrantOn: vibrate,
        notificationOn: state.value!.notificationOn,
        soundOn: state.value!.soundOn);
    ref.invalidateSelf();
  }
}

final notificationProvider =
    FutureProvider.autoDispose.family<List<PushNoti>, int>((ref, params) {
  return ref.read(pushNotiRepositoryProvider).getListNotification(params);
});
