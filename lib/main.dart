import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Services/jajan_provider.dart';
import 'Services/auth_provider.dart';
import 'Pages/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JajanProvider()..initData()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0E7DFF); // Warna utama aplikasi

    return ScreenUtilInit(
      designSize: const Size(412, 917),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'LaperBang',
          theme: ThemeData(
            primaryColor: primaryBlue,
            scaffoldBackgroundColor: Colors.white,

            colorScheme: ColorScheme.fromSeed(
              seedColor: primaryBlue,
              primary: primaryBlue,
            ),

            progressIndicatorTheme: const ProgressIndicatorThemeData(
              color: primaryBlue,
            ),

            textTheme: GoogleFonts.interTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}