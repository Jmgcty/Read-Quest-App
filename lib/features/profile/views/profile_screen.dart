import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:read_quest/core/services/authentication/auth_helper.dart';
import 'package:read_quest/shared/widgets/primary_button.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/loader/loading_provider.dart';
import '../../../core/services/shared_preferences/shared_pref_helper.dart';
import '../../../routing/route_names.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  void signOut() async {
    final loading = ref.read(loadingProvider.notifier);
    loading.setLoading(true);
    final value = await AuthHelper.logout();

    if (value['status'] == 'success') {
      await SharedPrefHelper.clear();
      loading.setLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(value['message']),
      ));
      context.goNamed(RouteNames.login.name);
    } else {
      loading.setLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(value['message']),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: CPrimaryButton(
          isLoading: isLoading,
          backgroundColor: AppColors.error,
          textStyle:
              theme.textTheme.titleLarge!.copyWith(color: AppColors.white),
          title: isLoading ? 'Signing out...' : 'Log out',
          onPressed: signOut,
        ),
      ),
    );
  }
}
