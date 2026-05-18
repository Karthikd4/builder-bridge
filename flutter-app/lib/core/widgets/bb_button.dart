import 'package:flutter/material.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';

enum BBButtonVariant { primary, secondary, ghost, danger }

class BBButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final BBButtonVariant variant;
  final bool isLoading;
  final IconData? leadingIcon;
  final bool fullWidth;

  const BBButton({
    required this.label,
    this.onPressed,
    this.variant = BBButtonVariant.primary,
    this.isLoading = false,
    this.leadingIcon,
    this.fullWidth = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    final size = fullWidth
        ? const Size.fromHeight(48)
        : const Size(0, 48);

    return switch (variant) {
      BBButtonVariant.primary => FilledButton(
          style: FilledButton.styleFrom(minimumSize: size),
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
      BBButtonVariant.secondary => OutlinedButton(
          style: OutlinedButton.styleFrom(minimumSize: size),
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
      BBButtonVariant.ghost => TextButton(
          style: TextButton.styleFrom(minimumSize: size),
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
      BBButtonVariant.danger => FilledButton(
          style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger, minimumSize: size),
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
    };
  }
}
