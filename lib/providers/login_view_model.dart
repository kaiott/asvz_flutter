import 'dart:async';

import 'package:asvz_autosignup/repositories/credentials_repository.dart';
import 'package:asvz_autosignup/repositories/token_repository.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final TokenRepository _tokenRepository;
  final CredentialsRepository _credentialsRepository;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  LoginViewModel({
    required TokenRepository tokenRepository,
    required CredentialsRepository credentialsRepository
  }) : _tokenRepository = tokenRepository,
       _credentialsRepository = credentialsRepository;

  String? get errorText {
    return _credentialsRepository.status == CredentialStatus.invalid ? "Incorrect credentials" : null;
  }

  VoidCallback? get onSubmit => _credentialsRepository.status == CredentialStatus.validating? null : _onSubmit;

  void _onSubmit() {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();
    unawaited(_credentialsRepository.setCredentials(username, password, _tokenRepository.validateCredentials));
  }
}
