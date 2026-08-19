import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/category.dart';
import '../models/dua.dart';
import '../models/quran.dart';
import '../models/ziyarat.dart';

class ContentService {
  Future<List<Dua>> loadDuas() async {
    final String jsonString = await rootBundle.loadString('lib/data/duas.json');

    final List<dynamic> jsonList = json.decode(jsonString);

    return jsonList.map((item) => Dua.fromJson(item)).toList();
  }

  Future<List<Category>> loadCategories() async {
    final String data = await rootBundle.loadString('lib/data/categories.json');

    final List<dynamic> jsonResult = json.decode(data);

    return jsonResult.map((item) => Category.fromJson(item)).toList();
  }

  Future<List<Ziyarat>> loadZiyarat() async {
    final String data = await rootBundle.loadString('lib/data/ziyarat.json');

    final List<dynamic> jsonResult = json.decode(data);

    return jsonResult.map((item) => Ziyarat.fromJson(item)).toList();
  }

  Future<List<QuranSurah>> loadQuran() async {
    final String data = await rootBundle.loadString('lib/data/quran.json');

    final List<dynamic> jsonResult = json.decode(data);

    return jsonResult.map((item) => QuranSurah.fromJson(item)).toList();
  }
}
