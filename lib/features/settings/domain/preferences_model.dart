import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported languages in the app
enum AppLanguage {
  english('en', 'English'),
  malayalam('ml', 'മലയാളം'),
  hindi('hi', 'हिंदी'),
  tamil('ta', 'தமிழ்');

  const AppLanguage(this.code, this.displayName);
  final String code;
  final String displayName;

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}

/// Theme mode options
enum AppThemeMode {
  light,
  dark,
  contrast;

  static AppThemeMode fromString(String value) {
    return AppThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => AppThemeMode.light,
    );
  }
}

/// User preferences model
class UserPreferences {
  const UserPreferences({
    this.themeMode = AppThemeMode.light,
    this.language = AppLanguage.english,
    this.textScale = 1.0,
    this.contrastMode = false,
    this.hapticFeedback = true,
    this.creditPaymentEnabled = true,
    this.upiPaymentEnabled = true,
    this.upiId = '',
    this.gstBillingEnabled = true,
    this.storeGstin = '',
    this.storeName = '',
  });

  final AppThemeMode themeMode;
  final AppLanguage language;
  final double textScale;
  final bool contrastMode;
  final bool hapticFeedback;
  final bool creditPaymentEnabled;
  final bool upiPaymentEnabled;
  final String upiId;
  final bool gstBillingEnabled;
  final String storeGstin;
  final String storeName;

  /// Create preferences from SharedPreferences
  factory UserPreferences.fromPrefs(SharedPreferences prefs) {
    try {
      final textScale = prefs.getDouble('textScale') ?? 1.0;
      // Validate text scale is within reasonable bounds
      final validTextScale = textScale > 0 && textScale <= 3.0
          ? textScale
          : 1.0;

      return UserPreferences(
        themeMode: AppThemeMode.fromString(
          prefs.getString('themeMode') ?? 'light',
        ),
        language: AppLanguage.fromCode(prefs.getString('language') ?? 'en'),
        textScale: validTextScale,
        contrastMode: prefs.getBool('contrastMode') ?? false,
        hapticFeedback: prefs.getBool('hapticFeedback') ?? true,
        creditPaymentEnabled: prefs.getBool('creditPaymentEnabled') ?? true,
        upiPaymentEnabled: prefs.getBool('upiPaymentEnabled') ?? true,
        upiId: (prefs.getString('upiId') ?? '').trim(),
        gstBillingEnabled: prefs.getBool('gstBillingEnabled') ?? true,
        storeGstin: (prefs.getString('storeGstin') ?? '').trim(),
        storeName: (prefs.getString('storeName') ?? '').trim(),
      );
    } catch (e) {
      // If anything goes wrong, return defaults
      debugPrintStack(stackTrace: StackTrace.current);
      return const UserPreferences();
    }
  }

  /// Save preferences to SharedPreferences
  Future<void> saveToPrefs(SharedPreferences prefs) async {
    await prefs.setString('themeMode', themeMode.name);
    await prefs.setString('language', language.code);
    await prefs.setDouble('textScale', textScale);
    await prefs.setBool('contrastMode', contrastMode);
    await prefs.setBool('hapticFeedback', hapticFeedback);
    await prefs.setBool('creditPaymentEnabled', creditPaymentEnabled);
    await prefs.setBool('upiPaymentEnabled', upiPaymentEnabled);
    await prefs.setString('upiId', upiId);
    await prefs.setBool('gstBillingEnabled', gstBillingEnabled);
    await prefs.setString('storeGstin', storeGstin);
    await prefs.setString('storeName', storeName);
  }

  /// Copy with modified values
  UserPreferences copyWith({
    AppThemeMode? themeMode,
    AppLanguage? language,
    double? textScale,
    bool? contrastMode,
    bool? hapticFeedback,
    bool? creditPaymentEnabled,
    bool? upiPaymentEnabled,
    String? upiId,
    bool? gstBillingEnabled,
    String? storeGstin,
    String? storeName,
  }) {
    return UserPreferences(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      textScale: textScale ?? this.textScale,
      contrastMode: contrastMode ?? this.contrastMode,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      creditPaymentEnabled: creditPaymentEnabled ?? this.creditPaymentEnabled,
      upiPaymentEnabled: upiPaymentEnabled ?? this.upiPaymentEnabled,
      upiId: upiId ?? this.upiId,
      gstBillingEnabled: gstBillingEnabled ?? this.gstBillingEnabled,
      storeGstin: storeGstin ?? this.storeGstin,
      storeName: storeName ?? this.storeName,
    );
  }

  /// Get the locale for the current language
  Locale get locale => Locale(language.code);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserPreferences &&
        other.themeMode == themeMode &&
        other.language == language &&
        other.textScale == textScale &&
        other.contrastMode == contrastMode &&
        other.hapticFeedback == hapticFeedback &&
        other.creditPaymentEnabled == creditPaymentEnabled &&
        other.upiPaymentEnabled == upiPaymentEnabled &&
        other.upiId == upiId &&
        other.gstBillingEnabled == gstBillingEnabled &&
        other.storeGstin == storeGstin &&
        other.storeName == storeName;
  }

  @override
  int get hashCode {
    return Object.hash(
      themeMode,
      language,
      textScale,
      contrastMode,
      hapticFeedback,
      creditPaymentEnabled,
      upiPaymentEnabled,
      upiId,
      gstBillingEnabled,
      storeGstin,
      storeName,
    );
  }
}
