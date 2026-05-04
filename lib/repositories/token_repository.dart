import 'dart:async';

import 'package:asvz_autosignup/repositories/credentials_repository.dart';
import 'package:asvz_autosignup/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

enum TokenStatus { none, refreshing, valid, expired, error }

class TokenRepository {
  final CredentialsRepository credentialsRepository;

  // Private attributes
  final ValueNotifier<TokenStatus> _statusNotifier = ValueNotifier<TokenStatus>(TokenStatus.none);
  String? _token;
  DateTime? _tokenAcquiredAt;
  String? _errorMessage;

  TokenRepository({required this.credentialsRepository});

  // Public getters
  ValueListenable<TokenStatus> get tokenStatusListenable => _statusNotifier;
  TokenStatus get status => _statusNotifier.value;
  String? get token => _token;
  DateTime? get tokenAcquiredAt => _tokenAcquiredAt;
  String? get errorMessage => _errorMessage;

  /* sets status of token. Handles possible transitions when status updates.
  Notifies UI of status change via ValueListenable<TokenStatus> */
  void _setStatus(TokenStatus status) {
    _statusNotifier.value = status;
  }

  /* Token expires after 2 hours. Force a refresh a bit earlier. */
  DateTime? get tokenExpiresAt =>
      _tokenAcquiredAt?.add(Duration(hours: 1, minutes: 55));

  Future<void> _refreshToken() async {
    _setStatus(TokenStatus.refreshing);
    try {
      _token = await updateAccessToken(credentialsRepository.credentials);
      _errorMessage = null;
      _tokenAcquiredAt = DateTime.now();
      unawaited(expiryTimer());
      _setStatus(TokenStatus.valid);
    } catch (e) {
      _token = null;
      _errorMessage = e.toString();
      _tokenAcquiredAt = DateTime.now();
      _setStatus(TokenStatus.error);
    }
  }

  Future<void> waitUntil(DateTime until) async {
    Duration duration = until.difference(DateTime.now());
    await Future.delayed(duration.isNegative ? Duration.zero : duration);
  }

  Future<void> expiryTimer() async { // problem with this. If device (at least windows) sleeps, the timer fires early.
    await waitUntil(tokenExpiresAt!);
    checkTokenValid();
  }

  Future<void>? _refreshingFuture;

  /* Async function to refresh the token. Sets appropriate state depending on outcome. */
  Future<void> refreshToken() async {
    final f = _refreshingFuture ??= _refreshToken();
    try {
      await f;
    } finally {
      if (identical(_refreshingFuture, f)) _refreshingFuture = null; // Identical check to prevent race conditions.
    }
  }

  /* For most usages when a token is required, this is the appropriate function to call.
  Checks if we have a valid token and if not gets a valid token and finally returns it.
  TODO: What if refreshToken fails and _token is null?
  Now return type is nullable String, maybe instead non-nullable but throw Exception?
  Not sure */
  Future<String> ensureToken() async {
    // Precheck if we are already in error.
    if (status == TokenStatus.error) {
      throw Exception("Token status is in error state. Need manual refresh or restart.");
    }
    if (!checkTokenValid()) {
      await refreshToken();
    }
    // Check if we entered error status, otherwise we have token.
    if (status == TokenStatus.error) {
      throw Exception("Token status is in error state. Need manual refresh or restart.");
    }
    return _token!;
  }

  /* check if status of token is still valid if it was valid (i.e. transition valid -> expired)
  Any other token status update is handled by the _ensureToken function  */
  bool checkTokenValid() {
    print('check token status (now $status)');
    if (status != TokenStatus.valid) return false;
    // if status is valid, then _tokenAcquiredAt is guaranteed not null
    if (DateTime.now().isAfter(tokenExpiresAt!)) {
      print('after expiry data, changing to expired.');
      _setStatus(TokenStatus.expired);
      return false;
    }
    print(
      'Valid token acq at: ${DateFormat('HH:mm:ss').format(_tokenAcquiredAt!)}. Expries at ${DateFormat('HH:mm:ss').format(tokenExpiresAt!)}. Now is ${DateFormat('HH:mm:ss').format(DateTime.now())}',
    );
    return true;
  }

  void clearToken() {
    _token = null;
    _tokenAcquiredAt = null;
    _errorMessage = null;
    _setStatus(TokenStatus.none);
  }
}
