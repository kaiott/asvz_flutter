import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum CredentialStatus {none, signedIn, invalid, validating}

class CredentialsRepository with ChangeNotifier{
  static const _storage = FlutterSecureStorage();
  static const _usernameKey = 'asvz_username';
  static const _passwordKey = 'asvz_password';
  
  final ValueNotifier<CredentialStatus> _statusNotifier = ValueNotifier<CredentialStatus>(CredentialStatus.none);
  String? _username;
  String? _password;

  void _setStatus(CredentialStatus status) {
    _statusNotifier.value = status;
    notifyListeners();
  }

  Future<void> checkCredentials() async {
    final username = await _storage.read(key: _usernameKey);
    final password = await _storage.read(key: _passwordKey);
    if (username == null || password == null) {
      _setStatus(CredentialStatus.none);
      return;
    }
    _username = username;
    _password = password;

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
    return {'username': _username!, 'password': _password!};
  }

  Future<void> setCredentials(String username, String password, Future<bool> Function(String, String) validateCredentials) async {
    bool valid = await validateCredentials(username, password);
    if (!valid) {
      _setStatus(CredentialStatus.invalid);
      return;
    }
    await _storage.write(key: _usernameKey, value: username);
    await _storage.write(key: _passwordKey, value: password);
    _username = username;
    _password = password;
    _setStatus(CredentialStatus.signedIn);
  }

  Future<void> logOut() async {
    await _storage.delete(key: _usernameKey);
    await _storage.delete(key: _passwordKey);
    _username = null;
    _password = null;
    _setStatus(CredentialStatus.none);
  }
}