import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Color.fromARGB(126, 158, 158, 158),
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // fontFamily: GoogleFonts.roboto().fontFamily,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.white,
          primarySwatch: Colors.grey,
          brightness: Brightness.light,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            // backgroundColor: Colors.white,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 224, 224, 224),
          foregroundColor: Colors.black,
        ),
        listTileTheme: const ListTileThemeData(
          textColor: Colors.black,
        ),
        useMaterial3: true,
      ),
      title: "Cashless Cafe",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
