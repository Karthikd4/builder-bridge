abstract final class FormatUtils {
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// Formats a DateTime as "01 Jan 2025".
  static String formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';
  }

  /// Formats paise (integer) as ₹X.XX Cr / ₹X.XX L / ₹X.
  static String formatPaise(int paise) {
    final r = paise / 100;
    if (r >= 10000000) return '₹${(r / 10000000).toStringAsFixed(2)} Cr';
    if (r >= 100000) return '₹${(r / 100000).toStringAsFixed(2)} L';
    return '₹${r.toStringAsFixed(0)}';
  }
}
