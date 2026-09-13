import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/app_providers.dart';
import '../domain/hsn_entry_model.dart';

abstract class HsnRepository {
  Future<List<HsnEntryModel>> getAllHsnEntries();
  Future<HsnEntryModel?> getHsnByCode(String code);
  Future<HsnEntryModel?> getHsnById(int id);
  Future<int> insertHsnEntry(HsnEntryDraft draft);
  Future<bool> updateHsnEntry(int id, HsnEntryDraft draft);
  Future<bool> deleteHsnEntry(int id);
}

class DriftHsnRepository implements HsnRepository {
  DriftHsnRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<HsnEntryModel>> getAllHsnEntries() async {
    final rows = await _db.getAllHsnEntries();
    return rows.map(_mapRow).toList();
  }

  @override
  Future<HsnEntryModel?> getHsnByCode(String code) async {
    final row = await _db.getHsnByCode(code);
    return row == null ? null : _mapRow(row);
  }

  @override
  Future<HsnEntryModel?> getHsnById(int id) async {
    final row = await _db.getHsnById(id);
    return row == null ? null : _mapRow(row);
  }

  @override
  Future<int> insertHsnEntry(HsnEntryDraft draft) async {
    final now = DateTime.now();
    return _db.insertHsnEntry(
      HsnEntriesCompanion.insert(
        hsnCode: draft.hsnCode.trim(),
        description: draft.description.trim(),
        gstRate: draft.gstRate,
        cgstRate: draft.cgstRate,
        sgstRate: draft.sgstRate,
        igstRate: draft.igstRate,
        isDefault: Value(draft.isDefault),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  @override
  Future<bool> updateHsnEntry(int id, HsnEntryDraft draft) async {
    final now = DateTime.now();
    return _db.updateHsnEntry(
      HsnEntriesCompanion(
        id: Value(id),
        hsnCode: Value(draft.hsnCode.trim()),
        description: Value(draft.description.trim()),
        gstRate: Value(draft.gstRate),
        cgstRate: Value(draft.cgstRate),
        sgstRate: Value(draft.sgstRate),
        igstRate: Value(draft.igstRate),
        isDefault: Value(draft.isDefault),
        updatedAt: Value(now),
      ),
    );
  }

  @override
  Future<bool> deleteHsnEntry(int id) async {
    final count = await _db.deleteHsnEntry(id);
    return count > 0;
  }

  HsnEntryModel _mapRow(HsnEntry row) {
    return HsnEntryModel(
      id: row.id,
      hsnCode: row.hsnCode,
      description: row.description,
      gstRate: row.gstRate,
      cgstRate: row.cgstRate,
      sgstRate: row.sgstRate,
      igstRate: row.igstRate,
      isDefault: row.isDefault,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}

final hsnRepositoryProvider = Provider<HsnRepository>((ref) {
  return DriftHsnRepository(ref.watch(databaseProvider));
});
