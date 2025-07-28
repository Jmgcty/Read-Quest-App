import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/constants/app_colors.dart';

class CStrokeButton extends StatelessWidget {
  CStrokeButton({
    super.key,
    required this.title,
    this.onPressed,
    this.buttonColor,
    this.foregroundColor,
    this.fixedSize,
    this.textStyle,
    this.isLoading,
  });

  bool? isLoading;
  final String title;
  final VoidCallback? onPressed;
  final Color? buttonColor;
  final Color? foregroundColor;
  final Size? fixedSize;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: theme.elevatedButtonTheme.style!.copyWith(
        side: WidgetStatePropertyAll(
            BorderSide(color: foregroundColor ?? AppColors.secondary)),
        fixedSize: WidgetStatePropertyAll(
            fixedSize ?? Size(size.width * 0.8, size.height * 0.066)),
        backgroundColor: WidgetStatePropertyAll(buttonColor?.withOpacity(0.2) ??
            AppColors.secondary.withOpacity(0.2)),
      ),
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
