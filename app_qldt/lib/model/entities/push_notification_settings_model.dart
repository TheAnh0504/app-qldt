import 'package:freezed_annotation/freezed_annotation.dart';

part "push_notification_settings_model.freezed.dart";
part "push_notification_settings_model.g.dart";

@freezed
class PushNotificationSettingsModel with _$PushNotificationSettingsModel {
  @JsonSerializable(explicitToJson: true)
  const factory PushNotificationSettingsModel(
      {@Default(true) bool vibrantOn,
      @Default(true) bool notificationOn,
      @Default(true) bool soundOn,
      @Default(true) bool ledOn}) = _PushNotiSettings;

  factory PushNotificationSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationSettingsModelFromJson(json);
}
