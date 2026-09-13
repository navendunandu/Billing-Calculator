import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/currency_format.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../domain/inventory_item_model.dart';
import 'providers/inventory_providers.dart';

class ManageItemsScreen extends ConsumerStatefulWidget {
  const ManageItemsScreen({super.key});

  @override
  ConsumerState<ManageItemsScreen> createState() => _ManageItemsScreenState();
}

class _ManageItemsScreenState extends ConsumerState<ManageItemsScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inventoryManagerProvider);
    final notifier = ref.read(inventoryManagerProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CommonAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to calculator',
          onPressed: () => context.go('/'),
        ),
        title: const Text('Inventory'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSizes.paddingLarge),
            child: FilledButton.icon(
              onPressed: () => context.push('/inventory/new'),
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.paddingLarge,
                AppSizes.paddingLarge,
                AppSizes.paddingLarge,
                AppSizes.paddingSmall,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: notifier.setSearchQuery,
                      decoration: InputDecoration(
                        hintText: 'Search items...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: state.searchQuery.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  notifier.setSearchQuery('');
                                },
                                icon: const Icon(Icons.close),
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacingSmall),
                  IconButton.filledTonal(
                    onPressed: () => _showFilterSheet(context),
                    tooltip: 'Filter and sort',
                    icon: const Icon(Icons.filter_alt_outlined),
                  ),
                ],
              ),
            ),
            if (state.errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingLarge,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    state.errorMessage!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: AppSizes.spacingSmall),
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.filteredItems.isEmpty
                  ? _EmptyInventory(
                      hasFilter:
                          state.searchQuery.isNotEmpty ||
                          state.selectedCategories.isNotEmpty ||
                          state.selectedBrands.isNotEmpty,
                    )
                  : RefreshIndicator(
                      onRefresh: () async {},
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          AppSizes.paddingLarge,
                          0,
                          AppSizes.paddingLarge,
                          AppSizes.paddingLarge,
                        ),
                        itemCount: state.filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = state.filteredItems[index];
                          return _InventoryItemTile(
                            item: item,
                            onEdit: () =>
                                context.push('/inventory/edit/${item.id}'),
                            onDelete: () => _confirmDelete(item.id, item.name),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _InventoryFilterSheet(),
    );
  }

  Future<void> _confirmDelete(int id, String name) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete item'),
          content: Text('Delete "$name" from inventory?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    final error = await ref
        .read(inventoryManagerProvider.notifier)
        .deleteItem(id);
    if (!mounted) {
      return;
    }

    messenger.showSnackBar(
      SnackBar(content: Text(error ?? 'Item deleted successfully')),
    );
  }
}

class _InventoryItemTile extends StatelessWidget {
  const _InventoryItemTile({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  final InventoryItemModel item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spacingMedium),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          child: isMobile
              ? _MobileLayout(
                  item: item,
                  theme: theme,
                  onEdit: onEdit,
                  onDelete: onDelete,
                )
              : _DesktopLayout(
                  item: item,
                  theme: theme,
                  onEdit: onEdit,
                  onDelete: onDelete,
                ),
        ),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.item,
    required this.theme,
    required this.onEdit,
    required this.onDelete,
  });

  final InventoryItemModel item;
  final ThemeData theme;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row: Image, Title, Menu
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ItemImage(path: item.imagePath),
            const SizedBox(width: AppSizes.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.code,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingXSmall),
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingXSmall),
                  _StatusChip(status: item.status),
                ],
              ),
            ),
            _ItemMenu(onEdit: onEdit, onDelete: onDelete),
          ],
        ),
        const SizedBox(height: AppSizes.spacingMedium),

        // Price and quantity
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingSmall),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price', style: theme.textTheme.labelSmall),
                  Text(
                    CurrencyFormatter.format(item.price),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Quantity', style: theme.textTheme.labelSmall),
                  Text(
                    '${item.unitValue} ${item.uom.label}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.spacingSmall),

        // Category and Brand
        Row(
          children: [
            Expanded(
              child: _InfoChip(label: 'Category', value: item.category),
            ),
            const SizedBox(width: AppSizes.spacingSmall),
            Expanded(
              child: _InfoChip(label: 'Brand', value: item.brand),
            ),
          ],
        ),
      ],
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.item,
    required this.theme,
    required this.onEdit,
    required this.onDelete,
  });

  final InventoryItemModel item;
  final ThemeData theme;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ItemImage(path: item.imagePath),
        const SizedBox(width: AppSizes.spacingMedium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSizes.spacingXSmall),
              Text(
                '${CurrencyFormatter.format(item.price)} / ${item.unitValue} ${item.uom.label} | ${item.category} | ${item.brand}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
              const SizedBox(height: AppSizes.spacingXSmall),
              Row(
                children: [
                  _StatusChip(status: item.status),
                  const SizedBox(width: AppSizes.spacingSmall),
                  Text('Code: ${item.code}', style: theme.textTheme.bodySmall),
                  if (item.taxRate > 0) ...[
                    const SizedBox(width: AppSizes.spacingSmall),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentBackground,
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusSmall,
                        ),
                      ),
                      child: Text(
                        item.taxLabel,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        _ItemMenu(onEdit: onEdit, onDelete: onDelete),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSmall,
        vertical: AppSizes.spacingXSmall,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemMenu extends StatelessWidget {
  const _ItemMenu({required this.onEdit, required this.onDelete});

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') {
          onEdit();
        }
        if (value == 'delete') {
          onDelete();
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
        PopupMenuItem<String>(value: 'delete', child: Text('Delete')),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final InventoryStatus status;

  @override
  Widget build(BuildContext context) {
    late final Color color;
    late final String label;

    switch (status) {
      case InventoryStatus.available:
        color = AppColors.success;
        label = 'Available';
        break;
      case InventoryStatus.outOfStock:
        color = AppColors.warning;
        label = 'Out of stock';
        break;
      case InventoryStatus.archived:
        color = Colors.grey;
        label = 'Archived';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _ItemImage extends StatelessWidget {
  const _ItemImage({required this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    final imagePath = path?.trim();
    final file = imagePath != null && imagePath.isNotEmpty
        ? File(imagePath)
        : null;
    final hasImage = file != null && file.existsSync();

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      child: Container(
        width: 76,
        height: 76,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: hasImage
            ? Image.file(file, fit: BoxFit.cover)
            : const Icon(Icons.inventory_2_outlined),
      ),
    );
  }
}

class _EmptyInventory extends StatelessWidget {
  const _EmptyInventory({required this.hasFilter});

  final bool hasFilter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 56,
              color: theme.colorScheme.primary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: AppSizes.spacingMedium),
            Text(
              hasFilter ? 'No matching items found' : 'No inventory items yet',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSizes.spacingSmall),
            Text(
              hasFilter
                  ? 'Try a different search or clear filters.'
                  : 'Tap Add Item to create your first product.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _InventoryFilterSheet extends ConsumerWidget {
  const _InventoryFilterSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inventoryManagerProvider);
    final notifier = ref.read(inventoryManagerProvider.notifier);
    final hasActiveFilters =
        state.selectedCategories.isNotEmpty ||
        state.selectedBrands.isNotEmpty ||
        state.sortOrder != InventorySortOrder.nameAZ;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.paddingLarge,
          AppSizes.paddingLarge,
          AppSizes.paddingLarge,
          AppSizes.paddingLarge,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Filter Inventory',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    label: const Text('Close'),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spacingLarge),
              const Text(
                'Filter by Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSizes.spacingSmall),
              Wrap(
                spacing: AppSizes.spacingSmall,
                runSpacing: AppSizes.spacingSmall,
                children: [
                  for (final category in state.allCategories)
                    FilterChip(
                      selected: state.selectedCategories.contains(category),
                      label: Text(category),
                      onSelected: (_) => notifier.toggleCategory(category),
                    ),
                ],
              ),
              const SizedBox(height: AppSizes.spacingLarge),
              const Text(
                'Filter by Brand',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSizes.spacingSmall),
              Wrap(
                spacing: AppSizes.spacingSmall,
                runSpacing: AppSizes.spacingSmall,
                children: [
                  for (final brand in state.allBrands)
                    FilterChip(
                      selected: state.selectedBrands.contains(brand),
                      label: Text(brand),
                      onSelected: (_) => notifier.toggleBrand(brand),
                    ),
                ],
              ),
              const SizedBox(height: AppSizes.spacingLarge),
              const Text(
                'Sort By',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSizes.spacingSmall),
              DropdownButtonFormField<InventorySortOrder>(
                initialValue: state.sortOrder,
                decoration: const InputDecoration(labelText: 'Sort order'),
                items: const [
                  DropdownMenuItem(
                    value: InventorySortOrder.nameAZ,
                    child: Text('Name (A-Z)'),
                  ),
                  DropdownMenuItem(
                    value: InventorySortOrder.nameZA,
                    child: Text('Name (Z-A)'),
                  ),
                  DropdownMenuItem(
                    value: InventorySortOrder.priceLowHigh,
                    child: Text('Price (Low-High)'),
                  ),
                  DropdownMenuItem(
                    value: InventorySortOrder.priceHighLow,
                    child: Text('Price (High-Low)'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    notifier.setSortOrder(value);
                  }
                },
              ),
              const SizedBox(height: AppSizes.spacingLarge),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: hasActiveFilters
                          ? () async {
                              final shouldClear = await showConfirmationDialog(
                                context,
                                title: 'Clear all filters',
                                message:
                                    'Reset category, brand, and sort filters?',
                                confirmLabel: 'Clear All',
                                isDestructive: true,
                              );

                              if (!shouldClear || !context.mounted) {
                                return;
                              }

                              notifier.clearFilters();
                            }
                          : null,
                      child: const Text('Clear All'),
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacingMedium),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
