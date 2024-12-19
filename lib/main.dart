import 'package:flutter/material.dart';
import 'package:flutter_app_assignment/SigninPage.dart';
import 'package:flutter_app_assignment/Splashscreen.dart';
import 'package:flutter_app_assignment/services_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
    create: (context) => ServicesModel(),
    child: MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen()
    );
  }
}

