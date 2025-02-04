import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/controllers/podcast_controller.dart';
import 'package:podcast_app/controllers/user_controller.dart';
import 'package:podcast_app/firebase_options.dart';
import 'package:podcast_app/pages/splash_page.dart';
import 'package:podcast_app/services/localdb_services.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDbService().initializeLocalDb();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
//TODO Bütün podcastlerde kategori adetini güncelleme işlemini gerçekleştir
// Bildirim Kısmını ekle
// Hareketler kısmını ekle
// Controller ve Service kısmını daha okunaklı yaz
// Önerilenler kısmını ekle
// Podcast ekleme ve çıkış yap kısmındaki tasarımı düzelt
// Giriş yap kısmına AlertDialog ekle
// Search kısmında uyarı tarzında bir hata var onu çöz
// Podcast dinlerken bir döngü ekle.

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());
    Get.put(PodcastController());
    ScreenUtil.init(context,
        designSize: const Size(392.72727272727275, 783.2727272727273));
    return GetMaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Podcast Application',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primaryColor),
            useMaterial3: true,
            scaffoldBackgroundColor: AppColor.backgroundColor),
        home: SplashPage());
  }
}
