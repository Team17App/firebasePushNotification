import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'config/constants.dart';
import 'screens/screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: APP_NAME,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.deepPurpleAccent,
        ),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        "/": (_) => const MyHomePage(),
      },
    );
  }
}
