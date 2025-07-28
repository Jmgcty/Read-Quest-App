import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

Future<bool?> showCancelConfirmationModal(
  BuildContext context, {
  String title = 'Cancel Request?',
  String description =
      'Are you sure you want to cancel? This action cannot be undone.',
  String confirmText = 'Yes, Cancel',
  String cancelText = 'No',
}) {
  final theme = Theme.of(context);

  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        title,
        style: theme.textTheme.headlineSmall,
      ),
      content: Text(
        description,
        style: theme.textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          child: Text(cancelText),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: Colors.white,
          ),
          child: Text(confirmText),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}
