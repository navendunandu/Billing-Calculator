import 'package:drift/drift.dart';

/// Inventory availability status
enum InventoryItemStatus { available, outOfStock, archived }

/// Inventory items table definition for Drift
class InventoryItems extends Table {
  /// Primary key - auto increment
  IntColumn get id => integer().autoIncrement()();

  /// Unique internal item code (SKU)
  TextColumn get code => text().withLength(min: 1, max: 50).unique()();

  /// Optional scannable barcode value
  TextColumn get barcode => text().withLength(min: 1, max: 120).nullable()();

  /// Display name
  TextColumn get name => text().withLength(min: 1, max: 120)();

  /// Category label
  TextColumn get category => text().withLength(min: 1, max: 60)();

  /// Brand label
  TextColumn get brand => text().withLength(min: 1, max: 60)();

  /// Unit price
  RealColumn get price => real()();

  /// Unit of measurement (pcs, kg, l, etc.)
  TextColumn get uom =>
      text().withLength(min: 1, max: 20).withDefault(const Constant('pcs'))();

  /// Quantity represented by one price unit (e.g. 1 kg, 500 g)
  RealColumn get unitValue => real().withDefault(const Constant(1.0))();

  /// Optional local image path
  TextColumn get imagePath => text().nullable()();

  /// Availability status
  IntColumn get status => intEnum<InventoryItemStatus>().withDefault(
    Constant(InventoryItemStatus.available.index),
  )();

  /// Optional HSN / SAC code reference
  TextColumn get hsnCode => text().withLength(min: 1, max: 20).nullable()();

  /// Tax / GST percentage (e.g. 0.0, 5.0, 12.0, 18.0, 28.0)
  RealColumn get taxRate => real().withDefault(const Constant(0.0))();

  /// Whether selling price is tax-inclusive (MRP) or tax-exclusive (base rate)
  BoolColumn get isTaxInclusive => boolean().withDefault(const Constant(true))();

  /// Created timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
