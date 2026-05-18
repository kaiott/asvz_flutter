import 'package:asvz_autosignup/providers/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, vm, child) => Scaffold(
        body: Column(
          children: [
            Text("Welcome"),
            TextField(
              controller: vm.usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                errorText: vm.errorText,
              ),
            ),
            TextField(
              controller: vm.passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                errorText: vm.errorText,
              ),
              onSubmitted: (_) => vm.onSubmit?.call(),
            ),
            OutlinedButton(onPressed: vm.onSubmit, child: Text("Login")),
          ],
        ),
      ),
    );
  }
}
