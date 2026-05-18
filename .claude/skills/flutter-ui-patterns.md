# Skill: Flutter UI Patterns

Standard UI widget patterns for BuilderBridge design system.

## 1. BBButton

```dart
// lib/core/widgets/bb_button.dart
enum BBButtonVariant { primary, secondary, ghost, danger }

class BBButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final BBButtonVariant variant;
  final bool isLoading;
  final IconData? leadingIcon;

  const BBButton({
    required this.label,
    this.onPressed,
    this.variant = BBButtonVariant.primary,
    this.isLoading = false,
    this.leadingIcon,
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
              if (leadingIcon != null) ...[Icon(leadingIcon, size: 18), const SizedBox(width: 8)],
              Text(label),
            ],
          );

    return switch (variant) {
      BBButtonVariant.primary => FilledButton(onPressed: isLoading ? null : onPressed, child: child),
      BBButtonVariant.secondary => OutlinedButton(onPressed: isLoading ? null : onPressed, child: child),
      BBButtonVariant.ghost => TextButton(onPressed: isLoading ? null : onPressed, child: child),
      BBButtonVariant.danger => FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
    };
  }
}
```

## 2. BBCard

```dart
class BBCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const BBCard({required this.child, this.padding, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.md),
          child: child,
        ),
      ),
    );
  }
}
```

## 3. BBBadge (Status Chips)

```dart
enum BBBadgeStatus { ok, warn, danger, neutral, info }

class BBBadge extends StatelessWidget {
  final String label;
  final BBBadgeStatus status;

  const BBBadge({required this.label, this.status = BBBadgeStatus.neutral, super.key});

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      BBBadgeStatus.ok      => (AppColors.ok.withOpacity(0.12), AppColors.ok),
      BBBadgeStatus.warn    => (AppColors.warn.withOpacity(0.12), AppColors.warn),
      BBBadgeStatus.danger  => (AppColors.danger.withOpacity(0.12), AppColors.danger),
      BBBadgeStatus.info    => (AppColors.accent.withOpacity(0.12), AppColors.accent),
      BBBadgeStatus.neutral => (AppColors.inkFaint.withOpacity(0.3), AppColors.inkMute),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: AppTypography.labelSmall.copyWith(color: fg)),
    );
  }
}
```

## 4. BBLoadingState (Skeleton)

```dart
class BBLoadingState extends StatelessWidget {
  const BBLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, __) => const _SkeletonCard(),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.line,
      highlightColor: AppColors.surface,
      child: Container(height: 80, decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      )),
    );
  }
}
```

## 5. BBEmptyState

```dart
class BBEmptyState extends StatelessWidget {
  final String message;
  final String? ctaLabel;
  final VoidCallback? onCta;

  const BBEmptyState({required this.message, this.ctaLabel, this.onCta, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: AppColors.inkFaint),
            const SizedBox(height: AppSpacing.md),
            Text(message, style: AppTypography.bodyMedium.copyWith(color: AppColors.inkMute), textAlign: TextAlign.center),
            if (ctaLabel != null && onCta != null) ...[
              const SizedBox(height: AppSpacing.lg),
              BBButton(label: ctaLabel!, onPressed: onCta, variant: BBButtonVariant.secondary),
            ],
          ],
        ),
      ),
    );
  }
}
```

## Rules
- All status colors via `BBBadge` — never custom containers for status
- All loading states use `BBLoadingState` — never raw `CircularProgressIndicator` on full screen
- All cards use `BBCard` — never custom `Container` with decoration
- `const` constructors on all widgets with no dynamic data
