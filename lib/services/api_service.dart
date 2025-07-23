import 'dart:convert';
import 'dart:io';

import 'package:asvz_autosignup/models/lesson.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'schalter.asvz.ch';

Future<Lesson> fetchLesson(int id) async {
  final resourcePath = '/tn-api/api/Lessons/$id';
  final url = Uri.https(baseUrl, resourcePath);
  final response = await http.get(url);
  if (response.statusCode != 200) {
    throw HttpException("Non-okay status code from request.", uri: url);
  }
  final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
  final lesson = Lesson.fromJson(jsonResponse["data"]);
  return lesson;
}