import 'package:firebase_push_notification/screens/desktop/home.dart';
import 'package:firebase_push_notification/screens/mobile/home.dart';
import 'package:firebase_push_notification/widgets/responsive_widgets.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: ResponsiveWidget(
          mobileScreen: HomeMobile(),
          desktopScreen: HomeDesktop(),
        ),
      ),
    );
  }
}
