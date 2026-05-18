# Skill: Flutter Form Patterns

Standard form patterns for BuilderBridge. Used in: login, OTP, ticket creation, booking confirmation.

## 1. Standard Form Structure

```dart
class CreateTicketScreen extends ConsumerStatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  ConsumerState<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends ConsumerState<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(createTicketNotifierProvider.notifier).submit(
      CreateTicketRequest(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
      ),
    );
    if (!mounted) return;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final submitState = ref.watch(createTicketNotifierProvider);
    return Scaffold(
      appBar: BBAppBar(title: 'New Support Ticket'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            BBTextField(
              controller: _titleController,
              label: 'Issue Title',
              validator: (v) => (v?.trim().isEmpty ?? true) ? 'Title required' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            BBTextField(
              controller: _descController,
              label: 'Description',
              maxLines: 4,
              validator: (v) => (v?.trim().isEmpty ?? true) ? 'Description required' : null,
            ),
            const SizedBox(height: AppSpacing.xl),
            BBButton(
              label: 'Submit Ticket',
              isLoading: submitState.isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
```

## 2. BBTextField Widget

```dart
class BBTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final FormFieldValidator<String>? validator;
  final int maxLines;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  const BBTextField({
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
    );
  }
}
```

## 3. Phone + OTP Pattern

```dart
// Phone field: numeric only, length validation
BBTextField(
  controller: _phoneController,
  label: 'Mobile Number',
  keyboardType: TextInputType.phone,
  textInputAction: TextInputAction.done,
  validator: (v) {
    if (v == null || v.trim().length != 10) return 'Enter 10-digit mobile number';
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v.trim())) return 'Invalid mobile number';
    return null;
  },
)

// OTP: 6 digits, auto-submit
BBOtpField(
  onCompleted: (otp) => ref.read(authNotifierProvider.notifier).verifyOtp(otp),
)
```

## 4. Error Handling in Forms

```dart
// Show API/DB errors as SnackBar (not inline)
ref.listen(createTicketNotifierProvider, (_, next) {
  next.whenOrNull(
    error: (e, _) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed: ${e.toString()}'), backgroundColor: AppColors.danger),
    ),
  );
});
```

## Rules
- `autovalidateMode: AutovalidateMode.onUserInteraction` — validate on blur not submit
- Always `dispose()` TextEditingControllers
- Never modify state after `await` without `if (!mounted) return`
- Submit button shows `isLoading` during async operation
- Form errors shown inline; API errors shown as SnackBar
