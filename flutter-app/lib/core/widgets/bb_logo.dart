import 'package:flutter/material.dart';

class BBLogo extends StatelessWidget {
  final double size;
  final bool inverted;

  const BBLogo({this.size = 64, this.inverted = false, super.key});

  @override
  Widget build(BuildContext context) {
    final asset = inverted
        ? 'assets/images/bb_mark_inverted.png'
        : 'assets/images/bb_mark.png';
    return Image.asset(asset, width: size, height: size);
  }
}
