import 'dart:async';

import 'package:asvz_autosignup/repositories/credentials_repository.dart';
import 'package:asvz_autosignup/repositories/token_repository.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  final TokenRepository tokenRepository;
  final CredentialsRepository credentialsRepository;
  final bool failed;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  LoginView({super.key, required this.credentialsRepository, required this.tokenRepository, this.failed = false});

  String? get error {
    return failed ? "Incorrect credentials" : null;
  }

  void _onSubmit() {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    unawaited(credentialsRepository.setCredentials(username, password, tokenRepository.validateCredentials));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Welcome"),
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: "Username",
              errorText: error,
            ),
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
              errorText: error,
            ),
            onSubmitted: (_) => _onSubmit(),
          ),
          OutlinedButton(
          onPressed: _onSubmit,
          child: Text("Login"),
        ),
        ],
      ),
    );
  }
}
