import 'package:drift/drift.dart' hide Column;

import '../../../core/database/app_database.dart';
import '../../../core/services/document_series_service.dart';
import '../../../core/database/tables/inventory_items.dart';
import '../domain/inventory_item_model.dart';

abstract class InventoryRepository {
  Stream<List<InventoryItemModel>> watchAllItems({
    bool includeArchived = false,
  });
  Future<InventoryItemModel?> getItemById(int id);
  Future<String> getNextItemCode();
  Future<int> insertItem(InventoryItemDraft draft);
  Future<void> updateItem(int id, InventoryItemDraft draft);
  Future<void> deleteItem(int id);
}

class DriftInventoryRepository implements InventoryRepository {
  DriftInventoryRepository(this._db, this._documentSeriesService);

  final AppDatabase _db;
  final DocumentSeriesService _documentSeriesService;

  @override
  Stream<List<InventoryItemModel>> watchAllItems({
    bool includeArchived = false,
  }) {
    return _db
        .watchAllInventoryItems(includeArchived: includeArchived)
        .map((rows) => rows.map(_mapFromDb).toList());
  }

  @override
  Future<InventoryItemModel?> getItemById(int id) async {
    final row = await _db.getInventoryItemById(id);
    if (row == null) {
      return null;
    }
    return _mapFromDb(row);
  }

  @override
  Future<String> getNextItemCode() async {
    return _documentSeriesService.getNextFormattedNumber(
      DocumentSeriesService.itemModule,
    );
  }

  @override
  Future<int> insertItem(InventoryItemDraft draft) async {
    return _db.transaction(() async {
      final normalizedCode = await _documentSeriesService
          .getNextFormattedNumber(DocumentSeriesService.itemModule);

      final existing = await _db.getInventoryItemByCode(normalizedCode);
      if (existing != null) {
        throw StateError(
          'Generated item code already exists. Please check series settings.',
        );
      }

      final id = await _db.insertInventoryItem(
        InventoryItemsCompanion.insert(
          code: normalizedCode,
          barcode: Value(
            draft.barcode?.trim().isEmpty == true
                ? null
                : draft.barcode?.trim(),
          ),
          name: draft.name.trim(),
          category: draft.category.trim(),
          brand: draft.brand.trim(),
          price: draft.price,
          uom: Value(draft.uom.name),
          unitValue: Value(draft.unitValue),
          imagePath: Value(
            draft.imagePath?.trim().isEmpty == true
                ? null
                : draft.imagePath?.trim(),
          ),
          status: Value(_mapStatusToDb(draft.status)),
          hsnCode: Value(
            draft.hsnCode?.trim().isEmpty == true
                ? null
                : draft.hsnCode?.trim(),
          ),
          taxRate: Value(draft.taxRate),
          isTaxInclusive: Value(draft.isTaxInclusive),
        ),
      );

      await _documentSeriesService.incrementSeries(
        DocumentSeriesService.itemModule,
      );
      return id;
    });
  }

  @override
  Future<void> updateItem(int id, InventoryItemDraft draft) async {
    final current = await _db.getInventoryItemById(id);
    if (current == null) {
      throw StateError('Item not found');
    }

    final normalizedCode = draft.code.trim();
    final existing = await _db.getInventoryItemByCode(normalizedCode);
    if (existing != null && existing.id != id) {
      throw StateError('Item code already exists');
    }

    final updated = current.copyWith(
      code: normalizedCode,
      barcode: Value(
        draft.barcode?.trim().isEmpty == true ? null : draft.barcode?.trim(),
      ),
      name: draft.name.trim(),
      category: draft.category.trim(),
      brand: draft.brand.trim(),
      price: draft.price,
      uom: draft.uom.name,
      unitValue: draft.unitValue,
      imagePath: Value(
        draft.imagePath?.trim().isEmpty == true
            ? null
            : draft.imagePath?.trim(),
      ),
      status: _mapStatusToDb(draft.status),
      hsnCode: Value(
        draft.hsnCode?.trim().isEmpty == true
            ? null
            : draft.hsnCode?.trim(),
      ),
      taxRate: draft.taxRate,
      isTaxInclusive: draft.isTaxInclusive,
    );

    final didUpdate = await _db.updateInventoryItem(updated);
    if (!didUpdate) {
      throw StateError('Unable to update item');
    }
  }

  @override
  Future<void> deleteItem(int id) async {
    await _db.deleteInventoryItem(id);
  }

  InventoryItemModel _mapFromDb(InventoryItem row) {
    return InventoryItemModel(
      id: row.id,
      code: row.code,
      barcode: row.barcode,
      name: row.name,
      category: row.category,
      brand: row.brand,
      price: row.price,
      uom: _mapUomFromDb(row.uom),
      unitValue: row.unitValue,
      imagePath: row.imagePath,
      status: _mapStatusFromDb(row.status),
      createdAt: row.createdAt,
      hsnCode: row.hsnCode,
      taxRate: row.taxRate,
      isTaxInclusive: row.isTaxInclusive,
    );
  }

  InventoryStatus _mapStatusFromDb(InventoryItemStatus status) {
    switch (status) {
      case InventoryItemStatus.available:
        return InventoryStatus.available;
      case InventoryItemStatus.outOfStock:
        return InventoryStatus.outOfStock;
      case InventoryItemStatus.archived:
        return InventoryStatus.archived;
    }
  }

  InventoryItemStatus _mapStatusToDb(InventoryStatus status) {
    switch (status) {
      case InventoryStatus.available:
        return InventoryItemStatus.available;
      case InventoryStatus.outOfStock:
        return InventoryItemStatus.outOfStock;
      case InventoryStatus.archived:
        return InventoryItemStatus.archived;
    }
  }

  InventoryUom _mapUomFromDb(String uom) {
    return InventoryUom.values.firstWhere(
      (value) => value.name == uom,
      orElse: () => InventoryUom.pcs,
    );
  }
}
