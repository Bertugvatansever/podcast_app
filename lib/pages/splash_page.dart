import 'package:flutter/material.dart';
import 'package:podcast_app/pages/login_page.dart';
import 'package:podcast_app/pages/root_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}
