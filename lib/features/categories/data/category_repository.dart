import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/app_providers.dart';
import '../domain/category_model.dart';

abstract class CategoryRepository {
  Future<List<CategoryModel>> getAllCategories({bool withItemCounts = true});
  Future<CategoryModel?> getCategoryById(int id);
  Future<CategoryModel?> getCategoryByName(String name);
  Future<CategoryModel> insertCategory(CategoryDraft draft);
  Future<bool> updateCategory(int id, CategoryDraft draft);
  Future<bool> deleteCategory(int id);
  Stream<List<CategoryModel>> watchAllCategories();
}

class DriftCategoryRepository implements CategoryRepository {
  DriftCategoryRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<CategoryModel>> getAllCategories({bool withItemCounts = true}) async {
    final rows = await _db.getAllCategories();
    Map<String, int> counts = {};
    if (withItemCounts) {
      counts = await _db.getCategoryItemCounts();
    }
    return rows.map((r) => _mapRow(r, count: counts[r.name] ?? 0)).toList();
  }

  @override
  Future<CategoryModel?> getCategoryById(int id) async {
    final row = await _db.getCategoryById(id);
    if (row == null) return null;
    final counts = await _db.getCategoryItemCounts();
    return _mapRow(row, count: counts[row.name] ?? 0);
  }

  @override
  Future<CategoryModel?> getCategoryByName(String name) async {
    final row = await _db.getCategoryByName(name);
    if (row == null) return null;
    return _mapRow(row);
  }

  @override
  Future<CategoryModel> insertCategory(CategoryDraft draft) async {
    final now = DateTime.now();
    final id = await _db.insertCategory(
      CategoriesCompanion.insert(
        name: draft.name.trim(),
        description: draft.description != null && draft.description!.trim().isNotEmpty
            ? Value(draft.description!.trim())
            : const Value.absent(),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    return CategoryModel(
      id: id,
      name: draft.name.trim(),
      description: draft.description?.trim(),
      createdAt: now,
      updatedAt: now,
      itemCount: 0,
    );
  }

  @override
  Future<bool> updateCategory(int id, CategoryDraft draft) async {
    final now = DateTime.now();
    return _db.updateCategory(
      CategoriesCompanion(
        id: Value(id),
        name: Value(draft.name.trim()),
        description: Value(draft.description?.trim()),
        updatedAt: Value(now),
      ),
    );
  }

  @override
  Future<bool> deleteCategory(int id) async {
    final count = await _db.deleteCategory(id);
    return count > 0;
  }

  @override
  Stream<List<CategoryModel>> watchAllCategories() {
    return _db.watchAllCategories().map(
      (rows) => rows.map((r) => _mapRow(r)).toList(),
    );
  }

  CategoryModel _mapRow(Category row, {int count = 0}) {
    return CategoryModel(
      id: row.id,
      name: row.name,
      description: row.description,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      itemCount: count,
    );
  }
}

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return DriftCategoryRepository(ref.watch(databaseProvider));
});
