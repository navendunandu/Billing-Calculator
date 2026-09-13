import 'package:drift/drift.dart';

/// HSN / SAC table definition for GST and Tax Master
class HsnEntries extends Table {
  /// Primary key - auto increment
  IntColumn get id => integer().autoIncrement()();

  /// HSN / SAC code (e.g. "1001", "0808", "9983")
  TextColumn get hsnCode => text().withLength(min: 1, max: 20).unique()();

  /// Descriptive commodity or service name
  TextColumn get description => text().withLength(min: 1, max: 200)();

  /// Total GST Rate percentage (e.g. 0.0, 5.0, 12.0, 18.0, 28.0)
  RealColumn get gstRate => real()();

  /// Central GST Rate percentage (typically gstRate / 2)
  RealColumn get cgstRate => real()();

  /// State GST Rate percentage (typically gstRate / 2)
  RealColumn get sgstRate => real()();

  /// Integrated GST Rate percentage (typically gstRate)
  RealColumn get igstRate => real()();

  /// Whether this is a system default entry
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

  /// Created timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Updated timestamp
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
