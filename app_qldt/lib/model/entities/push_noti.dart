import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_noti.freezed.dart';
part 'push_noti.g.dart';

@freezed
class PushNoti with _$PushNoti {
  const factory PushNoti(
      {
        required int id,
        String? message,
        String? status,
        int? fromUser,
        int? toUser,
        String? type,
        String? imageUrl,
        required String sentTime,
        String? titlePushNotification,
        String? dataType,
        String? dataId
      }) = _PushNoti;

  factory PushNoti.fromJson(Map<String, dynamic> json) =>
      _$PushNotiFromJson(json);
}
