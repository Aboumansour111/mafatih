import 'package:flutter/material.dart';

import '../models/dua.dart';

class DuaScreen extends StatelessWidget {
  final Dua dua;

  const DuaScreen({super.key, required this.dua});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,

      child: Scaffold(
        appBar: AppBar(title: Text(dua.title), centerTitle: true),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              Text(
                dua.arabic,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 28, height: 2),
              ),

              const SizedBox(height: 30),

              const Divider(),

              const SizedBox(height: 20),

              Text(
                dua.translation,
                style: const TextStyle(fontSize: 18, height: 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
