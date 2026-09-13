import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/app_providers.dart';
import '../domain/brand_model.dart';

abstract class BrandRepository {
  Future<List<BrandModel>> getAllBrands({bool withItemCounts = true});
  Future<BrandModel?> getBrandById(int id);
  Future<BrandModel?> getBrandByName(String name);
  Future<BrandModel> insertBrand(BrandDraft draft);
  Future<bool> updateBrand(int id, BrandDraft draft);
  Future<bool> deleteBrand(int id);
  Stream<List<BrandModel>> watchAllBrands();
}

class DriftBrandRepository implements BrandRepository {
  DriftBrandRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<BrandModel>> getAllBrands({bool withItemCounts = true}) async {
    final rows = await _db.getAllBrands();
    Map<String, int> counts = {};
    if (withItemCounts) {
      counts = await _db.getBrandItemCounts();
    }
    return rows.map((r) => _mapRow(r, count: counts[r.name] ?? 0)).toList();
  }

  @override
  Future<BrandModel?> getBrandById(int id) async {
    final row = await _db.getBrandById(id);
    if (row == null) return null;
    final counts = await _db.getBrandItemCounts();
    return _mapRow(row, count: counts[row.name] ?? 0);
  }

  @override
  Future<BrandModel?> getBrandByName(String name) async {
    final row = await _db.getBrandByName(name);
    if (row == null) return null;
    return _mapRow(row);
  }

  @override
  Future<BrandModel> insertBrand(BrandDraft draft) async {
    final now = DateTime.now();
    final id = await _db.insertBrand(
      BrandsCompanion.insert(
        name: draft.name.trim(),
        description: draft.description != null && draft.description!.trim().isNotEmpty
            ? Value(draft.description!.trim())
            : const Value.absent(),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    return BrandModel(
      id: id,
      name: draft.name.trim(),
      description: draft.description?.trim(),
      createdAt: now,
      updatedAt: now,
      itemCount: 0,
    );
  }

  @override
  Future<bool> updateBrand(int id, BrandDraft draft) async {
    final now = DateTime.now();
    return _db.updateBrand(
      BrandsCompanion(
        id: Value(id),
        name: Value(draft.name.trim()),
        description: Value(draft.description?.trim()),
        updatedAt: Value(now),
      ),
    );
  }

  @override
  Future<bool> deleteBrand(int id) async {
    final count = await _db.deleteBrand(id);
    return count > 0;
  }

  @override
  Stream<List<BrandModel>> watchAllBrands() {
    return _db.watchAllBrands().map(
      (rows) => rows.map((r) => _mapRow(r)).toList(),
    );
  }

  BrandModel _mapRow(Brand row, {int count = 0}) {
    return BrandModel(
      id: row.id,
      name: row.name,
      description: row.description,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      itemCount: count,
    );
  }
}

final brandRepositoryProvider = Provider<BrandRepository>((ref) {
  return DriftBrandRepository(ref.watch(databaseProvider));
});
