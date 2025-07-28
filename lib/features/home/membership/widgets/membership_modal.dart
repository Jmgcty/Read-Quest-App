import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:read_quest/core/constants/app_colors.dart';

import 'package:read_quest/core/utils/user_role.dart';
import 'package:read_quest/routing/app_router.dart';
import 'package:read_quest/shared/widgets/primary_button.dart';

import '../../../../core/loader/loading_provider.dart';

import '../../../../core/services/database/institution/institution_provider.dart';
import '../../../../core/services/database/institution/institution_service.dart';
import '../../../../core/services/shared_preferences/shared_pref_enum.dart';
import '../../../../core/services/shared_preferences/shared_pref_helper.dart';
import '../../../../core/utils/formatter.dart';
import '../../../../core/widgets/dialogs/error_dialog.dart';
import '../../../../core/widgets/dialogs/success_modal.dart';
import '../../../../routing/route_names.dart';
import '../provider/form_provider.dart';

Future<void> showAssignKeyDialog(BuildContext context) async {
  final theme = Theme.of(context);
  final size = MediaQuery.of(context).size;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Consumer(builder: (context, ref, child) {
            final formKey = ref.watch(formKeyProvider);
            final keyController = ref.watch(keyControllerProvider);
            final idController = ref.watch(idControllerProvider);
            // final selectedRole = ref.watch(selectedRoleProvider);
            // final selectedRoleNotifier =
            //     ref.read(selectedRoleProvider.notifier);

            final isLoading = ref.watch(loadingProvider);

            //
            return Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: AlertDialog(
                  title: const Text(
                    'Join Organization',
                    textAlign: TextAlign.center,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(size.width * 0.05),
                  ),
                  insetPadding: EdgeInsets.all(size.width * 0.05),
                  content: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Key input
                        TextFormField(
                          readOnly: isLoading,
                          controller: keyController,
                          decoration: const InputDecoration(
                            labelText: 'Key',
                            border: OutlineInputBorder(),
                          ),
                          validator: validationKey,
                        ),
                        Gap(size.height * 0.02),

                        // ID input
                        TextFormField(
                          readOnly: isLoading,
                          controller: idController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'ID',
                            border: OutlineInputBorder(),
                          ),
                          validator: validationId,
                        ),
                        Gap(size.height * 0.02),

                        // Role dropdown
                        // DropdownButtonFormField<UserRole>(
                        //   borderRadius:
                        //       BorderRadius.circular(size.width * 0.02),
                        //   value: selectedRole,
                        //   items: UserRole.values.map((role) {
                        //     return DropdownMenuItem(
                        //       value: role,
                        //       child: Text(role.label),
                        //     );
                        //   }).toList(),
                        //   onChanged: isLoading == true
                        //       ? null
                        //       : (role) {
                        //           selectedRoleNotifier.change(role);
                        //         },
                        //   decoration: const InputDecoration(
                        //     labelText: 'Role',
                        //     border: OutlineInputBorder(),
                        //   ),
                        //   validator: (value) =>
                        //       value == null ? 'Please select a role' : null,
                        // ),
                      ],
                    ),
                  ),
                  actionsOverflowButtonSpacing: size.width * 0.02,
                  actions: [
                    // Assign button
                    CPrimaryButton(
                      isLoading: isLoading,
                      title: isLoading ? 'Joining...' : 'Join',
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      textStyle: theme.textTheme.titleMedium!.copyWith(
                        color: AppColors.white,
                      ),
                      onPressed: isLoading == true
                          ? null
                          : () => sendJoinRequest(context, ref),
                    ),

                    // Cancel button
                    TextButton(
                      onPressed: isLoading == true
                          ? null
                          : () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                        fixedSize: Size(size.width, size.height * 0.066),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(size.width * 0.02),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      );
    },
  );
}

String? validationKey(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a key';
  }
  return null;
}

String? validationId(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter an ID';
  }
  return null;
}

void sendJoinRequest(BuildContext context, WidgetRef ref) async {
  final formKey = ref.watch(formKeyProvider);
  final keyController = ref.watch(keyControllerProvider);
  final idController = ref.watch(idControllerProvider);

  final loading = ref.read(loadingProvider.notifier);

  loading.setLoading(true);
  if (!formKey.currentState!.validate()) {
    loading.setLoading(false);
    return;
  }

  final userId = await SharedPrefHelper.get(SharedPrefKey.userID) ?? 0;
  final value = await InstitutionService.joinInstitution(
      key: keyController.text,
      institutionID: idController.text,
      userID: userId);

  if (value['status'] == 'success') {
    loading.setLoading(false);
    await SharedPrefHelper.set(
        SharedPrefKey.institutionKey, value['data']['token']);
    await SharedPrefHelper.set(SharedPrefKey.userRole, value['data']['role']);

    //
    await showSuccessDialog(
        context, formatToUppercaseFirstLetter(value['message']));

    if (value['data']['role'] == UserRole.admin.name ||
        value['data']['role'] == UserRole.teacher.name) {
      Navigator.pop(context);
      context.goNamed(RouteNames.dashboard.name);
    } else {
      Navigator.pop(context);
      context.goNamed(RouteNames.home.name);
    }

    return;
  }

  loading.setLoading(false);
  await showErrorDialog(context, formatToUppercaseFirstLetter(value['error']));
}
