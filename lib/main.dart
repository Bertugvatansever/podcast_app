import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:podcast_app/app_colors.dart';
import 'package:podcast_app/pages/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: const Size(392.72727272727275, 783.2727272727273));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Podcast Application',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFA6FF96)),
            useMaterial3: true,
            scaffoldBackgroundColor: AppColor().backgroundColor),
        home: const SplashPage());
  }
}
