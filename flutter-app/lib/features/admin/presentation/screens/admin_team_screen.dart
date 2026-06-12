import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_badge.dart';
import 'package:builder_bridge/core/widgets/bb_button.dart';
import 'package:builder_bridge/core/widgets/bb_card.dart';
import 'package:builder_bridge/core/widgets/bb_empty_state.dart';
import 'package:builder_bridge/core/widgets/bb_error_state.dart';
import 'package:builder_bridge/core/widgets/bb_loading_state.dart';
import 'package:builder_bridge/features/admin/data/models/admin_user_model.dart';
import 'package:builder_bridge/features/admin/presentation/providers/admin_providers.dart';

class AdminTeamScreen extends ConsumerStatefulWidget {
  const AdminTeamScreen({super.key});

  @override
  ConsumerState<AdminTeamScreen> createState() => _AdminTeamScreenState();
}

class _AdminTeamScreenState extends ConsumerState<AdminTeamScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(adminUsersProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Team', style: AppTypography.labelLarge),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: BBButton(
              label: 'Add Member',
              leadingIcon: Icons.person_add_outlined,
              fullWidth: false,
              onPressed: () => _showMemberDialog(context),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _FilterBar(
            selected: _filter,
            onChanged: (f) => setState(() => _filter = f),
            users: usersAsync.valueOrNull ?? [],
          ),
          Expanded(
            child: usersAsync.when(
              loading: () => const BBLoadingState(),
              error: (_, __) =>
                  const BBErrorState(message: 'Could not load team members'),
              data: (users) {
                final filtered = _applyFilter(users);
                if (filtered.isEmpty) {
                  return BBEmptyState(
                    icon: Icons.group_outlined,
                    message: _filter == 'all'
                        ? 'No team members yet.'
                        : 'No $_filter members.',
                    ctaLabel: _filter == 'all' ? 'Add Member' : null,
                    onCta: _filter == 'all'
                        ? () => _showMemberDialog(context)
                        : null,
                  );
                }
                return _TeamList(users: filtered);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<AdminUserModel> _applyFilter(List<AdminUserModel> users) {
    return switch (_filter) {
      'all' => users,
      'active' => users.where((u) => u.isActive).toList(),
      'inactive' => users.where((u) => !u.isActive).toList(),
      _ => users.where((u) => u.role == _filter).toList(),
    };
  }

  void _showMemberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _MemberDialog(
        onSave: (name, email, phone, role) {
          ref.read(adminUserNotifierProvider.notifier).createUser(
                name: name,
                email: email,
                phone: phone,
                role: role,
              );
        },
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  final List<AdminUserModel> users;

  const _FilterBar({
    required this.selected,
    required this.onChanged,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    final roleCounts = <String, int>{};
    int active = 0;
    int inactive = 0;
    for (final u in users) {
      roleCounts[u.role] = (roleCounts[u.role] ?? 0) + 1;
      if (u.isActive) {
        active++;
      } else {
        inactive++;
      }
    }

    final filters = [
      ('all', 'All', users.length),
      ('active', 'Active', active),
      ('owner', 'Owner', roleCounts['owner'] ?? 0),
      ('manager', 'Manager', roleCounts['manager'] ?? 0),
      ('sales', 'Sales', roleCounts['sales'] ?? 0),
      ('viewer', 'Viewer', roleCounts['viewer'] ?? 0),
      ('inactive', 'Inactive', inactive),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters
              .map((f) => Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: ChoiceChip(
                      label: Text('${f.$2} (${f.$3})',
                          style: AppTypography.labelSmall),
                      selected: selected == f.$1,
                      onSelected: (_) => onChanged(f.$1),
                      selectedColor: AppColors.accentSoft,
                      backgroundColor: AppColors.surface,
                      side: const BorderSide(color: AppColors.line),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class _TeamList extends ConsumerWidget {
  final List<AdminUserModel> users;
  const _TeamList({required this.users});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: users.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, i) => _MemberCard(user: users[i]),
    );
  }
}

class _MemberCard extends ConsumerWidget {
  final AdminUserModel user;
  const _MemberCard({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleBadge = switch (user.adminRole) {
      AdminRole.owner => BBBadgeStatus.info,
      AdminRole.manager => BBBadgeStatus.warn,
      AdminRole.sales => BBBadgeStatus.ok,
      AdminRole.viewer => BBBadgeStatus.neutral,
    };

    return BBCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor:
                user.isActive ? AppColors.accentSoft : AppColors.surfaceMute,
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
              style: AppTypography.labelLarge.copyWith(
                color: user.isActive ? AppColors.accent : AppColors.inkMute,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(user.name, style: AppTypography.labelLarge),
                    const SizedBox(width: AppSpacing.sm),
                    if (!user.isActive)
                      const BBBadge(
                          label: 'Inactive', status: BBBadgeStatus.neutral),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(user.email, style: AppTypography.bodySmall),
                if (user.phone.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(user.phone, style: AppTypography.bodySmall),
                ],
              ],
            ),
          ),
          BBBadge(label: user.roleLabel, status: roleBadge),
          const SizedBox(width: AppSpacing.sm),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.inkMute),
            onSelected: (action) => _onAction(action, context, ref),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(
                value: 'toggle',
                child: Text(user.isActive ? 'Deactivate' : 'Activate'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onAction(String action, BuildContext context, WidgetRef ref) {
    if (action == 'toggle') {
      ref.read(adminUserNotifierProvider.notifier).updateUser(
            user.id,
            isActive: !user.isActive,
          );
    } else if (action == 'edit') {
      showDialog(
        context: context,
        builder: (_) => _MemberDialog(
          existing: user,
          onSave: (name, email, phone, role) {
            ref.read(adminUserNotifierProvider.notifier).updateUser(
                  user.id,
                  name: name,
                  email: email,
                  phone: phone,
                  role: role,
                );
          },
        ),
      );
    }
  }
}

class _MemberDialog extends StatefulWidget {
  final AdminUserModel? existing;
  final void Function(String name, String email, String phone, String role)
      onSave;

  const _MemberDialog({this.existing, required this.onSave});

  @override
  State<_MemberDialog> createState() => _MemberDialogState();
}

class _MemberDialogState extends State<_MemberDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late String _role;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?.name ?? '');
    _emailCtrl = TextEditingController(text: widget.existing?.email ?? '');
    _phoneCtrl = TextEditingController(text: widget.existing?.phone ?? '');
    _role = widget.existing?.role ?? 'viewer';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(
        isEdit ? 'Edit Member' : 'Add Member',
        style: AppTypography.headlineSmall,
      ),
      content: SizedBox(
        width: 380,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('NAME'),
              const SizedBox(height: AppSpacing.xs),
              TextFormField(
                controller: _nameCtrl,
                decoration:
                    const InputDecoration(hintText: 'e.g. Ravi Kumar'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              _label('EMAIL'),
              const SizedBox(height: AppSpacing.xs),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    const InputDecoration(hintText: 'e.g. ravi@builder.in'),
                validator: (v) =>
                    (v == null || !v.contains('@')) ? 'Valid email required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              _label('PHONE (OPTIONAL)'),
              const SizedBox(height: AppSpacing.xs),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration:
                    const InputDecoration(hintText: 'e.g. 9876543210'),
              ),
              const SizedBox(height: AppSpacing.md),
              _label('ROLE'),
              const SizedBox(height: AppSpacing.xs),
              DropdownButtonFormField<String>(
                value: _role,
                items: AdminRole.values
                    .map((r) => DropdownMenuItem(
                          value: r.name,
                          child: Text(_roleName(r.name),
                              style: AppTypography.bodyMedium),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _role = v);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel',
              style: AppTypography.labelMedium
                  .copyWith(color: AppColors.inkMute)),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(isEdit ? 'Save' : 'Add'),
        ),
      ],
    );
  }

  Widget _label(String text) => Text(
        text,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.inkFaint,
          letterSpacing: 0.6,
        ),
      );

  String _roleName(String role) => switch (role) {
        'owner' => 'Owner',
        'manager' => 'Manager',
        'sales' => 'Sales',
        _ => 'Viewer',
      };

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.onSave(
      _nameCtrl.text.trim(),
      _emailCtrl.text.trim(),
      _phoneCtrl.text.trim(),
      _role,
    );
    Navigator.pop(context);
  }
}
