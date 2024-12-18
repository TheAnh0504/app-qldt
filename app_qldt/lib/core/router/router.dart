import "package:app_qldt/view/pages/register_class/register_class_page_home.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:app_qldt/core/router/url.dart";
import "package:app_qldt/view/pages/auth/change_info_after_signup_page.dart";
import "package:app_qldt/view/pages/auth/force_change_password_page.dart";
import "package:app_qldt/view/pages/auth/forget_password_page.dart";
import "package:app_qldt/view/pages/auth/login_page.dart";
import "package:app_qldt/view/pages/auth/saved_login_page.dart";
import "package:app_qldt/view/pages/auth/signup_page.dart";
import "package:app_qldt/view/pages/auth/verify_first_login_page.dart";
import "package:app_qldt/view/pages/auth/verify_forget_pas_page.dart";
import "package:app_qldt/view/pages/auth/verify_unlock_acc_page.dart";
import "package:app_qldt/view/pages/auth/verify_user_page.dart";
import "package:app_qldt/view/pages/feed/feed_page.dart";
import "package:app_qldt/view/pages/feed/feed_search_page.dart";
import "package:app_qldt/view/pages/home_skeleton.dart";
import "package:app_qldt/view/pages/image_page.dart";
import "package:app_qldt/view/pages/messaging/messaging_conversation_list_page.dart";
import "package:app_qldt/view/pages/monitor/monitor_page.dart";
import "package:app_qldt/view/pages/profile/profile_change_user_info.dart";
import "package:app_qldt/view/pages/profile/profile_page.dart";
import "package:app_qldt/view/pages/settings/settings_page.dart";
import "package:app_qldt/view/pages/splash_page.dart";
import "package:app_qldt/view/pages/welcome_page.dart";

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
    initialLocation: splashRoute,
    navigatorKey: rootNavigatorKey,
    routes: [
      // page giao diện chờ
      GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: splashRoute,
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: const SplashPage())),
      // GoRoute(
      //   parentNavigatorKey: rootNavigatorKey,
      //   path: messagingRoute,
      //   pageBuilder: (context, state) => MaterialPage(
      //       key: state.pageKey, child: const MessagingConversationListPage()),
      // ),
      GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: welcomeRoute,
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: const WelcomePage())),
      // đăng ký
      GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: signupRoute,
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: const SignupPage()),
          routes: [
            GoRoute(
                parentNavigatorKey: rootNavigatorKey,
                path: "info",
                pageBuilder: (context, state) => MaterialPage(
                    key: state.pageKey,
                    child: const ChangeInfoAfterSignupPage())),
            // sau khi đăng ký bay vào đây xác thực mã code gửi về
            GoRoute(
                parentNavigatorKey: rootNavigatorKey,
                path: "verify",
                pageBuilder: (context, state) => MaterialPage(
                    key: state.pageKey, child: const VerifyUserPage())),
          ]),
      GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: forgetRoute,
          pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey, child: const ForgetPasswordPage()),
          routes: [
            GoRoute(
                parentNavigatorKey: rootNavigatorKey,
                path: "verify",
                pageBuilder: (context, state) => MaterialPage(
                    key: state.pageKey, child: const VerifyForgetPasPage())),
          ]),
      // login page --> k có account nào đc lưu, và đang login (feedRoute)
      // GoRoute(
      //     parentNavigatorKey: rootNavigatorKey,
      //     path: registerClassHome,
      //     pageBuilder: (context, state) {
      //       return MaterialPage(key: state.pageKey, child: const RegisterClassPageHome());
      //     },
      //     // routes: [
      //     //   // nếu có listAccount được save
      //     //   GoRoute(
      //     //       parentNavigatorKey: rootNavigatorKey,
      //     //       path: "saved",
      //     //       pageBuilder: (context, state) {
      //     //         return MaterialPage(
      //     //             key: state.pageKey, child: const SavedLoginPage());
      //     //       }),
      //     // ]
      // ),
      GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: loginRoute,
          pageBuilder: (context, state) {
            return MaterialPage(key: state.pageKey, child: const LoginPage());
          },
          routes: [
            // nếu có listAccount được save
            GoRoute(
                parentNavigatorKey: rootNavigatorKey,
                path: "saved",
                pageBuilder: (context, state) {
                  return MaterialPage(
                      key: state.pageKey, child: const SavedLoginPage());
                }),
          ]
      ),
      GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: imageRoute,
          pageBuilder: (context, state) {
            return MaterialPage(
                key: state.pageKey,
                child: ImagePage(url: state.uri.queryParameters["url"]!));
          }),
      GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: "$verifyRoute/:intent",
          pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: switch (state.pathParameters["intent"]) {
                "unlock_acc" => const VerifyUnlockAccPage(),
                "first_login" => const VerifyFirstLoginPage(),
                _ => Container()
              })),
      GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: searchRoute,
          pageBuilder: (context, state) {
            return MaterialPage(
                key: state.pageKey, child: const FeedSearchPage());
          }),
      GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: changePasswordRoute,
          pageBuilder: (context, state) {
            return MaterialPage(
                key: state.pageKey, child: const ForceChangePasswordPage());
          }),
      GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: "$profileRoute/edit",
          builder: (context, state) => const ProfileChangeUserInfoPage()),
      ShellRoute(
          parentNavigatorKey: rootNavigatorKey,
          navigatorKey: _shellNavigatorKey,
          pageBuilder: (context, state, child) => MaterialPage(
              key: state.pageKey, child: HomeSkeleton(child: child)),
          routes: [
            GoRoute(
              parentNavigatorKey: _shellNavigatorKey,
              path: feedRoute,
              builder: (context, state) => const FeedPage(),
            ),
            GoRoute(
              parentNavigatorKey: _shellNavigatorKey,
              path: messagingRoute,
              builder: (context, state) => const MessagingConversationListPage(),
            ),
            GoRoute(
                parentNavigatorKey: _shellNavigatorKey,
                path: profileRoute,
                builder: (context, state) => const ProfilePage()),
            GoRoute(
                parentNavigatorKey: _shellNavigatorKey,
                path: settingsRoute,
                builder: (context, state) => const SettingsPage())
          ])
    ]);
