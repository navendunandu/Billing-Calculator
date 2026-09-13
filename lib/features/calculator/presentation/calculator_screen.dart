import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_format.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import 'providers/calculator_providers.dart';
import '../domain/bill_item.dart';
import '../../inventory/domain/inventory_item_model.dart';
import '../../inventory/presentation/providers/inventory_providers.dart';
import 'widgets/calc_display.dart';
import 'widgets/calc_keypad.dart';
import 'widgets/app_drawer.dart';
import 'widgets/all_items_modal.dart';

/// Main calculator/billing screen
class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({super.key});

  @override
  ConsumerState<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen> {
  late final PageController _pageController;
  late final TextEditingController _searchController;
  bool _isShowingExitDialog = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final calcState = ref.watch(calculatorProvider);
    final inventoryState = ref.watch(inventoryManagerProvider);
    final inventoryNotifier = ref.read(inventoryManagerProvider.notifier);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        _confirmAndExitApp();
      },
      child: Scaffold(
        appBar: CommonAppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: const SizedBox.shrink(),
          actions: [
            // Checkout button with total in app bar
            _AppBarCheckoutButton(
              itemCount: calcState.itemCount,
              totalAmount: calcState.subtotal,
              onPressed: calcState.billItems.isEmpty
                  ? null
                  : () => context.push('/checkout'),
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableHeight = constraints.maxHeight;
              // Don't show items section if height <= 600dp
              final showItems = availableHeight > 600;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Responsive items section - only show on larger screens
                  if (showItems)
                    _ItemsSection(
                      items: calcState.billItems,
                      onViewAll: () => _showAllItemsModal(context),
                      onDeleteItem: (index) {
                        ref.read(calculatorProvider.notifier).removeItem(index);
                      },
                    ),
                  // Expandable middle section with calculator/inventory
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      children: [
                        _CalculatorPage(),
                        _InventoryBrowserPage(
                          state: inventoryState,
                          onSearchChanged: inventoryNotifier.setSearchQuery,
                          searchController: _searchController,
                          onOpenFilters: () => _showInventoryFilters(context),
                          onOpenScanner: () => context.push('/scanner'),
                          onItemTap: (item) => _showAddItemModal(context, item),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showAllItemsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AllItemsModal(),
    );
  }

  void _showInventoryFilters(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _InventoryFilterSheet(),
    );
  }

  void _showAddItemModal(BuildContext context, InventoryItemModel item) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return _AddToCartModal(
          item: item,
          onAddToCart: (quantity) {
            final notifier = ref.read(calculatorProvider.notifier);

            final newItem = BillItem(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              inventoryItemId: item.id,
              barcode: item.barcode,
              name: item.name,
              quantity: quantity,
              rate: item.price,
              hsnCode: item.hsnCode,
              taxRate: item.taxRate,
              isTaxInclusive: item.isTaxInclusive,
            );

            final mergedIntoExisting = notifier.addBillItem(newItem);

            if (!mounted) {
              return;
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  mergedIntoExisting
                      ? '${item.name} quantity updated in cart'
                      : '${item.name} added to cart',
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _confirmAndExitApp() async {
    if (_isShowingExitDialog) {
      return;
    }

    _isShowingExitDialog = true;
    final shouldExit = await showConfirmationDialog(
      context,
      title: 'Exit app',
      message: 'Are you sure you want to exit the app?',
      confirmLabel: 'Exit',
      isDestructive: true,
    );
    _isShowingExitDialog = false;

    if (!shouldExit || !mounted) {
      return;
    }

    if (Platform.isAndroid) {
      await SystemNavigator.pop();
      return;
    }

    await ServicesBinding.instance.exitApplication(ui.AppExitType.required);
  }
}

class _CalculatorPage extends StatelessWidget {
  const _CalculatorPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Expandable spacer
        const Expanded(child: SizedBox.shrink()),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.paddingMedium,
            AppSizes.spacingSmall,
            AppSizes.paddingMedium,
            AppSizes.paddingSmall,
          ),
          child: Container(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.swipe_right_alt, size: 18),
                const SizedBox(width: AppSizes.spacingSmall),
                Expanded(
                  child: Text(
                    'Swipe left to browse inventory',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Calculator display
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
          child: CalcDisplay(),
        ),
        const SizedBox(height: AppSizes.spacingSmall),

        // Calculator keypad
        const Padding(
          padding: EdgeInsets.only(
            left: AppSizes.paddingMedium,
            right: AppSizes.paddingMedium,
            bottom: AppSizes.spacingSmall,
          ),
          child: CalcKeypad(),
        ),
      ],
    );
  }
}

class _InventoryBrowserPage extends StatelessWidget {
  const _InventoryBrowserPage({
    required this.state,
    required this.onSearchChanged,
    required this.searchController,
    required this.onOpenFilters,
    required this.onOpenScanner,
    required this.onItemTap,
  });

  final InventoryManageState state;
  final ValueChanged<String> onSearchChanged;
  final TextEditingController searchController;
  final VoidCallback onOpenFilters;
  final VoidCallback onOpenScanner;
  final ValueChanged<InventoryItemModel> onItemTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasFilters =
        state.searchQuery.isNotEmpty ||
        state.selectedCategories.isNotEmpty ||
        state.selectedBrands.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.paddingMedium,
            AppSizes.paddingMedium,
            AppSizes.paddingMedium,
            AppSizes.spacingSmall,
          ),
          child: Container(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.swipe_left_alt, size: 18),
                const SizedBox(width: AppSizes.spacingSmall),
                Expanded(
                  child: Text(
                    'Swipe right to return to the calculator',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingMedium,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search items...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: state.searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              searchController.clear();
                              onSearchChanged('');
                            },
                            icon: const Icon(Icons.close),
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.spacingSmall),
              IconButton.filledTonal(
                onPressed: onOpenScanner,
                tooltip: 'Scan barcode',
                icon: const Icon(Icons.barcode_reader),
              ),
              const SizedBox(width: AppSizes.spacingSmall),
              IconButton.filledTonal(
                onPressed: onOpenFilters,
                tooltip: 'Filter inventory',
                icon: const Icon(Icons.filter_alt_outlined),
              ),
            ],
          ),
        ),
        if (hasFilters)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.paddingMedium,
              AppSizes.spacingSmall,
              AppSizes.paddingMedium,
              0,
            ),
            child: Wrap(
              spacing: AppSizes.spacingSmall,
              runSpacing: AppSizes.spacingSmall,
              children: [
                if (state.searchQuery.isNotEmpty)
                  InputChip(
                    label: Text('Search: ${state.searchQuery}'),
                    onDeleted: () {
                      searchController.clear();
                      onSearchChanged('');
                    },
                  ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.paddingMedium,
            AppSizes.spacingSmall,
            AppSizes.paddingMedium,
            AppSizes.spacingSmall,
          ),
          child: Text(
            state.filteredItems.isEmpty
                ? 'No matching inventory items'
                : '${state.filteredItems.length} items found',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ),
        Expanded(
          child: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : state.filteredItems.isEmpty
              ? _EmptyInventory(hasFilter: hasFilters)
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.paddingMedium,
                    0,
                    AppSizes.paddingMedium,
                    AppSizes.paddingMedium,
                  ),
                  itemCount: state.filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = state.filteredItems[index];
                    return _SwipeInventoryTile(
                      item: item,
                      onTap: () => onItemTap(item),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _AddToCartModal extends StatefulWidget {
  const _AddToCartModal({required this.item, required this.onAddToCart});

  final InventoryItemModel item;
  final ValueChanged<double> onAddToCart;

  @override
  State<_AddToCartModal> createState() => _AddToCartModalState();
}

class _AddToCartModalState extends State<_AddToCartModal> {
  late final TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: '1');
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  double get _quantity {
    return double.tryParse(_quantityController.text.trim()) ?? 0;
  }

  void _incrementQuantity() {
    final next = _quantity + 1;
    _quantityController.text = next == next.roundToDouble()
        ? next.toInt().toString()
        : next.toStringAsFixed(2);
    setState(() {});
  }

  void _decrementQuantity() {
    final next = (_quantity - 1).clamp(0.0, double.infinity);
    _quantityController.text = next == next.roundToDouble()
        ? next.toInt().toString()
        : next.toStringAsFixed(2);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final quantity = _quantity;
    final total = quantity * widget.item.price;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.paddingLarge,
        right: AppSizes.paddingLarge,
        top: AppSizes.paddingLarge,
        bottom:
            MediaQuery.of(context).viewInsets.bottom + AppSizes.paddingLarge,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Add Item',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacingSmall),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ItemImagePreview(path: widget.item.imagePath),
                  const SizedBox(height: AppSizes.spacingMedium),
                  Text(
                    widget.item.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingXSmall),
                  Text(
                    'Rate: ${CurrencyFormatter.format(widget.item.price)}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.spacingMedium),
            Row(
              children: [
                IconButton.filledTonal(
                  onPressed: _decrementQuantity,
                  icon: const Icon(Icons.remove),
                ),
                const SizedBox(width: AppSizes.spacingSmall),
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textAlign: TextAlign.center,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      hintText: 'Enter quantity',
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.spacingSmall),
                IconButton.filledTonal(
                  onPressed: _incrementQuantity,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacingMedium),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Qty: ${CurrencyFormatter.formatQuantity(quantity)}'),
                  const SizedBox(height: AppSizes.spacingXSmall),
                  Text('Rate: ${CurrencyFormatter.format(widget.item.price)}'),
                  const SizedBox(height: AppSizes.spacingXSmall),
                  Text(
                    'Total: ${CurrencyFormatter.format(total)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.spacingLarge),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: quantity <= 0
                    ? null
                    : () {
                        widget.onAddToCart(quantity);
                        Navigator.of(context).pop();
                      },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemImagePreview extends StatelessWidget {
  const _ItemImagePreview({required this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    final imagePath = path?.trim();
    final file = imagePath != null && imagePath.isNotEmpty
        ? File(imagePath)
        : null;
    final hasImage = file != null && file.existsSync();
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      child: Container(
        width: double.infinity,
        height: 160,
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        child: hasImage
            ? Image.file(file, fit: BoxFit.cover)
            : const Center(child: Icon(Icons.inventory_2_outlined, size: 48)),
      ),
    );
  }
}

/// Compact checkout button for app bar
class _AppBarCheckoutButton extends StatelessWidget {
  const _AppBarCheckoutButton({
    required this.itemCount,
    required this.totalAmount,
    this.onPressed,
  });

  final int itemCount;
  final double totalAmount;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSizes.paddingMedium),
      child: Material(
        color: onPressed != null
            ? AppColors.primary
            : AppColors.primary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMedium,
              vertical: AppSizes.spacingSmall,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cart icon with badge
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                      size: 20,
                    ),
                    if (itemCount > 0)
                      Positioned(
                        top: -6,
                        right: -8,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            itemCount > 99 ? '99+' : itemCount.toString(),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: AppSizes.spacingSmall),

                // Total amount
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(totalAmount),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: AppSizes.spacingSmall),

                // Arrow
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Items section with original card design
class _ItemsSection extends StatelessWidget {
  const _ItemsSection({
    required this.items,
    required this.onViewAll,
    required this.onDeleteItem,
  });

  final List<BillItem> items;
  final VoidCallback onViewAll;
  final Function(int index) onDeleteItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Empty state
    if (items.isEmpty) {
      return Container(
        // margin: const EdgeInsets.all(AppSizes.paddingMedium),
        padding: const EdgeInsets.all(AppSizes.paddingXLarge),
        decoration: BoxDecoration(
          color: theme.cardColor,
          // borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          // border: Border.all(color: theme.dividerColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'No items in bill',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: AppSizes.spacingSmall),
            Text(
              'Enter Rate × Qty and press + to add',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    // Display only the last 1 item
    final lastItem = items.last;
    final lastItemIndex = items.length - 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Show last item only
        _ItemCard(
          item: lastItem,
          index: lastItemIndex,
          onDelete: () => onDeleteItem(lastItemIndex),
        ),

        // View All button if more than 1 item
        if (items.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMedium,
            ),
            child: TextButton.icon(
              onPressed: onViewAll,
              icon: const Icon(Icons.list, size: 18),
              label: Text('View all (${items.length})'),
            ),
          ),
      ],
    );
  }
}

class _SwipeInventoryTile extends StatelessWidget {
  const _SwipeInventoryTile({required this.item, required this.onTap});

  final InventoryItemModel item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spacingMedium),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(AppSizes.paddingMedium),
        leading: _InventoryThumbnail(path: item.imagePath),
        title: Text(
          item.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${item.code} • ${item.category} • ${item.brand}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
        ),
        trailing: Text(
          CurrencyFormatter.format(item.price),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _InventoryThumbnail extends StatelessWidget {
  const _InventoryThumbnail({required this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    final imagePath = path?.trim();
    final file = imagePath != null && imagePath.isNotEmpty
        ? File(imagePath)
        : null;
    final hasImage = file != null && file.existsSync();
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      child: Container(
        width: 52,
        height: 52,
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
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

/// Original item card design with swipe to delete
class _ItemCard extends StatelessWidget {
  const _ItemCard({
    required this.item,
    required this.index,
    required this.onDelete,
  });

  final BillItem item;
  final int index;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSizes.paddingLarge),
        color: AppColors.error,
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: AppSizes.iconSizeLarge,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMedium,
          vertical: AppSizes.spacingXSmall,
        ),
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            // Item number
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.spacingMedium),

            // Item name
            Expanded(
              child: Text(
                item.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Qty × Rate
            Text(
              '${CurrencyFormatter.formatQuantity(item.quantity)} × ${CurrencyFormatter.formatWithoutSymbol(item.rate)}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(width: AppSizes.spacingMedium),

            // Total
            Text(
              CurrencyFormatter.format(item.total),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
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
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
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
