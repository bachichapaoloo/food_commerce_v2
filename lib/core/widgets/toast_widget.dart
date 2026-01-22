import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

class AppToast {
  AppToast._();

  // ---------------------------
  // TEXT STYLES (CENTRALIZED)
  // ---------------------------
  static const TextStyle _titleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.2,
  );

  static const TextStyle _messageStyle = TextStyle(fontSize: 14, color: Colors.white70, height: 1.3);

  static Widget _title(String text) => Text(text, style: _titleStyle, maxLines: 1, overflow: TextOverflow.ellipsis);

  static Widget _message(String text) => Text(text, style: _messageStyle, maxLines: 2, overflow: TextOverflow.ellipsis);

  // ---------------------------
  // SUCCESS
  // ---------------------------
  static void success(
    BuildContext context, {
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 1),
    Duration animationDuration = const Duration(milliseconds: 500),
  }) {
    MotionToast.success(
      title: _title(title),
      description: _message(message),
      animationType: AnimationType.slideInFromLeft,
      toastAlignment: Alignment.topRight,
      dismissable: true,
      toastDuration: duration,
      animationDuration: animationDuration,
    ).show(context);
  }

  // ---------------------------
  // ERROR
  // ---------------------------
  static void error(
    BuildContext context, {
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 4),
    Duration animationDuration = const Duration(milliseconds: 500),
  }) {
    MotionToast.error(
      title: _title(title),
      description: _message(message),
      animationType: AnimationType.slideInFromLeft,
      toastAlignment: Alignment.topRight,
      dismissable: true,
      toastDuration: duration,
      animationDuration: animationDuration,
    ).show(context);
  }

  // ---------------------------
  // WARNING
  // ---------------------------
  static void warning(BuildContext context, {required String title, required String message}) {
    MotionToast.warning(
      title: _title(title),
      description: _message(message),
      animationType: AnimationType.slideInFromLeft,
      toastAlignment: Alignment.topRight,
      dismissable: true,
    ).show(context);
  }

  // ---------------------------
  // INFO
  // ---------------------------
  static void info(BuildContext context, {required String title, required String message}) {
    MotionToast.info(
      title: _title(title),
      description: _message(message),
      animationType: AnimationType.slideInFromLeft,
      toastAlignment: Alignment.topRight,
      dismissable: true,
    ).show(context);
  }
}
