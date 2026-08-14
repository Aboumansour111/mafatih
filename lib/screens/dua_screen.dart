import 'package:flutter/material.dart';

import '../models/dua.dart';

class DuaScreen extends StatelessWidget {
  final Dua dua;

  const DuaScreen({super.key, required this.dua});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(dua.title), centerTitle: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            // بسم الله الرحمن الرحیم
            const Text(
              'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيمِ',

              textDirection: TextDirection.rtl,

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 2,
              ),
            ),

            const SizedBox(height: 20),

            // متن عربی
            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: const Color(0xff00695c).withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
              ),

              child: Text(
                dua.arabic,

                textDirection: TextDirection.rtl,

                textAlign: TextAlign.justify,

                style: const TextStyle(
                  fontSize: 22,
                  height: 2.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // عنوان ترجمه
            const Text(
              'ترجمه',

              textDirection: TextDirection.rtl,

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // ترجمه فارسی
            Text(
              dua.translation,

              textDirection: TextDirection.rtl,

              textAlign: TextAlign.justify,

              style: const TextStyle(fontSize: 17, height: 2),
            ),
          ],
        ),
      ),
    );
  }
}
