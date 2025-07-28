import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/core/utils/user_role.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'form_provider.g.dart';

final formKeyProvider = StateProvider((ref) => GlobalKey<FormState>());
final keyControllerProvider = StateProvider((ref) => TextEditingController());
final idControllerProvider = StateProvider((ref) => TextEditingController());

@riverpod
class SelectedRole extends _$SelectedRole {
  @override
  UserRole? build() {
    return null;
  }

  void change(UserRole? role) {
    state = role;
  }
}
