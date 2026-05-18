import 'package:flutter/material.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';

class BBLogo extends StatelessWidget {
  final double size;

  const BBLogo({this.size = 64, super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.cottage_outlined,
      size: size,
      color: AppColors.accent,
    );
  }
}
