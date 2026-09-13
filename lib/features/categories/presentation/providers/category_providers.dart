import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/category_repository.dart';
import '../../domain/category_model.dart';

class CategoryState {
  const CategoryState({
    this.categories = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.searchQuery = '',
    this.errorMessage,
  });

  final List<CategoryModel> categories;
  final bool isLoading;
  final bool isSaving;
  final String searchQuery;
  final String? errorMessage;

  List<CategoryModel> get filteredCategories {
    if (searchQuery.trim().isEmpty) return categories;
    final q = searchQuery.trim().toLowerCase();
    return categories
        .where(
          (c) =>
              c.name.toLowerCase().contains(q) ||
              (c.description != null && c.description!.toLowerCase().contains(q)),
        )
        .toList();
  }

  CategoryState copyWith({
    List<CategoryModel>? categories,
    bool? isLoading,
    bool? isSaving,
    String? searchQuery,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class CategoryNotifier extends Notifier<CategoryState> {
  @override
  CategoryState build() {
    Future.microtask(loadCategories);
    return const CategoryState(isLoading: true);
  }

  CategoryRepository get _repository => ref.read(categoryRepositoryProvider);

  Future<void> loadCategories() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final categories = await _repository.getAllCategories();
      state = state.copyWith(categories: categories, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load categories: $e',
      );
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Adds a category via draft. Returns error string if failed, null on success.
  Future<String?> addCategory(CategoryDraft draft) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final existing = await _repository.getCategoryByName(draft.name);
      if (existing != null) {
        state = state.copyWith(isSaving: false);
        return 'Category "${draft.name}" already exists';
      }

      await _repository.insertCategory(draft);
      final list = await _repository.getAllCategories();
      state = state.copyWith(categories: list, isSaving: false);
      return null;
    } catch (e) {
      state = state.copyWith(isSaving: false);
      return 'Failed to add category: $e';
    }
  }

  /// Quickly creates or retrieves a category by name, ideal for inline creation from pickers.
  Future<CategoryModel?> quickCreateCategory(String name, {String? description}) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return null;

    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final existing = await _repository.getCategoryByName(trimmed);
      if (existing != null) {
        state = state.copyWith(isSaving: false);
        return existing;
      }

      final created = await _repository.insertCategory(
        CategoryDraft(name: trimmed, description: description),
      );
      final list = await _repository.getAllCategories();
      state = state.copyWith(categories: list, isSaving: false);
      return created;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to quick create category: $e',
      );
      return null;
    }
  }

  Future<String?> updateCategory(int id, CategoryDraft draft) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final existing = await _repository.getCategoryByName(draft.name);
      if (existing != null && existing.id != id) {
        state = state.copyWith(isSaving: false);
        return 'Another category named "${draft.name}" already exists';
      }

      await _repository.updateCategory(id, draft);
      final list = await _repository.getAllCategories();
      state = state.copyWith(categories: list, isSaving: false);
      return null;
    } catch (e) {
      state = state.copyWith(isSaving: false);
      return 'Failed to update category: $e';
    }
  }

  Future<String?> deleteCategory(int id) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      await _repository.deleteCategory(id);
      final list = await _repository.getAllCategories();
      state = state.copyWith(categories: list, isSaving: false);
      return null;
    } catch (e) {
      state = state.copyWith(isSaving: false);
      return 'Failed to delete category: $e';
    }
  }
}

final categoryManagerProvider = NotifierProvider<CategoryNotifier, CategoryState>(
  CategoryNotifier.new,
);
