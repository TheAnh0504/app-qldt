// ignore_for_file: invalid_annotation_target

import "package:freezed_annotation/freezed_annotation.dart";

part "device_model.freezed.dart";
part "device_model.g.dart";

@freezed
class DeviceModel with _$DeviceModel {
  @JsonSerializable(explicitToJson: true)
  const factory DeviceModel(
      {@Default("") String deviceId,
      @Default("") String uuid,
      required String type,
      String? model,
      required String version,
      // ignore: non_constant_identifier_names
      required String OS,
      @Default("") String serial,
      required String deviceName}) = _Device;

  factory DeviceModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceModelFromJson(json);
}
