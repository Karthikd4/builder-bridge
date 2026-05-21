import 'package:builder_bridge/features/inventory/data/models/unit_model.dart';

class EstimateLineItem {
  final String label;
  final int amount; // paise; negative = discount

  const EstimateLineItem(this.label, this.amount);

  bool get isDiscount => amount < 0;

  String get formattedAmount {
    final r = amount.abs() / 100;
    final sign = isDiscount ? '−₹' : '₹';
    if (r >= 10000000) return '$sign${(r / 10000000).toStringAsFixed(2)} Cr';
    return '$sign${(r / 100000).toStringAsFixed(2)} L';
  }
}

class EstimateBreakdown {
  final UnitModel unit;
  final List<EstimateLineItem> items;
  final int total; // paise

  const EstimateBreakdown({
    required this.unit,
    required this.items,
    required this.total,
  });

  factory EstimateBreakdown.forUnit(UnitModel unit) {
    const discount = -50000000; // −₹5L pre-launch incentive
    final base = unit.basePrice;
    final gst = (base * 0.05).round();
    final reg = (base * 0.01).round();

    return EstimateBreakdown(
      unit: unit,
      items: [
        EstimateLineItem('Agreed Price', base),
        EstimateLineItem('GST (5%)', gst),
        EstimateLineItem('Registration & Legal (1%)', reg),
        const EstimateLineItem('Pre-launch Incentive', discount),
      ],
      total: base + gst + reg + discount,
    );
  }

  String get formattedTotal {
    final r = total / 100;
    if (r >= 10000000) return '₹${(r / 10000000).toStringAsFixed(2)} Cr';
    return '₹${(r / 100000).toStringAsFixed(2)} L';
  }

  /// Suggested token amount: 5% of total
  int get suggestedToken => (total * 0.05).round();
}
