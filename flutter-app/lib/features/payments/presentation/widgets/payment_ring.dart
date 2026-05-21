import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:builder_bridge/core/theme/app_colors.dart';
import 'package:builder_bridge/core/theme/app_typography.dart';
import 'package:builder_bridge/features/payments/data/models/payment_summary.dart';

class PaymentRing extends StatelessWidget {
  final PaymentSummary summary;
  final double size;

  const PaymentRing({
    required this.summary,
    this.size = 200,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (summary.progressFraction * 100).round();

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(summary: summary),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$percent%',
                  style: AppTypography.displayLarge
                      .copyWith(fontSize: 36, height: 1.0)),
              const SizedBox(height: 4),
              Text(summary.formattedPaid,
                  style: AppTypography.labelMedium
                      .copyWith(color: AppColors.ok)),
              Text('of ${summary.formattedTotal}',
                  style: AppTypography.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final PaymentSummary summary;
  static const _strokeWidth = 14.0;
  static const _gap = 0.04; // radians between segments

  _RingPainter({required this.summary});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - _strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    if (summary.milestones.isEmpty) {
      _drawArc(canvas, rect, -math.pi / 2, 2 * math.pi, AppColors.line);
      return;
    }

    final count = summary.milestones.length;
    final segment = (2 * math.pi - _gap * count) / count;
    var startAngle = -math.pi / 2;

    for (final m in summary.milestones) {
      final color = m.isPaid
          ? AppColors.ok
          : (m.isOverdue ? AppColors.danger : AppColors.line);
      _drawArc(canvas, rect, startAngle, segment, color);
      startAngle += segment + _gap;
    }
  }

  void _drawArc(
      Canvas canvas, Rect rect, double start, double sweep, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, start, sweep, false, paint);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.summary.paidPaise != summary.paidPaise ||
      old.summary.totalPaise != summary.totalPaise;
}
