import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class AppException implements Exception {
  void onException();
}

class NoInternetException extends AppException {
  String message;

  NoInternetException(this.message);

  @override
  void onException() {
    debugPrint(message);
  }
}

class CustomException extends AppException {
  String message;

  CustomException(this.message);

  @override
  void onException() {
    debugPrint(message);
  }
}
