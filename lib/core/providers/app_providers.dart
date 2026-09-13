import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/settings/domain/preferences_model.dart';
import '../database/app_database.dart';
import '../services/document_series_service.dart';

/// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main()');
});

/// Provider for the database instance
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// Provider for document series formatter/increment service
final documentSeriesServiceProvider = Provider<DocumentSeriesService>((ref) {
  final database = ref.watch(databaseProvider);
  return DocumentSeriesService(database);
});

/// Provider that ensures the database is fully initialized (migrations applied).
/// Consumers can await this provider to be sure the DB is ready.
final databaseInitializationProvider = FutureProvider<void>((ref) async {
  final db = ref.watch(databaseProvider);
  // Run a lightweight query to force the lazy connection and any migrations to complete.
  // Using getTotalItemsCount which executes a simple select.
  try {
    await db.getTotalItemsCount();
  } catch (e) {
    // Re-throw to allow callers to observe the error state
    rethrow;
  }
});

/// Provider for user preferences with persistence
final userPreferencesProvider =
    NotifierProvider<UserPreferencesNotifier, UserPreferences>(
      UserPreferencesNotifier.new,
    );

/// Notifier for managing user preferences
class UserPreferencesNotifier extends Notifier<UserPreferences> {
  late final SharedPreferences _prefs;

  @override
  UserPreferences build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    return UserPreferences.fromPrefs(_prefs);
  }

  /// Update theme mode
  Future<void> setThemeMode(AppThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await state.saveToPrefs(_prefs);
  }

  /// Update language
  Future<void> setLanguage(AppLanguage language) async {
    state = state.copyWith(language: language);
    await state.saveToPrefs(_prefs);
  }

  /// Update text scale
  Future<void> setTextScale(double scale) async {
    state = state.copyWith(textScale: scale);
    await state.saveToPrefs(_prefs);
  }

  /// Toggle contrast mode
  Future<void> setContrastMode(bool enabled) async {
    state = state.copyWith(contrastMode: enabled);
    await state.saveToPrefs(_prefs);
  }

  /// Toggle haptic feedback
  Future<void> setHapticFeedback(bool enabled) async {
    state = state.copyWith(hapticFeedback: enabled);
    await state.saveToPrefs(_prefs);
  }

  /// Toggle credit payments
  Future<void> setCreditPaymentEnabled(bool enabled) async {
    state = state.copyWith(creditPaymentEnabled: enabled);
    await state.saveToPrefs(_prefs);
  }

  /// Toggle UPI payments
  Future<void> setUpiPaymentEnabled(bool enabled) async {
    state = state.copyWith(upiPaymentEnabled: enabled);
    await state.saveToPrefs(_prefs);
  }

  /// Update UPI ID used for payment QR generation
  Future<void> setUpiId(String upiId) async {
    state = state.copyWith(upiId: upiId.trim());
    await state.saveToPrefs(_prefs);
  }

  /// Toggle GST billing
  Future<void> setGstBillingEnabled(bool enabled) async {
    state = state.copyWith(gstBillingEnabled: enabled);
    await state.saveToPrefs(_prefs);
  }

  /// Update Store GSTIN
  Future<void> setStoreGstin(String gstin) async {
    state = state.copyWith(storeGstin: gstin.trim().toUpperCase());
    await state.saveToPrefs(_prefs);
  }

  /// Update Store Name
  Future<void> setStoreName(String storeName) async {
    state = state.copyWith(storeName: storeName.trim());
    await state.saveToPrefs(_prefs);
  }

  /// Reset to defaults
  Future<void> resetToDefaults() async {
    state = const UserPreferences();
    await state.saveToPrefs(_prefs);
  }
}

/// Provider for current theme mode (convenience)
final themeModeProvider = Provider<AppThemeMode>((ref) {
  final prefs = ref.watch(userPreferencesProvider);
  return prefs.contrastMode ? AppThemeMode.contrast : prefs.themeMode;
});

/// Provider for current text scale (convenience)
final textScaleProvider = Provider<double>((ref) {
  return ref.watch(userPreferencesProvider).textScale;
});

/// Provider for current language (convenience)
final languageProvider = Provider<AppLanguage>((ref) {
  return ref.watch(userPreferencesProvider).language;
});
