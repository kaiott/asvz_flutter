import 'dart:convert';
import 'dart:io';

import 'package:asvz_autosignup/models/lesson.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

const String baseUrl = 'schalter.asvz.ch';

const loginHeaders = {
  "Content-Type": "application/x-www-form-urlencoded",
  "Referer": "https://auth.asvz.ch/Account/Login",
  "Origin": "https://auth.asvz.ch",
  "User-Agent":
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36",
};

const authHeaders = {
  "Referer": "https://schalter.asvz.ch/",
  "User-Agent":
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36",
};

Future<Map<String, dynamic>> fetchLessonRaw(int id) async {
  //print('fetching lesson $id');
  final resourcePath = '/tn-api/api/Lessons/$id';
  final url = Uri.https(baseUrl, resourcePath);
  final response = await http.get(url);
  if (response.statusCode != 200) {
    throw HttpException(
      "Non-okay status code ${response.statusCode} from request",
      uri: url,
    );
  }
  return jsonDecode(response.body) as Map<String, dynamic>;
}

Future<Lesson> fetchLesson(int id) async {
  final jsonResponse = await fetchLessonRaw(id);
  final lesson = Lesson.fromJson(jsonResponse["data"]);
  return lesson;
}

Future <int> fetchNumberOfFreeSpots(int id) async {
  final jsonResponse = await fetchLessonRaw(id);
  return jsonResponse["data"]["participantsMax"] - jsonResponse["data"]["participantCount"];
}

Future<bool> tryEnroll(int id, String token) async {
  final resourcePath = '/tn-api/api/Lessons/$id/Enrollment';
  final url = Uri.https(baseUrl, resourcePath);
  final headers = {
    'Host': 'schalter.asvz.ch',
    'Connection': 'keep-alive',
    'Accept': 'application/json, text/plain, */*',
    'Authorization': 'Bearer $token',
    'User-Agent': "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36",
    'Origin': 'https://schalter.asvz.ch',
    'Referer': 'https://schalter.asvz.ch/tn/lessons/$id',
    'Accept-Encoding': 'gzip, deflate, br',
    'Accept-Language': 'de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7',
    'Content-Type': 'application/json',
  };
  print('before posting url');
  http.post(url, headers: headers, body: '{}'); // this always times out. So we do even await it. Rather wait a bit after.
  print('after posting url');
  await Future.delayed(Duration(seconds: 5));
  print('after 5 second delay');
  return await isEnrolled(id, token);
}

Future<bool> isEnrolled(int id, String token) async {
  final resourcePath = '/tn-api/api/Lessons/$id/MyEnrollment';
  final url = Uri.https(baseUrl, resourcePath);
  final headers = {
    'Host': 'schalter.asvz.ch',
    'Connection': 'keep-alive',
    'Accept': 'application/json, text/plain, */*',
    'Authorization': 'Bearer $token',
    'User-Agent': "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36",
    'Origin': 'https://schalter.asvz.ch',
    'Referer': 'https://schalter.asvz.ch/tn/lessons/$id',
  };

  final response = await http.get(url, headers: headers);
  if (response.statusCode == 404) {
    try {
      final errorStatus = (jsonDecode(response.body) as Map<String, dynamic>)["errorStatus"];
      if (errorStatus == 'RecordNotFound') return false;
      throw Exception("Got weird error status $errorStatus");
    } on Exception catch(e) {
      throw Exception("Could not jsonify or find errorStatus in ${response.body}: ${e.toString()}");
    }
  } else if (response.statusCode == 200) {
    try {
      final status = (jsonDecode(response.body) as Map<String, dynamic>)["data"]["status"];
      if (status == 4) return true;
      if (status == 6) return false;
      throw Exception('Got weird status $status');
    } on Exception catch(e) {
      throw Exception("Could not jsonify or find data.status in ${response.body}: ${e.toString()}");
    }
  } else {
    throw Exception('Got unexpected status code ${response.statusCode}');
  }
}

// Combine all cookie headers manually
String getCookiesFromSetCookieHeaders(List<String> setCookies) {
  return setCookies
      .map((c) => c.split(';').first.trim())
      .join('; ');
}

Future<String> updateAccessToken() async {
  final client = http.Client();

  try {
    // Step 1: GET login page
    final loginUrl = Uri.https('auth.asvz.ch', '/Account/Login');
    final loginResponse = await client.get(loginUrl);
    final document = html_parser.parse(loginResponse.body);

    // Step 2: extract anti-CSRF token
    final input = document.querySelector(
      "input[name='__RequestVerificationToken']",
    );
    final csrfToken = input?.attributes["value"];

    if (csrfToken == null) throw Exception("Missing CSRF token");

    // Step 3: Extract antiforgery cookie
    final antiforgeryCookie = _extractCookieFromString(loginResponse.headers["set-cookie"] ?? '', ".AspNetCore.Antiforgery.MkeJ4WI3ssE");
    if (antiforgeryCookie == null) throw Exception("Missing .AspNetCore.Antiforgery.MkeJ4WI3ssE cookie");

    // Step 4: Read credentials
    final credentialsJson = await rootBundle.loadString(
      'assets/credentials.json',
    );
    final credentials = jsonDecode(credentialsJson);

    final formData = {
      "AsvzId": credentials["username"],
      "Password": credentials["password"],
      "__RequestVerificationToken": csrfToken,
    };

    // Step 5: POST login
    final postLoginResponse = await client.post(
      loginUrl,
      headers: {...loginHeaders, 'Cookie': antiforgeryCookie},
      body: formData,
    );
    //print(postLoginResponse.statusCode);
    //print(postLoginResponse.headers);

    if (postLoginResponse.statusCode != 302) {
      throw Exception(
        "Login failed with status ${postLoginResponse.statusCode}",
      );
    }

    final idsrvSessionCookie = _extractCookieFromString(postLoginResponse.headers["set-cookie"] ?? '', "idsrv.session");
    if (idsrvSessionCookie == null) throw Exception("Missing idsrv.session cookie");
    final identityApplicationCookie = _extractCookieFromString(postLoginResponse.headers["set-cookie"] ?? '', ".AspNetCore.Identity.Application");
    if (identityApplicationCookie == null) throw Exception("Missing .AspNetCore.Identity.Application cookie");

    final authCookieHeader = [antiforgeryCookie, idsrvSessionCookie, identityApplicationCookie].join('; ');

    // Step 6: Get access token
    final authUrl = Uri.https('auth.asvz.ch', '/connect/authorize', {
      "client_id": "55776bff-ef75-4c9d-9bdd-45e883ec38e0",
      "redirect_uri":
          "https://schalter.asvz.ch/tn/assets/oidc-login-redirect.html",
      "response_type": "id_token token",
      "scope": "openid profile tn-api tn-apiext tn-auth tn-hangfire",
      "state": "fa1cdc0af1714ca89ece0ec3ff497b13",
      "nonce": "d389a530175749bd9aa35180e9b75ef8",
    });

    final authSessionHeaders = {
      ...authHeaders,
      'Cookie': authCookieHeader,
    };

    final tokenResponse = await _manualRedirectGet(authUrl, authSessionHeaders);

    if (tokenResponse.statusCode != 302) {
      throw Exception(
        "Token redirect failed with status ${tokenResponse.statusCode}",
      );
    }
    final String? location = tokenResponse.headers.value("location");
    if (location == null) throw Exception("Missing location in tokenResponse headers");

    final locationUri = Uri.parse(location);
    final fragment = locationUri.fragment;
    final tokenParts = Uri.splitQueryString(fragment);
    final accessToken = tokenParts["access_token"];
    if (accessToken == null) throw Exception("Missing access_token in location header");
    return accessToken;
  } finally {
    client.close();
  }
}

String? _extractCookieFromString(String cookieHeader, String cookieNameStart) {
  final regex = RegExp(
    r'(?:(^|,\s?))' // match start of string or comma-separated list
    r'(' '${RegExp.escape(cookieNameStart)}' r'[^=;]*)=([^;]+)',
  );

  final match = regex.firstMatch(cookieHeader);
  if (match != null) {
    final name = match.group(2);
    final value = match.group(3);
    return '$name=$value';
  }

  return null;
}

// String _extractAntiforgeryCookie(String cookieHeader) {
//   final match = RegExp(
//     r'(\.AspNetCore\.Antiforgery\.[^=]+=[^;]+)',
//   ).firstMatch(cookieHeader);
//   return match != null ? match.group(1)! : '';
// }

Future<HttpClientResponse> _manualRedirectGet(Uri uri, Map<String, String> headers) async {
  final client = HttpClient();
  final request = await client.getUrl(uri);
  headers.forEach((key, value) {
    request.headers.set(key, value);
  });

  // Important: disable redirects
  request.followRedirects = false;

  final response = await request.close();
  return response;
}

