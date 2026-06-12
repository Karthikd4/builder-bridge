import 'package:flutter/material.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_spacing.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/core/widgets/bb_button.dart';
import 'package:builder_bridge/core/widgets/bb_logo.dart';

class AdminLoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  const AdminLoginScreen({required this.onLoginSuccess, super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() { _isLoading = true; _error = null; });

    await Future.delayed(const Duration(milliseconds: 400));

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email == 'admin@builderbridge.in' && password == 'admin123') {
      widget.onLoginSuccess();
    } else {
      setState(() {
        _isLoading = false;
        _error = 'Invalid email or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        const BBLogo(size: 48),
                        const SizedBox(height: AppSpacing.sm),
                        Text('BuilderBridge',
                            style: AppTypography.headlineMedium),
                        const SizedBox(height: AppSpacing.xs),
                        Text('Admin Portal',
                            style: AppTypography.labelMedium
                                .copyWith(color: AppColors.inkMute)),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text('Sign in', style: AppTypography.headlineSmall),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Enter your credentials to access the dashboard.',
                      style: AppTypography.bodyMedium
                          .copyWith(color: AppColors.inkMute)),
                  const SizedBox(height: AppSpacing.xl),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'admin@builderbridge.in',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Email is required';
                      }
                      if (!v.contains('@')) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: '••••••••',
                    obscure: _obscurePassword,
                    prefixIcon: Icons.lock_outlined,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                        color: AppColors.inkMute,
                      ),
                      onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.dangerSoft,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              size: 16, color: AppColors.danger),
                          const SizedBox(width: AppSpacing.sm),
                          Text(_error!,
                              style: AppTypography.bodySmall
                                  .copyWith(color: AppColors.danger)),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.infoSoft,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            size: 16, color: AppColors.accent),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Demo — admin@builderbridge.in / admin123',
                          style: AppTypography.bodySmall
                              .copyWith(color: AppColors.accent),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  BBButton(
                    label: 'Sign in',
                    isLoading: _isLoading,
                    onPressed: _login,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Center(
                    child: Text(
                      '© BuilderBridge · Admin access only',
                      style: TextStyle(
                          fontSize: 11, color: AppColors.inkFaint),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelMedium),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscure,
          style: AppTypography.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                AppTypography.bodyLarge.copyWith(color: AppColors.inkFaint),
            prefixIcon:
                Icon(prefixIcon, size: 20, color: AppColors.inkMute),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: const BorderSide(color: AppColors.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: const BorderSide(color: AppColors.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide:
                  const BorderSide(color: AppColors.accent, width: 2),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
