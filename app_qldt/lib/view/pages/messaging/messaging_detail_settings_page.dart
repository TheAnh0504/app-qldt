// import 'package:extended_image/extended_image.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:go_router/go_router.dart';
// import 'package:app_qldt/core/extension/extension.dart';
// import 'package:app_qldt/core/common/types.dart';
// import 'package:app_qldt/data/model/message_model.dart';

// import '../../widgets/sw_settings_widget.dart';

// class MessagingDetailSettingsPage extends StatelessWidget {
//   final MessageUserModel user;

//   const MessagingDetailSettingsPage({super.key, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           leading: IconButton(
//               onPressed: context.pop, icon: const FaIcon(FaIcons.arrowLeft))),
//       body: _BuildBody(user: user),
//     );
//   }
// }

// class _BuildBody extends StatelessWidget {
//   final MessageUserModel user;

//   const _BuildBody({super.key, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: CircleAvatar(
//               radius: 40,
//               backgroundImage: ExtendedNetworkImageProvider(
//                   "https://picsum.photos/200",
//                   cache: true)),
//         ),
//         Text(user.displayName, style: context.textt.titleLarge),
//         const SizedBox(height: 24),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 InkWell(
//                   onTap: () {},
//                   child: Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                           color: context.colors.outlineVariant.withOpacity(0.5),
//                           shape: BoxShape.circle),
//                       child: const FaIcon(FaIcons.solidUser, size: 16)),
//                 ),
//                 const Text("Trang cá nhân")
//               ],
//             ),
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 InkWell(
//                   onTap: () {},
//                   child: Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                           color: context.colors.outlineVariant.withOpacity(0.5),
//                           shape: BoxShape.circle),
//                       child: const FaIcon(FaIcons.solidBell, size: 16)),
//                 ),
//                 const Text("Tắt thông báo")
//               ],
//             )
//           ],
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: SWListTileSection(
//               title: Text("Tùy chỉnh",
//                   style: context.textt.titleMedium
//                       ?.copyWith(color: context.colors.primary)),
//               tiles: [
//                 SWListTile(
//                     onTap: () {},
//                     title: const Text("Chủ đề"),
//                     leading: const FaIcon(FaIcons.wandMagicSparkles)),
//               ]),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: SWListTileSection(
//               title: Text("Hành động khác",
//                   style: context.textt.titleMedium
//                       ?.copyWith(color: context.colors.primary)),
//               tiles: [
//                 SWListTile(
//                     onTap: () {},
//                     title: const Text("Xem file phương tiện"),
//                     leading: const FaIcon(FaIcons.images)),
//                 SWListTile(
//                     onTap: () {},
//                     title: const Text("Thông báo và âm thanh"),
//                     leading: const FaIcon(FaIcons.solidBell)),
//                 SWListTile(
//                     onTap: () {},
//                     title: const Text("Chia sẻ thông tin liên hệ"),
//                     leading: const FaIcon(FaIcons.solidBell)),
//               ]),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: SWListTileSection(
//               title: Text("Quyền riêng tư",
//                   style: context.textt.titleMedium
//                       ?.copyWith(color: context.colors.primary)),
//               tiles: [
//                 SWListTile(
//                     onTap: () {},
//                     title: const Text("Chặn"),
//                     leading: const FaIcon(FaIcons.ban)),
//               ]),
//         ),
//       ],
//     );
//   }
// }
