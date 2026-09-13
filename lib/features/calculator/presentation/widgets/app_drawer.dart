import 'package:billing_app_pos/core/constants/app_images.dart';
import 'package:billing_app_pos/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/app_providers.dart';

/// Sidebar drawer for navigation
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final creditPaymentEnabled = ref
        .watch(userPreferencesProvider)
        .creditPaymentEnabled;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.paddingXLarge),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(AppImages.logo, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: AppSizes.spacingMedium),
                  Text(
                    AppStrings.appName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.spacingMedium),

            // Menu items
            _DrawerItem(
              icon: Icons.calculate,
              title: 'Calculator',
              isSelected: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _DrawerItem(
              icon: Icons.history,
              title: 'Invoice History',
              onTap: () {
                Navigator.pop(context);
                context.push('/invoices');
              },
            ),
            _DrawerItem(
              icon: Icons.inventory_2_outlined,
              title: 'Manage Items',
              onTap: () {
                Navigator.pop(context);
                context.push('/inventory');
              },
            ),
            if (creditPaymentEnabled)
              _DrawerItem(
                icon: Icons.people_alt_outlined,
                title: 'Manage Customers',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/customers');
                },
              ),
            _DrawerItem(
              icon: Icons.receipt_long_outlined,
              title: 'HSN & Tax Master',
              onTap: () {
                Navigator.pop(context);
                context.push('/hsn');
              },
            ),
            _DrawerItem(
              icon: Icons.category_outlined,
              title: 'Category Master',
              onTap: () {
                Navigator.pop(context);
                context.push('/categories');
              },
            ),
            _DrawerItem(
              icon: Icons.business_outlined,
              title: 'Brand Master',
              onTap: () {
                Navigator.pop(context);
                context.push('/brands');
              },
            ),
            _DrawerItem(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);
                context.push('/settings');
              },
            ),

            const Spacer(),

            // Footer
            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingLarge),
              child: Text(
                'v1.0.0',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withValues(
                    alpha: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isSelected = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.primary : null),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: isSelected ? AppColors.primary : null,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingLarge,
        vertical: AppSizes.spacingXSmall,
      ),
      onTap: onTap,
    );
  }
}
