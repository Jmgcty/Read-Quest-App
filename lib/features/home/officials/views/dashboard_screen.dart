import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:read_quest/core/constants/app_colors.dart';

import '../../../../routing/route_names.dart';
import '../widgets/dashboard_box_button.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05,
          vertical: size.height * 0.02,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              color: AppColors.white,
              child: ListTile(
                title: const Text('Manage Keys'),
                leading: const Icon(Icons.key),
                onTap: () {},
              ),
            ),
            Gap(size.height * 0.05),
            Row(
              children: [
                DashboardBoxButton(
                  label: 'Leaderboard',
                  icon: Icons.leaderboard,
                  onTap: () {},
                ),
                Gap(size.height * 0.02),
                DashboardBoxButton(
                  label: 'Reading Modules',
                  icon: Icons.book,
                  onTap: () {
                    context.goNamed(RouteNames.modules.name);
                  },
                ),
              ],
            ),
            Gap(size.height * 0.02),
            Row(
              children: [
                // ✅ Use the reusable widget here
                DashboardBoxButton(
                  label: 'Manage Students',
                  icon: Icons.person,
                  onTap: () {},
                ),
                Gap(size.height * 0.02),
                DashboardBoxButton(
                  label: 'Manage Teachers',
                  icon: Icons.person,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
