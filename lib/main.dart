import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const MafatihApp());
}

class MafatihApp extends StatelessWidget {
  const MafatihApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'مفاتیح یمانی',

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff00695c)),

        scaffoldBackgroundColor: const Color(0xfffaf6ef),

        textTheme: GoogleFonts.vazirmatnTextTheme(),

        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Color(0xff00695c),
          foregroundColor: Colors.white,
        ),
      ),

      home: const HomeScreen(),
    );
  }
}
