import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signup_form_provider.g.dart';

/// GlobalKey<FormState> for the sign up form
final signUpFormKeyProvider = Provider<GlobalKey<FormState>>((ref) {
  return GlobalKey<FormState>();
});

/// TextEditingController for the name field
final nameControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
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

/// TextEditingController for the confirm password field
final confirmPasswordControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});

@riverpod
class SignupShowPassword extends _$SignupShowPassword {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

@riverpod
class SignupServerValidation extends _$SignupServerValidation {
  @override
  Map<String, dynamic> build() => Map<String, dynamic>.from({});

  void reset() => state = Map<String, dynamic>.from({});
  void setError(Map<String, dynamic> value) => state = value;
}
