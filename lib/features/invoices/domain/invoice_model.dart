import '../../../core/database/tables/invoices.dart';
import '../../calculator/domain/bill_item.dart';

/// App-level invoice entity used by UI and state management.
class InvoiceModel {
  const InvoiceModel({
    required this.id,
    required this.invoiceNo,
    required this.subtotalAmount,
    required this.discountAmount,
    required this.totalAmount,
    required this.paidAmount,
    required this.paymentMode,
    required this.paymentStatus,
    this.customerId,
    this.notes,
    this.taxableAmount = 0.0,
    this.totalTaxAmount = 0.0,
    this.cgstAmount = 0.0,
    this.sgstAmount = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String invoiceNo;
  final double subtotalAmount;
  final double discountAmount;
  final double totalAmount;
  final double paidAmount;
  final PaymentMode paymentMode;
  final PaymentStatus paymentStatus;
  final int? customerId;
  final String? notes;
  final double taxableAmount;
  final double totalTaxAmount;
  final double cgstAmount;
  final double sgstAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get hasTax => totalTaxAmount > 0;
}

/// Line item on a saved invoice.
class InvoiceLineItemModel {
  const InvoiceLineItemModel({
    required this.id,
    required this.invoiceId,
    required this.itemName,
    required this.quantity,
    required this.rate,
    required this.total,
    required this.serialNo,
    this.hsnCode,
    this.taxRate = 0.0,
    this.taxableAmount = 0.0,
    this.taxAmount = 0.0,
    this.cgstAmount = 0.0,
    this.sgstAmount = 0.0,
    this.isTaxInclusive = true,
  });

  final int id;
  final int invoiceId;
  final String itemName;
  final double quantity;
  final double rate;
  final double total;
  final int serialNo;
  final String? hsnCode;
  final double taxRate;
  final double taxableAmount;
  final double taxAmount;
  final double cgstAmount;
  final double sgstAmount;
  final bool isTaxInclusive;

  bool get hasTax => taxRate > 0;
}

/// Helper record for HSN tax breakdown summaries.
typedef HsnTaxSummary = ({
  String hsnCode,
  double taxRate,
  double taxableAmount,
  double cgstAmount,
  double sgstAmount,
  double totalTax,
});

/// Full invoice with line items for detail views and export.
class InvoiceDetailModel {
  const InvoiceDetailModel({required this.invoice, required this.items});

  final InvoiceModel invoice;
  final List<InvoiceLineItemModel> items;

  bool get hasTax => invoice.hasTax || items.any((i) => i.hasTax);

  /// Group items by HSN code and summarize taxable values & taxes
  List<HsnTaxSummary> get hsnSummary {
    final map = <String, HsnTaxSummary>{};

    for (final item in items) {
      if (!item.hasTax) continue;
      final key = item.hsnCode ?? 'OTHERS';
      final existing = map[key];
      if (existing == null) {
        map[key] = (
          hsnCode: key,
          taxRate: item.taxRate,
          taxableAmount: item.taxableAmount,
          cgstAmount: item.cgstAmount,
          sgstAmount: item.sgstAmount,
          totalTax: item.taxAmount,
        );
      } else {
        map[key] = (
          hsnCode: key,
          taxRate: existing.taxRate,
          taxableAmount: existing.taxableAmount + item.taxableAmount,
          cgstAmount: existing.cgstAmount + item.cgstAmount,
          sgstAmount: existing.sgstAmount + item.sgstAmount,
          totalTax: existing.totalTax + item.taxAmount,
        );
      }
    }

    return map.values.toList();
  }
}

/// Filter criteria for invoice list queries.
class InvoiceFilter {
  const InvoiceFilter({this.startDate, this.endDate, this.paymentMode});

  final DateTime? startDate;
  final DateTime? endDate;
  final PaymentMode? paymentMode;

  InvoiceFilter copyWith({
    DateTime? startDate,
    DateTime? endDate,
    PaymentMode? paymentMode,
    bool clearDates = false,
    bool clearPaymentMode = false,
  }) {
    return InvoiceFilter(
      startDate: clearDates ? null : (startDate ?? this.startDate),
      endDate: clearDates ? null : (endDate ?? this.endDate),
      paymentMode: clearPaymentMode ? null : (paymentMode ?? this.paymentMode),
    );
  }
}

/// Input for saving a new invoice from checkout.
class SaveInvoiceRequest {
  const SaveInvoiceRequest({
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.grandTotal,
    required this.paymentMode,
    required this.paidAmount,
    required this.paymentStatus,
    this.customerId,
    this.notes,
    this.taxableAmount = 0.0,
    this.totalTaxAmount = 0.0,
    this.cgstAmount = 0.0,
    this.sgstAmount = 0.0,
  });

  final List<BillItem> items;
  final double subtotal;
  final double discount;
  final double grandTotal;
  final PaymentMode paymentMode;
  final double paidAmount;
  final PaymentStatus paymentStatus;
  final int? customerId;
  final String? notes;
  final double taxableAmount;
  final double totalTaxAmount;
  final double cgstAmount;
  final double sgstAmount;
}

/// Result of a successful invoice save.
class SaveInvoiceResult {
  const SaveInvoiceResult({required this.invoiceId, required this.invoiceNo});

  final int invoiceId;
  final String invoiceNo;
}
