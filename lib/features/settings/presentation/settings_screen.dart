import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../settings/domain/preferences_model.dart';

/// Settings screen for theme, language, and accessibility options
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(userPreferencesProvider);
    final prefsNotifier = ref.read(userPreferencesProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CommonAppBar(title: Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        children: [
          // Theme Section
          _SettingsSection(
            title: 'Appearance',
            children: [
              _SettingsTile(
                icon: Icons.light_mode,
                title: 'Theme',
                subtitle: _getThemeName(prefs.themeMode),
                onTap: () =>
                    _showThemeDialog(context, prefs.themeMode, prefsNotifier),
              ),
              _SettingsTile(
                icon: Icons.contrast,
                title: 'High Contrast Mode',
                subtitle: 'Enhanced visibility for accessibility',
                trailing: Switch(
                  value: prefs.contrastMode,
                  onChanged: (value) => prefsNotifier.setContrastMode(value),
                  activeThumbColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacingLarge),

          // Text Size Section
          _SettingsSection(
            title: 'Text Size',
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingLarge,
                  vertical: AppSizes.paddingMedium,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('A', style: TextStyle(fontSize: 14)),
                        Text(
                          '${(prefs.textScale * 100).round()}%',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const Text('A', style: TextStyle(fontSize: 24)),
                      ],
                    ),
                    Slider(
                      value: prefs.textScale,
                      min: AppSizes.textScaleMin,
                      max: AppSizes.textScaleMax,
                      divisions: 6,
                      activeColor: AppColors.primary,
                      onChanged: (value) => prefsNotifier.setTextScale(value),
                    ),
                    // Preview text
                    Container(
                      padding: const EdgeInsets.all(AppSizes.paddingMedium),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusMedium,
                        ),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: Text(
                        'Preview: This is how text will appear in the app.',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacingLarge),

          // Payment Section
          _SettingsSection(
            title: 'Payments',
            children: [
              _SettingsTile(
                icon: Icons.phone_android,
                title: 'Enable UPI Payment',
                subtitle: 'Show UPI in checkout and generate payment QR',
                trailing: Switch(
                  value: prefs.upiPaymentEnabled,
                  onChanged: (value) => _handleUpiToggle(
                    context,
                    enabled: value,
                    currentUpiId: prefs.upiId,
                    notifier: prefsNotifier,
                  ),
                  activeThumbColor: AppColors.primary,
                ),
              ),
              if (prefs.upiPaymentEnabled)
                _SettingsTile(
                  icon: Icons.qr_code_2,
                  title: 'UPI ID',
                  subtitle: prefs.upiId.trim().isEmpty
                      ? 'Tap to enter UPI ID'
                      : prefs.upiId,
                  trailing: const Icon(Icons.edit_outlined),
                  onTap: () => _openUpiIdModalAndSave(
                    context,
                    currentUpiId: prefs.upiId,
                    notifier: prefsNotifier,
                  ),
                ),
              _SettingsTile(
                icon: Icons.credit_card,
                title: 'Enable Credit Payment',
                subtitle: 'Show credit checkout and customer management',
                trailing: Switch(
                  value: prefs.creditPaymentEnabled,
                  onChanged: (value) =>
                      prefsNotifier.setCreditPaymentEnabled(value),
                  activeThumbColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacingLarge),

          // Tax & GST Section
          _SettingsSection(
            title: 'Tax & GST',
            children: [
              _SettingsTile(
                icon: Icons.receipt_long,
                title: 'Enable GST Billing',
                subtitle: 'Compute GST breakdown and taxes on bills & invoices',
                trailing: Switch(
                  value: prefs.gstBillingEnabled,
                  onChanged: (value) =>
                      prefsNotifier.setGstBillingEnabled(value),
                  activeThumbColor: AppColors.primary,
                ),
              ),
              if (prefs.gstBillingEnabled) ...[
                _SettingsTile(
                  icon: Icons.badge_outlined,
                  title: 'Store GSTIN',
                  subtitle: prefs.storeGstin.isEmpty
                      ? 'Tap to enter GSTIN (e.g. 27AAAAA0000A1Z5)'
                      : prefs.storeGstin,
                  trailing: const Icon(Icons.edit_outlined),
                  onTap: () => _openGstinModalAndSave(
                    context,
                    currentGstin: prefs.storeGstin,
                    notifier: prefsNotifier,
                  ),
                ),
                _SettingsTile(
                  icon: Icons.storefront_outlined,
                  title: 'Store Name',
                  subtitle: prefs.storeName.isEmpty
                      ? 'Tap to enter store / business name'
                      : prefs.storeName,
                  trailing: const Icon(Icons.edit_outlined),
                  onTap: () => _openStoreNameModalAndSave(
                    context,
                    currentStoreName: prefs.storeName,
                    notifier: prefsNotifier,
                  ),
                ),
                _SettingsTile(
                  icon: Icons.table_chart_outlined,
                  title: 'HSN & Tax Slabs',
                  subtitle: 'Manage HSN codes and GST rates catalog',
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => context.push('/hsn'),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSizes.spacingLarge),

          // // Language Section
          // _SettingsSection(
          //   title: 'Language',
          //   children: [
          //     for (final lang in AppLanguage.values)
          //       _SettingsTile(
          //         icon: Icons.language,
          //         title: lang.displayName,
          //         trailing: prefs.language == lang
          //             ? Icon(Icons.check_circle, color: AppColors.primary)
          //             : null,
          //         onTap: () => prefsNotifier.setLanguage(lang),
          //       ),
          //   ],
          // ),
          // const SizedBox(height: AppSizes.spacingLarge),

          // Haptic Feedback
          _SettingsSection(
            title: 'Feedback',
            children: [
              _SettingsTile(
                icon: Icons.vibration,
                title: 'Haptic Feedback',
                subtitle: 'Vibrate on button press',
                trailing: Switch(
                  value: prefs.hapticFeedback,
                  onChanged: (value) => prefsNotifier.setHapticFeedback(value),
                  activeThumbColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacingXLarge),

          // App Info
          Center(
            child: Column(
              children: [
                Text('Store Billing v1.0.0', style: theme.textTheme.bodySmall),
                const SizedBox(height: AppSizes.spacingXSmall),
                Text(
                  'Made with ❤️',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withValues(
                      alpha: 0.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spacingXLarge),
        ],
      ),
    );
  }

  String _getThemeName(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.contrast:
        return 'High Contrast';
    }
  }

  void _showThemeDialog(
    BuildContext context,
    AppThemeMode current,
    UserPreferencesNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ThemeOption(
              icon: Icons.light_mode,
              label: 'Light',
              isSelected: current == AppThemeMode.light,
              onTap: () {
                notifier.setThemeMode(AppThemeMode.light);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: AppSizes.spacingSmall),
            _ThemeOption(
              icon: Icons.dark_mode,
              label: 'Dark',
              isSelected: current == AppThemeMode.dark,
              onTap: () {
                notifier.setThemeMode(AppThemeMode.dark);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleUpiToggle(
    BuildContext context, {
    required bool enabled,
    required String currentUpiId,
    required UserPreferencesNotifier notifier,
  }) async {
    if (!enabled) {
      await notifier.setUpiPaymentEnabled(false);
      return;
    }

    await notifier.setUpiPaymentEnabled(true);

    if (!context.mounted) {
      return;
    }

    final enteredUpiId = await _showUpiIdDialog(
      context,
      currentUpiId: currentUpiId,
    );

    if (!context.mounted) {
      return;
    }

    if (enteredUpiId == null) {
      if (currentUpiId.trim().isEmpty) {
        await notifier.setUpiPaymentEnabled(false);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('UPI ID is required to enable UPI payment'),
            ),
          );
        }
      }
      return;
    }

    await notifier.setUpiId(enteredUpiId);
  }

  Future<void> _openUpiIdModalAndSave(
    BuildContext context, {
    required String currentUpiId,
    required UserPreferencesNotifier notifier,
  }) async {
    final enteredUpiId = await _showUpiIdDialog(
      context,
      currentUpiId: currentUpiId,
    );

    if (enteredUpiId == null) {
      return;
    }

    await notifier.setUpiId(enteredUpiId);
  }

  Future<String?> _showUpiIdDialog(
    BuildContext context, {
    required String currentUpiId,
  }) {
    final controller = TextEditingController(text: currentUpiId);
    String? errorText;

    return showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                currentUpiId.trim().isEmpty ? 'Enter UPI ID' : 'Confirm UPI ID',
              ),
              content: TextField(
                controller: controller,
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'UPI ID',
                  hintText: 'shop@upi',
                  prefixIcon: const Icon(Icons.qr_code_2),
                  errorText: errorText,
                ),
                onSubmitted: (_) {
                  final value = controller.text.trim();
                  if (!_isValidUpiId(value)) {
                    setDialogState(() {
                      errorText = 'Enter a valid UPI ID (example: shop@upi)';
                    });
                    return;
                  }
                  Navigator.of(dialogContext).pop(value);
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final value = controller.text.trim();
                    if (!_isValidUpiId(value)) {
                      setDialogState(() {
                        errorText = 'Enter a valid UPI ID (example: shop@upi)';
                      });
                      return;
                    }
                    Navigator.of(dialogContext).pop(value);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  bool _isValidUpiId(String value) {
    return value.contains('@') && value.length >= 5;
  }

  Future<void> _openGstinModalAndSave(
    BuildContext context, {
    required String currentGstin,
    required UserPreferencesNotifier notifier,
  }) async {
    final controller = TextEditingController(text: currentGstin);
    String? errorText;

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            currentGstin.isEmpty ? 'Enter Store GSTIN' : 'Edit Store GSTIN',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  labelText: 'GSTIN (15 characters)',
                  hintText: 'e.g. 27AAAAA0000A1Z5',
                  prefixIcon: const Icon(Icons.badge_outlined),
                  errorText: errorText,
                ),
                onSubmitted: (_) {
                  final text = controller.text.trim().toUpperCase();
                  if (text.isNotEmpty && text.length != 15) {
                    setDialogState(() {
                      errorText = 'GSTIN should be 15 alphanumeric characters';
                    });
                    return;
                  }
                  Navigator.of(dialogContext).pop(text);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final text = controller.text.trim().toUpperCase();
                if (text.isNotEmpty && text.length != 15) {
                  setDialogState(() {
                    errorText = 'GSTIN should be 15 alphanumeric characters';
                  });
                  return;
                }
                Navigator.of(dialogContext).pop(text);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      await notifier.setStoreGstin(result);
    }
  }

  Future<void> _openStoreNameModalAndSave(
    BuildContext context, {
    required String currentStoreName,
    required UserPreferencesNotifier notifier,
  }) async {
    final controller = TextEditingController(text: currentStoreName);

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          currentStoreName.isEmpty ? 'Enter Store Name' : 'Edit Store Name',
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Business / Store Name',
            hintText: 'e.g. Super Mart',
            prefixIcon: Icon(Icons.storefront_outlined),
          ),
          onSubmitted: (value) =>
              Navigator.of(dialogContext).pop(value.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null) {
      await notifier.setStoreName(result);
    }
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSizes.paddingSmall,
            bottom: AppSizes.spacingSmall,
          ),
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: subtitle != null
          ? Text(subtitle!, style: theme.textTheme.bodySmall)
          : null,
      trailing:
          trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.primary : null),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.primary : null,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : null,
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
    );
  }
}
