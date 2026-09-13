import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/hsn_repository.dart';
import '../../domain/hsn_entry_model.dart';

class HsnState {
  const HsnState({
    this.entries = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.searchQuery = '',
    this.selectedRateFilter,
    this.errorMessage,
  });

  final List<HsnEntryModel> entries;
  final bool isLoading;
  final bool isSaving;
  final String searchQuery;
  final double? selectedRateFilter;
  final String? errorMessage;

  List<HsnEntryModel> get filteredEntries {
    var result = entries;

    if (selectedRateFilter != null) {
      result = result.where((e) => (e.gstRate - selectedRateFilter!).abs() < 0.001).toList();
    }

    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      result = result
          .where(
            (e) =>
                e.hsnCode.toLowerCase().contains(q) ||
                e.description.toLowerCase().contains(q),
          )
          .toList();
    }

    return result;
  }

  HsnState copyWith({
    List<HsnEntryModel>? entries,
    bool? isLoading,
    bool? isSaving,
    String? searchQuery,
    double? selectedRateFilter,
    bool clearRateFilter = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HsnState(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedRateFilter: clearRateFilter
          ? null
          : (selectedRateFilter ?? this.selectedRateFilter),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class HsnNotifier extends Notifier<HsnState> {
  @override
  HsnState build() {
    // Kick off asynchronous load
    Future.microtask(loadEntries);
    return const HsnState(isLoading: true);
  }

  HsnRepository get _repository => ref.read(hsnRepositoryProvider);

  Future<void> loadEntries() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final entries = await _repository.getAllHsnEntries();
      state = state.copyWith(entries: entries, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load HSN codes: $e',
      );
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setRateFilter(double? rate) {
    if (rate == null) {
      state = state.copyWith(clearRateFilter: true);
    } else {
      state = state.copyWith(selectedRateFilter: rate);
    }
  }

  Future<String?> addHsn(HsnEntryDraft draft) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final existing = await _repository.getHsnByCode(draft.hsnCode);
      if (existing != null) {
        state = state.copyWith(isSaving: false);
        return 'HSN Code "${draft.hsnCode}" already exists';
      }

      await _repository.insertHsnEntry(draft);
      final entries = await _repository.getAllHsnEntries();
      state = state.copyWith(entries: entries, isSaving: false);
      return null;
    } catch (e) {
      state = state.copyWith(isSaving: false);
      return 'Failed to add HSN entry: $e';
    }
  }

  Future<String?> updateHsn(int id, HsnEntryDraft draft) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final existing = await _repository.getHsnByCode(draft.hsnCode);
      if (existing != null && existing.id != id) {
        state = state.copyWith(isSaving: false);
        return 'Another entry with HSN code "${draft.hsnCode}" already exists';
      }

      await _repository.updateHsnEntry(id, draft);
      final entries = await _repository.getAllHsnEntries();
      state = state.copyWith(entries: entries, isSaving: false);
      return null;
    } catch (e) {
      state = state.copyWith(isSaving: false);
      return 'Failed to update HSN entry: $e';
    }
  }

  Future<String?> deleteHsn(int id) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      await _repository.deleteHsnEntry(id);
      final entries = await _repository.getAllHsnEntries();
      state = state.copyWith(entries: entries, isSaving: false);
      return null;
    } catch (e) {
      state = state.copyWith(isSaving: false);
      return 'Failed to delete HSN entry: $e';
    }
  }
}

final hsnManagerProvider = NotifierProvider<HsnNotifier, HsnState>(
  HsnNotifier.new,
);
