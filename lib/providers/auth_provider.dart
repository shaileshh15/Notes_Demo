import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<bool> hasPin() async {
    return await _storage.containsKey(key: 'pin');
  }

  Future<void> setPin(String pin) async {
    final hashedPin = sha256.convert(utf8.encode(pin)).toString();
    await _storage.write(key: 'pin', value: hashedPin);
  }

  Future<bool> verifyPin(String pin) async {
    final hashedPin = sha256.convert(utf8.encode(pin)).toString();
    final storedHash = await _storage.read(key: 'pin');
    if (storedHash == hashedPin) {
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> resetAll() async {
    await _storage.deleteAll();
    _isAuthenticated = false;
    notifyListeners();
  }
}
