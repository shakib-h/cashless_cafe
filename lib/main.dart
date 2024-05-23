import 'package:flutter/material.dart';
import 'package:cashless_cafe/app/app.dart';
import 'package:cashless_cafe/app/tabs/home/details/details.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Set status bar color to transparent
    statusBarIconBrightness: Brightness.dark, // For Android
    statusBarBrightness: Brightness.light, // For iOS
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Cera Pro",
        primaryColor: const Color(0xFFE85852),
      ),
      routes: {
        'details': (context) => Details(),
      },
      home: App(),
    );
  }
}
