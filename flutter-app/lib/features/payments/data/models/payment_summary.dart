import 'package:builder_bridge/features/payments/data/models/payment_milestone_model.dart';

class PaymentSummary {
  final List<PaymentMilestoneModel> milestones;
  final int paidPaise;
  final int totalPaise;
  final PaymentMilestoneModel? nextDue;
  final PaymentMilestoneModel? possession;

  const PaymentSummary({
    required this.milestones,
    required this.paidPaise,
    required this.totalPaise,
    this.nextDue,
    this.possession,
  });

  factory PaymentSummary.from(List<PaymentMilestoneModel> milestones) {
    final sorted = [...milestones]
      ..sort((a, b) => a.dueDateTime.compareTo(b.dueDateTime));
    final paid = sorted.where((m) => m.isPaid);
    final unpaid = sorted.where((m) => !m.isPaid).toList();
    return PaymentSummary(
      milestones: sorted,
      paidPaise: paid.fold<int>(0, (s, m) => s + m.amount),
      totalPaise: sorted.fold<int>(0, (s, m) => s + m.amount),
      nextDue: unpaid.isNotEmpty ? unpaid.first : null,
      possession: sorted.isNotEmpty ? sorted.last : null,
    );
  }

  int get paidCount => milestones.where((m) => m.isPaid).length;
  int get totalCount => milestones.length;

  double get progressFraction =>
      totalPaise == 0 ? 0 : paidPaise / totalPaise;

  String get formattedPaid => _fmt(paidPaise);
  String get formattedTotal => _fmt(totalPaise);

  String _fmt(int paise) {
    final r = paise / 100;
    if (r >= 10000000) return '₹${(r / 10000000).toStringAsFixed(2)} Cr';
    if (r >= 100000) return '₹${(r / 100000).toStringAsFixed(2)} L';
    return '₹${r.toStringAsFixed(0)}';
  }
}
