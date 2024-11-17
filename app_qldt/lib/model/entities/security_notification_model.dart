import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:app_qldt/model/entities/device_model.dart';

part "security_notification_model.freezed.dart";
part "security_notification_model.g.dart";

@freezed
class SecurityNotificationModel with _$SecurityNotificationModel {
  const factory SecurityNotificationModel(
      {required String confirmWhat,
      required String requestSending,
      required DeviceModel device}) = _SecurityNoti;

  factory SecurityNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$SecurityNotificationModelFromJson(json);
}
