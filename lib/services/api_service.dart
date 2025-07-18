import 'package:asvz_autosignup/models/lesson.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'schalter.asvz.ch';

Lesson? fetchLesson(int id) {
  final resourcePath = '/tn-api/api/Lessons/$id';
  final url = Uri.https(baseUrl, resourcePath);
  return null;
}