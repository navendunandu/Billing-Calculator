import 'package:drift/drift.dart';

/// Brands table definition for Drift
class Brands extends Table {
  /// Primary key - auto increment
  IntColumn get id => integer().autoIncrement()();

  /// Unique brand name (e.g., 'Amul', 'Nestle', 'Britannia')
  TextColumn get name => text().withLength(min: 1, max: 100).unique()();

  /// Optional description
  TextColumn get description => text().nullable()();

  /// Created timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Updated timestamp
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
