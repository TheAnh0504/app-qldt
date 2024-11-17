import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:app_qldt/model/entities/device_model.dart";
import "package:app_qldt/model/repositories/auth_repository.dart";

final rootDeviceProvider =
    AsyncNotifierProvider.autoDispose<AsyncRootDeviceNotifier, DeviceModel>(
        AsyncRootDeviceNotifier.new);

class AsyncRootDeviceNotifier extends AutoDisposeAsyncNotifier<DeviceModel> {
  @override
  Future<DeviceModel> build() async {
    return (await ref.watch(authRepositoryProvider.future)).api.getRootDevice();
  }

  Future<void> changeRoot(DeviceModel accessDevice) async {
    (await ref.watch(authRepositoryProvider.future))
        .api
        .changeRootDevice(accessDevice);
    state = AsyncData(accessDevice);
    ref.invalidate(accessDeviceProvider);
  }
}

final accessDeviceProvider = AsyncNotifierProvider.autoDispose<
    AsyncAccessDeviceNotifier,
    List<DeviceModel>>(AsyncAccessDeviceNotifier.new);

class AsyncAccessDeviceNotifier
    extends AutoDisposeAsyncNotifier<List<DeviceModel>> {
  @override
  Future<List<DeviceModel>> build() async {
    return (await ref.watch(authRepositoryProvider.future))
        .api
        .getAccessDevices();
  }

  Future<void> deleteAll() async {
    (await ref.watch(authRepositoryProvider.future)).api.deleteAccessDevices();
    state = const AsyncData([]);
  }

  Future<void> delete(DeviceModel device) async {
    (await ref.watch(authRepositoryProvider.future))
        .api
        .deleteAccessDevice(device);
    state = AsyncData((state.value ?? []).where((e) => e != device).toList());
  }
}

final currentDeviceProvider =
    AsyncNotifierProvider.autoDispose<AsyncCurrentDeviceNotifier, DeviceModel>(
        AsyncCurrentDeviceNotifier.new);

class AsyncCurrentDeviceNotifier extends AutoDisposeAsyncNotifier<DeviceModel> {
  @override
  Future<DeviceModel> build() async {
    return (await ref.watch(authRepositoryProvider.future))
        .api
        .getListInfoDevice()
        .then((value) async {
      final token = await FirebaseMessaging.instance.getToken();
      return value.firstWhere((e) => e.uuid == token,
          orElse: () => value.first);
    });
  }
}
