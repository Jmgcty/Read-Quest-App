import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_form_provider.g.dart';

/// GlobalKey<FormState> for the login form
final loginFormKeyProvider = Provider<GlobalKey<FormState>>((ref) {
  return GlobalKey<FormState>();
});

/// TextEditingController for the email field
final emailControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});

/// TextEditingController for the password field
final passwordControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});

@riverpod
class LoginShowPassword extends _$LoginShowPassword {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

@riverpod
class LoginServerValidation extends _$LoginServerValidation {
  @override
  Map<String, dynamic> build() => Map<String, String>.from({});

  void reset() => state = Map<String, dynamic>.from({});
  void setError(Map<String, dynamic> value) => state = value;
}
