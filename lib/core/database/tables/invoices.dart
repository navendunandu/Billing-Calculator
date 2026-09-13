import 'package:drift/drift.dart';

import 'customers.dart';

/// Payment mode enum for invoices
enum PaymentMode { cash, upi, credit }

/// Payment status enum
enum PaymentStatus { pending, partial, fulfilled }

/// Invoices table definition for Drift
class Invoices extends Table {
  /// Primary key - auto increment
  IntColumn get id => integer().autoIncrement()();

  /// Optional customer reference for credit invoices
  IntColumn get customerId => integer().nullable().references(Customers, #id)();

  /// Unique invoice number (e.g., INV-20260125-001)
  TextColumn get invoiceNo => text().withLength(min: 1, max: 50).unique()();

  /// Total amount before discount
  RealColumn get subtotalAmount => real().withDefault(const Constant(0.0))();

  /// Discount amount
  RealColumn get discountAmount => real().withDefault(const Constant(0.0))();

  /// Total amount after discount
  RealColumn get totalAmount => real().withDefault(const Constant(0.0))();

  /// Total taxable amount (pre-tax base)
  RealColumn get taxableAmount => real().withDefault(const Constant(0.0))();

  /// Total tax amount (CGST + SGST)
  RealColumn get totalTaxAmount => real().withDefault(const Constant(0.0))();

  /// Total CGST amount
  RealColumn get cgstAmount => real().withDefault(const Constant(0.0))();

  /// Total SGST amount
  RealColumn get sgstAmount => real().withDefault(const Constant(0.0))();

  /// Amount already paid against the invoice
  RealColumn get paidAmount => real().withDefault(const Constant(0.0))();

  /// Payment mode (cash, upi, credit)
  IntColumn get paymentMode => intEnum<PaymentMode>()();

  /// Payment status (pending, partial, fulfilled)
  IntColumn get paymentStatus => intEnum<PaymentStatus>()();

  /// Optional notes
  TextColumn get notes => text().nullable()();

  /// Created timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Updated timestamp
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
