import 'package:drift/drift.dart';

/// Categories table definition for Drift
class Categories extends Table {
  /// Primary key - auto increment
  IntColumn get id => integer().autoIncrement()();

  /// Unique category name (e.g., 'Bakery', 'Dairy', 'Vegetables')
  TextColumn get name => text().withLength(min: 1, max: 100).unique()();

  /// Optional description
  TextColumn get description => text().nullable()();

  /// Created timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Updated timestamp
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
