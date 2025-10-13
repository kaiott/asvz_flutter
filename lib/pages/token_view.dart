import 'package:asvz_autosignup/providers/token_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TokenView extends StatelessWidget {
  const TokenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TokenViewModel>(
      builder: (context, tokenModel, child) => Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                Text("Token Status"),
                tokenModel.statusIcon,
                OutlinedButton(
                  onPressed: tokenModel.isBusy ? null : tokenModel.onRefreshButtonClicked,
                  child: Text("Refresh token"),
                ),
              ],
            ),
            Text(tokenModel.refreshText),
          ],
        ),
      ),
    );
  }
}
