import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';

class OtpInputRow extends StatefulWidget {
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChange;
  final bool enabled;

  const OtpInputRow({
    required this.onCompleted,
    this.onChange,
    this.enabled = true,
    super.key,
  });

  @override
  State<OtpInputRow> createState() => _OtpInputRowState();
}

class _OtpInputRowState extends State<OtpInputRow> {
  static const _length = 6;
  final _controllers = List.generate(_length, (_) => TextEditingController());
  final _focusNodes = List.generate(_length, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'\D'), '').split('');
      for (int i = 0; i < _length && i < digits.length; i++) {
        _controllers[i].text = digits[i];
      }
      final next = digits.length < _length ? digits.length : _length - 1;
      _focusNodes[next].requestFocus();
    } else if (value.isNotEmpty) {
      if (index < _length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }

    final otp = _controllers.map((c) => c.text).join();
    widget.onChange?.call(otp);
    if (otp.length == _length) widget.onCompleted(otp);
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_length, (i) {
        final isLast = i == _length - 1;
        return Padding(
          padding: EdgeInsets.only(right: isLast ? 0 : 8),
          child: _OtpBox(
            controller: _controllers[i],
            focusNode: _focusNodes[i],
            enabled: widget.enabled,
            onChanged: (v) => _onChanged(i, v),
            onKeyEvent: (e) => _onKeyEvent(i, e),
          ),
        );
      }),
    );
  }
}

class _OtpBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final ValueChanged<KeyEvent> onKeyEvent;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.onChanged,
    required this.onKeyEvent,
  });

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  // Separate FocusNode for KeyboardListener — not the input focus node
  final _keyListenerFocus = FocusNode();
  bool _focused = false;

  void _onFocusChange() => setState(() => _focused = widget.focusNode.hasFocus);

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    _keyListenerFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _keyListenerFocus,
      onKeyEvent: widget.onKeyEvent,
      child: Container(
        width: 44,
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _focused ? AppColors.accent : AppColors.line,
            width: _focused ? 2 : 1,
          ),
          boxShadow: _focused
              ? [
                  const BoxShadow(
                    color: AppColors.accentSoft,
                    blurRadius: 0,
                    spreadRadius: 3,
                  )
                ]
              : null,
        ),
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          enabled: widget.enabled,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
