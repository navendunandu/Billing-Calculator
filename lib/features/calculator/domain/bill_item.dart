/// Bill item model for calculator
class BillItem {
  BillItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.rate,
    this.inventoryItemId,
    this.barcode,
    this.discountAmount = 0.0,
    this.hsnCode,
    this.taxRate = 0.0,
    this.isTaxInclusive = true,
  });

  final String id;
  final String name;
  final double quantity;
  final double rate;
  final int? inventoryItemId;
  final String? barcode;
  final double discountAmount;
  final String? hsnCode;
  final double taxRate;
  final bool isTaxInclusive;

  /// Line amount before tax extraction (quantity * rate - discount)
  double get grossAmount {
    final raw = (quantity * rate) - discountAmount;
    return raw < 0 ? 0.0 : raw;
  }

  /// Whether this item has tax applied
  bool get hasTax => taxRate > 0;

  /// Taxable value (the base amount on which tax is calculated)
  double get taxableAmount {
    if (!hasTax) return grossAmount;
    if (isTaxInclusive) {
      return grossAmount / (1.0 + (taxRate / 100.0));
    } else {
      return grossAmount;
    }
  }

  /// Total tax amount for this item
  double get taxAmount {
    if (!hasTax) return 0.0;
    if (isTaxInclusive) {
      return grossAmount - taxableAmount;
    } else {
      return taxableAmount * (taxRate / 100.0);
    }
  }

  /// CGST amount (Central GST = 50% of total GST)
  double get cgstAmount => taxAmount / 2.0;

  /// SGST amount (State GST = 50% of total GST)
  double get sgstAmount => taxAmount / 2.0;

  /// IGST amount (Integrated GST = 100% of total GST)
  double get igstAmount => taxAmount;

  /// CGST rate percentage
  double get cgstRate => taxRate / 2.0;

  /// SGST rate percentage
  double get sgstRate => taxRate / 2.0;

  /// Final total for this item line.
  /// If tax-inclusive (MRP), total is simply the grossAmount.
  /// If tax-exclusive, tax is added on top of taxableAmount.
  double get total {
    if (isTaxInclusive || !hasTax) {
      return grossAmount;
    } else {
      return taxableAmount + taxAmount;
    }
  }

  /// Create a copy with updated values
  BillItem copyWith({
    String? id,
    String? name,
    double? quantity,
    double? rate,
    int? inventoryItemId,
    String? barcode,
    double? discountAmount,
    String? hsnCode,
    double? taxRate,
    bool? isTaxInclusive,
  }) {
    return BillItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      rate: rate ?? this.rate,
      inventoryItemId: inventoryItemId ?? this.inventoryItemId,
      barcode: barcode ?? this.barcode,
      discountAmount: discountAmount ?? this.discountAmount,
      hsnCode: hsnCode ?? this.hsnCode,
      taxRate: taxRate ?? this.taxRate,
      isTaxInclusive: isTaxInclusive ?? this.isTaxInclusive,
    );
  }

  @override
  String toString() {
    return 'BillItem(id: $id, name: $name, qty: $quantity, rate: $rate, taxRate: $taxRate, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BillItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
