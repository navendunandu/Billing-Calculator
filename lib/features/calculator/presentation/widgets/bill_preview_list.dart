import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_format.dart';
import '../../domain/bill_item.dart';
import '../providers/calculator_providers.dart';

/// Preview list of current bill items
class BillPreviewList extends ConsumerWidget {
  const BillPreviewList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calcState = ref.watch(calculatorProvider);
    final theme = Theme.of(context);

    if (calcState.billItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppSizes.spacingMedium),
            Text(
              'No items in bill',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: AppSizes.spacingSmall),
            Text(
              'Enter Qty × Rate and press + to add',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: calcState.billItems.length,
      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingSmall),
      itemBuilder: (context, index) {
        final item = calcState.billItems[index];
        return _BillItemTile(
          item: item,
          index: index,
          onDelete: () {
            ref.read(calculatorProvider.notifier).removeItem(index);
          },
        );
      },
    );
  }
}

/// Individual bill item tile with swipe to delete
class _BillItemTile extends StatelessWidget {
  const _BillItemTile({
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Item number
            Container(
              width: 32,
              height: 32,
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

            // Item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingXSmall),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    children: [
                      Text(
                        '${CurrencyFormatter.formatQuantity(item.quantity)} × ${CurrencyFormatter.format(item.rate)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                      if (item.hasTax)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${item.taxRate.toStringAsFixed(item.taxRate % 1 == 0 ? 0 : 1)}% GST${item.isTaxInclusive ? '' : ' (+tax)'}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Total
            Text(
              CurrencyFormatter.format(item.total),
              style: theme.textTheme.titleLarge?.copyWith(
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

/// Summary card showing bill total
class BillSummaryCard extends ConsumerWidget {
  const BillSummaryCard({super.key, this.onCheckout});

  final VoidCallback? onCheckout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calcState = ref.watch(calculatorProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingLarge),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXLarge),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Items count and total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      calcState.hasTax
                          ? '${calcState.itemCount} items • GST: ${CurrencyFormatter.format(calcState.totalTaxAmount)}'
                          : '${calcState.itemCount} items',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingXSmall),
                    Text('Total', style: theme.textTheme.titleMedium),
                  ],
                ),
                Text(
                  CurrencyFormatter.format(calcState.subtotal),
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacingLarge),

            // Checkout button
            SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeightLarge,
              child: ElevatedButton.icon(
                onPressed: calcState.billItems.isEmpty ? null : onCheckout,
                icon: const Icon(Icons.shopping_cart_checkout, size: 24),
                label: const Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: AppSizes.fontSizeXLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.primary.withValues(
                    alpha: 0.3,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
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
