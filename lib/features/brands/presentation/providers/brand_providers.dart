import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/brand_repository.dart';
import '../../domain/brand_model.dart';

class BrandState {
  const BrandState({
    this.brands = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.searchQuery = '',
    this.errorMessage,
  });

  final List<BrandModel> brands;
  final bool isLoading;
  final bool isSaving;
  final String searchQuery;
  final String? errorMessage;

  List<BrandModel> get filteredBrands {
    if (searchQuery.trim().isEmpty) return brands;
    final q = searchQuery.trim().toLowerCase();
    return brands
        .where(
          (b) =>
              b.name.toLowerCase().contains(q) ||
              (b.description != null && b.description!.toLowerCase().contains(q)),
        )
        .toList();
  }

  BrandState copyWith({
    List<BrandModel>? brands,
    bool? isLoading,
    bool? isSaving,
    String? searchQuery,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BrandState(
      brands: brands ?? this.brands,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class BrandNotifier extends Notifier<BrandState> {
  @override
  BrandState build() {
    Future.microtask(loadBrands);
    return const BrandState(isLoading: true);
  }

  BrandRepository get _repository => ref.read(brandRepositoryProvider);

  Future<void> loadBrands() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final brands = await _repository.getAllBrands();
      state = state.copyWith(brands: brands, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load brands: $e',
      );
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Adds a brand via draft. Returns error string if failed, null on success.
  Future<String?> addBrand(BrandDraft draft) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final existing = await _repository.getBrandByName(draft.name);
      if (existing != null) {
        state = state.copyWith(isSaving: false);
        return 'Brand "${draft.name}" already exists';
      }

      await _repository.insertBrand(draft);
      final list = await _repository.getAllBrands();
      state = state.copyWith(brands: list, isSaving: false);
      return null;
    } catch (e) {
      state = state.copyWith(isSaving: false);
      return 'Failed to add brand: $e';
    }
  }

  /// Quickly creates or retrieves a brand by name.
  Future<BrandModel?> quickCreateBrand(String name, {String? description}) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return null;

    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final existing = await _repository.getBrandByName(trimmed);
      if (existing != null) {
        state = state.copyWith(isSaving: false);
        return existing;
      }

      final created = await _repository.insertBrand(
        BrandDraft(name: trimmed, description: description),
      );
      final list = await _repository.getAllBrands();
      state = state.copyWith(brands: list, isSaving: false);
      return created;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to quick create brand: $e',
      );
      return null;
    }
  }

  Future<String?> updateBrand(int id, BrandDraft draft) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final existing = await _repository.getBrandByName(draft.name);
      if (existing != null && existing.id != id) {
        state = state.copyWith(isSaving: false);
        return 'Another brand named "${draft.name}" already exists';
      }

      await _repository.updateBrand(id, draft);
      final list = await _repository.getAllBrands();
      state = state.copyWith(brands: list, isSaving: false);
      return null;
    } catch (e) {
      state = state.copyWith(isSaving: false);
      return 'Failed to update brand: $e';
    }
  }

  Future<String?> deleteBrand(int id) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      await _repository.deleteBrand(id);
      final list = await _repository.getAllBrands();
      state = state.copyWith(brands: list, isSaving: false);
      return null;
    } catch (e) {
      state = state.copyWith(isSaving: false);
      return 'Failed to delete brand: $e';
    }
  }
}

final brandManagerProvider = NotifierProvider<BrandNotifier, BrandState>(
  BrandNotifier.new,
);
