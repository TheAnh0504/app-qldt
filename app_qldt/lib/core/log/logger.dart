// setup log
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BaseLogger {
  static void e(Object err, StackTrace stackTrace,
      [Map<String, dynamic>? data]) {
    if (!kDebugMode) return;
    data = {
      ...?data,
      "throw": err.toString(),
      "stack":
          stackTrace.toString().split("\n").where((s) => s.isNotEmpty).toList(),
      "event": data?["event"] + DateTime.now().toIso8601String()
    };
    var str = const JsonEncoder.withIndent(" ").convert(data);
    debugPrint("\x1b[1m\x1b[31m[Error ❌] $str\x1b[0m");
  }

  static void d(Map<String, dynamic> data) {
    if (!kDebugMode) return;
    data = {...data, "event": data["event"] + DateTime.now().toIso8601String()};
    var str = const JsonEncoder.withIndent(" ").convert(data);
    debugPrint("\x1b[1m\x1b[34m[Debug 🛠️] $str\x1b[0m");
  }

  static void v<T extends Object>(T data, [String Function(T)? convert]) {
    if (!kDebugMode) return;
    Map<String, dynamic> map = {
      "data": convert?.call(data) ?? data.toString(),
      "ts": DateTime.now().toIso8601String()
    };
    var str = const JsonEncoder.withIndent(" ").convert(map);
    debugPrint("\x1b[38;2;253;182;0m\x1b[1m[Verbose 💬] $str\x1b[0m");
  }

  static void i(String msg) {
    if (!kDebugMode) return;
    var data = {"info": msg, "ts": DateTime.now().toIso8601String()};
    var str = const JsonEncoder.withIndent(" ").convert(data);
    debugPrint("\x1b[1m\x1b[38;2;145;231;255m[Info 📌] $str\x1b[0m");
  }

  static void w(String msg) {
    if (!kDebugMode) return;
    var data = {"warning": msg, "ts": DateTime.now().toIso8601String()};
    var str = const JsonEncoder.withIndent(" ").convert(data);
    debugPrint("\x1b[1m\x1b[33m[Warning ⚠️] $str\x1b[0m");
  }

  static void a(AssertionError err, StackTrace stackTrace,
      [Map<String, dynamic>? data]) {
    if (!kDebugMode) return;

    data = {
      ...?data,
      "throw": err.toString(),
      "stack":
          stackTrace.toString().split("\n").where((s) => s.isNotEmpty).toList(),
      "event": data?["event"] + DateTime.now().toIso8601String()
    };
    var str = const JsonEncoder.withIndent(" ").convert(data);
    debugPrint("\x1b[1m\x1b[32m[Assert ✔️] $str\x1b[0m");
  }

  static void wtf(Map<String, dynamic> data) {
    if (!kDebugMode) return;
    data = {
      "wtf": "WTF!? WHY DID THIS SHIT HAPPEN?",
      ...data,
      "ts": DateTime.now().toIso8601String()
    };
    var str = const JsonEncoder.withIndent(" ").convert(data);
    debugPrint("\x1b[4m\x1b[1m\x1b[5m\x1b[37m[WTF!? 🤨] $str\x1b[0m");
    SystemNavigator.pop(animated: true);
  }
}

class Logger {
  static void functionCall(String name) {
    BaseLogger.d({"name": name, "event": "function-call"});
  }

  static providerInitialize(ProviderBase<Object?> provider, Object? value) {
    BaseLogger.d({
      "provider": provider.toString(),
      "value": value?.toString(),
      "event": "provider-initialize"
    });
  }

  static providerUpdate(
      ProviderBase<Object?> provider, Object? prev, Object? next) {
    BaseLogger.d({
      "provider": provider.toString(),
      "prev": prev?.toString(),
      "next": next?.toString(),
      "event": "provider-update"
    });
  }

  static providerDispose(ProviderBase<Object?> provider) {
    BaseLogger.d(
        {"provider": provider.toString(), "event": "provider-dispose"});
  }

  static providerError(
      ProviderBase<Object?> provider, Object err, StackTrace stackTrace) {
    BaseLogger.e(err, stackTrace,
        {"provider": provider.toString(), "event": "provider-error"});
  }

  static httpRequest(RequestOptions options) {
    BaseLogger.v({
      "method": options.method,
      "path": options.path,
      if (options.headers["Authorization"] != null)
        "auth": options.headers["Authorization"],
      if (options.method.toLowerCase() == "get")
        "query": options.queryParameters,
      if (options.method.toLowerCase() == "post") "body": options.data,
      "event": "http-request"
    });
  }

  static httpResponse(Response res) {
    BaseLogger.v({
      "path": res.requestOptions.path,
      "data": res.data,
      "event": "http-response"
    });
  }
}
