// lib/shared/widgets/dashboard_box_button.dart

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:read_quest/core/constants/app_colors.dart';

class DashboardBoxButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const DashboardBoxButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(size.width * 0.05),
          alignment: Alignment.center,
          color: AppColors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: size.height * 0.06,
                color: AppColors.secondary,
              ),
              const Gap(5),
              Text(
                label,
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
