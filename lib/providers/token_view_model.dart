import 'dart:async';

import 'package:asvz_autosignup/repositories/token_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TokenViewModel extends ChangeNotifier {
  final TokenRepository tokenRepository;

  TokenViewModel({required this.tokenRepository}) {
    tokenRepository.tokenStatusListenable.addListener(onTokenStatusChanged);
  }

  //TODO: tokenRepository.tokenStatusListenable connect to onTokenStatusChanged

  Icon get statusIcon {
    switch (tokenRepository.status) {
      case TokenStatus.none:
        return Icon(Icons.circle_outlined);
      case TokenStatus.refreshing:
        return Icon(Icons.circle_notifications_sharp);
      case TokenStatus.valid:
        return Icon(Icons.check, color: Colors.green,);
      case TokenStatus.expired:
        return Icon(Icons.warning, color: Colors.orangeAccent,);
      case TokenStatus.error:
        return Icon(Icons.error, color: Colors.redAccent,);
    }
  }

  String get refreshText {
    if (tokenRepository.tokenAcquiredAt == null) {
      return 'No refresh yet';
    }
    return 'Last refreshed at ${DateFormat('HH:mm, dd.MM.yy').format(tokenRepository.tokenAcquiredAt!)}';
  }

  void onRefreshButtonClicked() {
    unawaited(tokenRepository.refreshToken());
    print('lcicked button');
  }

  void onTokenStatusChanged() {
    notifyListeners();
  }

  bool get isBusy => tokenRepository.status == TokenStatus.refreshing;

  @override
  void dispose() {
    tokenRepository.tokenStatusListenable.removeListener(onTokenStatusChanged);
    super.dispose();
  }
}
