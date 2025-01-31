// ignore_for_file: invalid_annotation_target, constant_identifier_names

import "dart:ffi";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:app_qldt/core/common/types.dart";

part "account_model.freezed.dart";
part "account_model.g.dart";

// flutter pub run build_runner build
// chú ý group_chat_model - fromJson

// _$GroupChatInfoModelImpl _$$GroupChatInfoModelImplFromJson(
//     Map<String, dynamic> json) =>
//     _$GroupChatInfoModelImpl(
//       groupId: (json['id'] as num).toInt(),
//       partner: json['partner'] as Object,
//       lastMessage: json['last_message'] as Object,
//       createdAt: json['created_at'] as String,
//       updatedAt: json['updated_at'] as String,
//     );

// _$GroupChatInfoMessageNotReadImpl _$$GroupChatInfoMessageNotReadImplFromJson(
//     Map<String, dynamic> json) =>
//     _$GroupChatInfoMessageNotReadImpl(
//       groupId: (json['id'] as num).toInt(),
//       partner: json['partner'] as Object,
//       lastMessage: json['last_message'] as Object,
//       createdAt: json['created_at'] as String,
//       updatedAt: json['updated_at'] as String,
//     );

@freezed
class AccountModel with _$AccountModel {
  @JsonSerializable(explicitToJson: true)
  const factory AccountModel(
      {
        @Default("") String idAccount,
        @Default("") String ho,
        @Default("") String ten,
        @Default("") String name,
        @Default("") String email,
        @Default("") String password,
        @Default("") String accessToken,
        @Default("") String role,
        @Default("") String status,
        @Default("") String avatar,
        @Default("") String verifyCode,
        @Default([]) List<dynamic>? classList,
        @Default(false) bool saved
      }) = _AccountModel;

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);
}

// class _AccountStatusConverter extends JsonConverter<AccountStatus, String> {
//   const _AccountStatusConverter();
//
//   @override
//   AccountStatus fromJson(String json) {
//     return AccountStatus.values
//         .firstWhere((e) => e.name == json, orElse: () => AccountStatus.NO);
//   }
//
//   @override
//   String toJson(AccountStatus object) {
//     return object.name;
//   }
// }
