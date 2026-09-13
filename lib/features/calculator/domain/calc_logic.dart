import 'bill_item.dart';

/// Calculator input mode
enum CalcInputMode { quantity, rate }

/// Calculator state
class CalculatorState {
  const CalculatorState({
    this.quantityInput = '',
    this.rateInput = '',
    this.currentMode = CalcInputMode.rate,
    this.billItems = const [],
    this.itemCounter = 1,
  });

  final String quantityInput;
  final String rateInput;
  final CalcInputMode currentMode;
  final List<BillItem> billItems;
  final int itemCounter;

  /// Get quantity as double
  double get quantity {
    if (quantityInput.isEmpty) return 0;
    return double.tryParse(quantityInput) ?? 0;
  }

  /// Get rate as double
  double get rate {
    if (rateInput.isEmpty) return 0;
    return double.tryParse(rateInput) ?? 0;
  }

  /// Calculate current item total
  double get currentTotal => quantity * rate;

  /// Calculate bill subtotal
  double get subtotal {
    return billItems.fold(0.0, (sum, item) => sum + item.total);
  }

  /// Total item count
  int get itemCount => billItems.length;

  /// Total item quantity across all items
  double get totalQuantity {
    return billItems.fold(0.0, (sum, item) => sum + item.quantity);
  }

  /// Total taxable amount across all items
  double get totalTaxableAmount {
    return billItems.fold(0.0, (sum, item) => sum + item.taxableAmount);
  }

  /// Total tax amount across all items
  double get totalTaxAmount {
    return billItems.fold(0.0, (sum, item) => sum + item.taxAmount);
  }

  /// Total CGST amount across all items
  double get totalCgstAmount {
    return billItems.fold(0.0, (sum, item) => sum + item.cgstAmount);
  }

  /// Total SGST amount across all items
  double get totalSgstAmount {
    return billItems.fold(0.0, (sum, item) => sum + item.sgstAmount);
  }

  /// Whether any items in the bill have tax
  bool get hasTax {
    return billItems.any((item) => item.hasTax);
  }

  /// Check if can add item (both qty and rate are valid)
  bool get canAddItem {
    return quantity > 0 && rate > 0;
  }

  /// Get current input value based on mode
  String get currentInput {
    return currentMode == CalcInputMode.quantity ? quantityInput : rateInput;
  }

  /// Copy with modified values
  CalculatorState copyWith({
    String? quantityInput,
    String? rateInput,
    CalcInputMode? currentMode,
    List<BillItem>? billItems,
    int? itemCounter,
  }) {
    return CalculatorState(
      quantityInput: quantityInput ?? this.quantityInput,
      rateInput: rateInput ?? this.rateInput,
      currentMode: currentMode ?? this.currentMode,
      billItems: billItems ?? this.billItems,
      itemCounter: itemCounter ?? this.itemCounter,
    );
  }
}
