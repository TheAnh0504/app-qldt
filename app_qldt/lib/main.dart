// cấu hình firebase --> gửi thông báo đẩy trong ứng dụng
import "package:app_qldt/view/pages/home_skeleton.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_messaging/firebase_messaging.dart";
// phát triển ứng dụng
import "package:flutter/foundation.dart";
// giao diện material design, cung cấp thành phần UI
import "package:flutter/material.dart";
// quản lý tương tác hệ thống, hướng thiết bị, ẩn TextInput
import "package:flutter/services.dart" hide TextInput;
// tải dữ liệu từ internet, lưu trữ cục bộ trên thiết bị người dùng
import "package:flutter_downloader/flutter_downloader.dart";
import "package:flutter_hooks/flutter_hooks.dart";
// Tạo, quản lý thông báo cục bộ trong ứng dụng (lên lịch, hiển thị khi ko có mạng)
import "package:flutter_local_notifications/flutter_local_notifications.dart";
// tạo các đề cập @username trong hộp thoại hoặc comment
import "package:flutter_mentions/flutter_mentions.dart";
// quản lý trạng thái phức tạp, dễ dàng tích hợp vào các widget
import "package:hooks_riverpod/hooks_riverpod.dart";
// tạo shortcut cho ứng dụng = biểu tượng trên màn hình chính
import "package:quick_actions/quick_actions.dart";
// điều hướng qua lại giữa các page, module của ứng dụng
import "package:app_qldt/core/router/router.dart";
// lưu log
import "package:app_qldt/core/log/logger.dart";
// màu
import "package:app_qldt/core/theme/palette.dart";
// kiểu chữ
import "package:app_qldt/core/theme/typestyle.dart";
// page đăng nhập - là 1 widget
import "package:app_qldt/view/pages/auth/login_page.dart";
// chứa cấu hình firebase
// npm install -g firebase-tools
// https://console.firebase.google.com/u/1/project/it4788-ehust/overview -- app flutter
import "firebase_options.dart";

void main() async {
  // các binding của Flutter phải được khởi tạo trước khi ứng dụng truy cập vào các dịch vụ không đồng bộ
  // cần thiết khi gọi các phương thức không đồng bộ hoặc khởi tạo các plugin trước khi runApp
  WidgetsFlutterBinding.ensureInitialized();
  // check xem project có chạy trên web ko
  if (kIsWeb) {}
  // thiết lập hướng màn hình ứng dụng chỉ hiển thị theo hướng dọc (portrait) - hỗ trợ 1 hướng màn hình duy nhất
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // khởi tạo Firebase với tùy chọn nền tảng hiện tại, giúp cấu hình Firebase chính xác cho từng nền tảng đang chạy
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // check xem ứng dụng có chạy trên di động ko? có thì cấu hình cho nền tảng di động
  if (!kIsWeb) {
    // khởi tạo thư viện, hỗ trợ tải file về thiết bị (ignoreSsl = true: bỏ qua lỗi SSL khi tải xuống file - không
    // khuyến cáo trong môi trường prod vì lý do bảo mật)
    FlutterDownloader.initialize(ignoreSsl: true);
    // tạo đối tượng QuickActions cho phép cấu hình các phím tắt trên màn hình chính
    const quickActions = QuickActions();
    // Khởi tạo các thao tác nhanh, kèm theo một hàm callback để xử lý khi người dùng nhấn vào shortcut
    // Hàm callback ((type) {}) hiện đang để trống, có thể được tùy chỉnh để xử lý loại hành động dựa trên type
    quickActions.initialize((type) {}).then((_) {
      // Đặt một danh sách shortcut lên màn hình chính với một shortcut là "Thêm bài viết" (Add Post)
      // để người dùng nhanh chóng truy cập vào tính năng này
      quickActions.setShortcutItems([
        const ShortcutItem(type: "action_post", localizedTitle: "Thêm bài viết")
      ]);
    });
  }

  // Lấy và in ra token của thiết bị cho Firebase Cloud Messaging, cho phép thiết bị nhận thông báo push từ Firebase
  String? token = await FirebaseMessaging.instance.getToken();
  print("Firebase Token: $token");
  // Tạo một kênh thông báo mặc định với id và tên là "default", bắt buộc khi gửi
  // thông báo đến các thiết bị Android hiện đại (từ Android 8 trở lên)
  // Tạo kênh thông báo cho Android
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'default', // id của kênh
    'Default Notifications', // tên hiển thị
    description: 'This channel is used for default notifications.',
    importance: Importance.high,
  );
  // await AndroidFlutterLocalNotificationsPlugin().createNotificationChannel(
  //     const AndroidNotificationChannel("default", "default"));
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Đăng ký hàm xử lý khi ứng dụng chạy ngầm
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // run app
  // ProviderScope đóng vai trò là gốc quản lý tất cả các provider trong ứng dụng
  runApp(const ProviderScope(child: app_qldt()));

  // run 1 page + follow provider
  // runApp(
  //   const ProviderScope(  // Đưa SWProviderObserver vào danh sách observers
  //     child: Test(),
  //   )
  // );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Thông báo khi ứng dụng chạy ngầm: ${message.notification?.title}");
  print("Thông báo khi ứng dụng chạy ngầm: ${message.data}");
  // Lấy URL hình ảnh từ dữ liệu thông báo
  String? imageUrl = message.data['imageUrl'];

  // Kiểm tra và sửa URL nếu cần
  if (imageUrl != null && imageUrl.contains('drive.google.com')) {
    // Sửa URL Google Drive thành link tải xuống trực tiếp
    imageUrl = convertDriveUrlToDirectDownload(imageUrl);
    print("Sửa URL hình ảnh: $imageUrl");
  }

}

String convertDriveUrlToDirectDownload(String url) {
  final fileId = url.split('/d/')[1].split('/')[0];
  return 'https://drive.google.com/uc?export=download&id=$fileId';
}

// test run 1 page
class Test extends HookConsumerWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const MaterialApp(
      home: Scaffold(body: LoginPage()),
    );
  }
}

// run app
class app_qldt extends HookConsumerWidget {
  const app_qldt({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      // final subscription = FirebaseMessaging.onMessage.listen((message) {
      //   print("Thông báo khi ứng dụng ở foreground: ${message.notification?.title}");
      // });
      // Lắng nghe thông báo khi ứng dụng ở foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("Thông báo khi ứng dụng ở foreground: ${message.notification?.title}");
        print("1: ${message.notification?.body}");
        print("2: ${message.notification?.android}");
        print("3: ${message.notification?.apple}");
        print("4: ${message.notification?.bodyLocKey}");
        print("5: ${message.notification?.bodyLocArgs}");
        print("6: ${message.notification?.titleLocKey}");
        print("7: ${message.notification?.titleLocArgs}");
        print("8: ${message.notification?.web}");
        print("Thông báo khi ứng dụng chạy ngầm: ${message.data}");
        // Điều hướng tới HomeSkeleton khi nhận thông báo
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => const HomeSkeleton(
        //     child: Center(
        //       child: Text('Chuyển đến HomeSkeleton sau thông báo'),
        //     ),
        //   ),
        // ));
      });

      // Xử lý khi người dùng nhấn vào thông báo
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("Người dùng nhấn vào thông báo: ${message.notification}");
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomeSkeleton(
            child: Center(
              child: Text('Chuyển đến HomeSkeleton khi nhấn thông báo'),
            ),
          ),
        ));
      });

      return null;
      // return subscription.cancel;
    }, []);
    return Portal(
      child: MaterialApp.router(
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Palette.redBackground, error: Palette.red),
              appBarTheme: AppBarTheme(
                  titleTextStyle:
                  TypeStyle.title1.copyWith(color: Palette.black),
                  scrolledUnderElevation: 0,
                  color: Colors.transparent),
              scaffoldBackgroundColor:
              Color.lerp(Palette.green, Palette.white, 0.95),
              listTileTheme: ListTileThemeData(
                  minLeadingWidth: 30,
                  titleTextStyle: TypeStyle.body3.copyWith(
                      fontWeight: FontWeight.w600, color: Palette.black)),
              filledButtonTheme: FilledButtonThemeData(
                  style: ButtonStyle(
                      elevation: const WidgetStatePropertyAll(0),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))))),
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                      elevation: const WidgetStatePropertyAll(0),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)))))),
          debugShowCheckedModeBanner: false,
          locale: const Locale("vi"),
          routerConfig: router,
          title: "Localizations Sample App"),
    );
  }
}

// theo dõi sự thay đổi trạng thái của provider trong 1 ứng dụng
class SWProviderObserver extends ProviderObserver {
  const SWProviderObserver();
  // được gọi khi 1 provider được thêm vào ứng dụng
  @override
  void didAddProvider(ProviderBase<Object?> provider, Object? value, ProviderContainer container) {
    // ghi log thông tin về provider được tạo: tên provider, giá trị khởi tạo
    Logger.providerInitialize(provider, value);
    // mọi hành vi mặc định khác được thực hiện như thường
    super.didAddProvider(provider, value, container);
  }

  // được gọi khi provider bị hủy (dispose) khỏi ứng dụng
  @override
  void didDisposeProvider(ProviderBase<Object?> provider, ProviderContainer container) {
    // ghi log sự kiện hủy provider
    Logger.providerDispose(provider);
    // giữ hành vi mặc định của lớp cha
    super.didDisposeProvider(provider, container);
  }

  // gọi khi giá trị của provider được cập nhật
  @override
  void didUpdateProvider(ProviderBase<Object?> provider, Object? previousValue, Object? newValue, ProviderContainer container) {
    // ghi log lại sự thay đổi: giá trị cũ, mới
    Logger.providerUpdate(provider, previousValue, newValue);
    super.didUpdateProvider(provider, previousValue, newValue, container);
  }

  // gọi khi có lỗi xảy ra trong provider
  @override
  void providerDidFail(ProviderBase<Object?> provider, Object error, StackTrace stackTrace, ProviderContainer container) {
    // log lỗi và thông tin stack trace của nó
    Logger.providerError(provider, error, stackTrace);
    super.providerDidFail(provider, error, stackTrace, container);
  }
}
