import "package:flutter/services.dart";

const swMethodChannel = SWMethodChannel();

class SWMethodChannel {
  const SWMethodChannel();

  static const services = _SWService();
}

class _SWService {
  const _SWService();

  final channel = const MethodChannel("app_qldt/services");

  void moveTaskToBack() => channel.invokeMethod("moveTaskToBack");
}
