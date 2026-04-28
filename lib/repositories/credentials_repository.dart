import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

enum CredentialStatus {none, signedIn, invalid}

class CredentialsRepository with ChangeNotifier{
  
  // Private attributes
  final ValueNotifier<CredentialStatus> _statusNotifier = ValueNotifier<CredentialStatus>(CredentialStatus.none);
  // Future reference: Map<String, String>? _credentials;
  String? _username;
  String? _password;

  void _setStatus(CredentialStatus status) {
    _statusNotifier.value = status;
    notifyListeners();
  }

  Future<void> checkCredentials() async {
    //TODO: switch to flutter_secure_storage
    final credentialsJson = await rootBundle.loadString(
      'assets/credentials.json',
    );
    final credentials = jsonDecode(credentialsJson);
    _username = credentials["username"];
    _password = credentials["password"];

    // TODO: if not available set (or keep) status to none

    // TODO: validity check of credentials

    _setStatus(CredentialStatus.signedIn);
  }

  // public getters and methods
  ValueListenable<CredentialStatus> get credentialStatusListenable => _statusNotifier;

  CredentialStatus get status => _statusNotifier.value;
  
  Map<String, String> get credentials {
    if (status == CredentialStatus.none) {
      throw Exception("Asked for credentials without signedIn State.");
    }
    Map<String, String> credentials = {};
    credentials["username"] = _username!;
    credentials["password"] = _password!;
    return credentials;
  }

  Future<bool> setCredentials(String username, String password) async {
    // TODo: save credentials and check if they are valid
    print("Checking credentials $username, $password ...");
    return true;
  }

  void logOut() {
    _username = null;
    _password = null;
    //TODO: delete credentials from storage
    _setStatus(CredentialStatus.none);
  }





}