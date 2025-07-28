import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/constants/app_colors.dart';

class CPrimaryButton extends StatelessWidget {
  const CPrimaryButton({
    super.key,
    required this.title,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.fixedSize,
    this.textStyle,
    this.isLoading,
  });

  final String title;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Size? fixedSize;
  final TextStyle? textStyle;
  final bool? isLoading;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: theme.elevatedButtonTheme.style!.copyWith(
          fixedSize: WidgetStatePropertyAll(
              fixedSize ?? Size(size.width * 0.8, size.height * 0.066)),
          backgroundColor: backgroundColor != null
              ? isLoading == true
                  ? WidgetStatePropertyAll(backgroundColor?.withOpacity(0.54))
                  : WidgetStatePropertyAll(backgroundColor)
              : null),
      onPressed: isLoading == true ? null : onPressed,
      child: isLoading == true
          ? Row(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(
                width: size.width * 0.05,
                height: size.width * 0.05,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: foregroundColor ?? AppColors.white,
                ),
              ),
              Gap(size.width * 0.03),
              Text(
                title,
                style: textStyle ??
                    theme.textTheme.headlineSmall!.copyWith(
                      color: foregroundColor ?? AppColors.white,
                      fontSize: size.height * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ])
          : Text(
              title,
              style: textStyle ??
                  theme.textTheme.headlineSmall!.copyWith(
                    color: foregroundColor ?? AppColors.white,
                    fontSize: size.height * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
            ),
    );
  }
}
