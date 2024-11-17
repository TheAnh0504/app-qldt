import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_noti.freezed.dart';
part 'push_noti.g.dart';

@freezed
class PushNoti with _$PushNoti {
  const factory PushNoti(
      {required Map<String, dynamic> notification,
      required Map<String, dynamic> author,
      required Map<String, dynamic> user}) = _PushNoti;

  factory PushNoti.fromJson(Map<String, dynamic> json) =>
      _$PushNotiFromJson(json);
}
