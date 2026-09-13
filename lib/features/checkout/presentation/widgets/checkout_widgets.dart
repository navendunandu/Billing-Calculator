import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/currency_format.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../calculator/domain/bill_item.dart';
import '../../../customers/domain/customer_model.dart';

class CheckoutSectionCard extends StatelessWidget {
  const CheckoutSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            ?trailing,
          ],
        ),
        const SizedBox(height: AppSizes.spacingMedium),
        child,
      ],
    );
  }
}

class CheckoutPaymentModeChip extends StatelessWidget {
  const CheckoutPaymentModeChip({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: isSelected,
      onSelected: (_) => onTap(),
      avatar: Icon(icon, size: 18, color: isSelected ? Colors.white : color),
      label: Text(label),
      selectedColor: color,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : null,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(color: color.withValues(alpha: 0.5)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
    );
  }
}

class CheckoutItemTile extends StatelessWidget {
  const CheckoutItemTile({super.key, required this.item, required this.index});

  final BillItem item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingSmall),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: theme.textTheme.titleSmall),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  children: [
                    Text(
                      '${CurrencyFormatter.formatQuantity(item.quantity)} × ${CurrencyFormatter.format(item.rate)}',
                      style: theme.textTheme.bodySmall,
                    ),
                    if (item.hasTax)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          '${item.taxRate.toStringAsFixed(item.taxRate % 1 == 0 ? 0 : 1)}% GST${item.isTaxInclusive ? '' : ' (+tax)'}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.primary,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            CurrencyFormatter.format(item.total),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class CheckoutSummaryRow extends StatelessWidget {
  const CheckoutSummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.isTotal = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                )
              : theme.textTheme.bodyLarge,
        ),
        Text(
          value,
          style: isTotal
              ? theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                )
              : theme.textTheme.titleMedium?.copyWith(
                  color: valueColor,
                  fontWeight: FontWeight.w600,
                ),
        ),
      ],
    );
  }
}

class CustomerCreditSummary extends StatelessWidget {
  const CustomerCreditSummary({
    super.key,
    required this.customer,
    required this.projectedPurchaseAmount,
  });

  final CustomerModel customer;
  final double projectedPurchaseAmount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dueAfterBill = customer.creditDue + projectedPurchaseAmount;
    final remainingAfterBill = customer.creditLimit - dueAfterBill;
    final isOverLimit = dueAfterBill > customer.creditLimit;
    final isLow =
        !isOverLimit && remainingAfterBill <= (customer.creditLimit * 0.2);
    final warningColor = isOverLimit
        ? AppColors.error
        : isLow
        ? Colors.orange.shade700
        : AppColors.success;
    final warningText = isOverLimit
        ? 'Credit limit exceeded'
        : isLow
        ? 'Credit limit is running low'
        : null;

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: warningColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(color: warningColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current due: ${CurrencyFormatter.format(customer.creditDue)}',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSizes.spacingSmall),
          Text(
            'Credit limit: ${CurrencyFormatter.format(customer.creditLimit)}',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSizes.spacingSmall),
          Text(
            'After this bill: ${CurrencyFormatter.format(dueAfterBill)}',
            style: theme.textTheme.bodyMedium,
          ),
          if (warningText != null) ...[
            const SizedBox(height: AppSizes.spacingSmall),
            Text(
              warningText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: warningColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          if (isOverLimit) ...[
            const SizedBox(height: AppSizes.spacingSmall),
            Text(
              'Over by ${CurrencyFormatter.format(dueAfterBill - customer.creditLimit)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: warningColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class UpiQrPaymentScreen extends StatelessWidget {
  const UpiQrPaymentScreen({
    super.key,
    required this.amount,
    required this.upiId,
  });

  final double amount;
  final String upiId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final upiUri = Uri(
      scheme: 'upi',
      host: 'pay',
      queryParameters: {
        'pa': upiId,
        'pn': 'Store Billing',
        'am': amount.toStringAsFixed(2),
        'cu': 'INR',
        'tn': 'Invoice Payment',
      },
    ).toString();

    return Scaffold(
      appBar: AppBar(title: const Text('UPI Payment')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Ask customer to scan and pay',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: AppSizes.spacingSmall),
              Text(
                'Amount: ${CurrencyFormatter.format(amount)}',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSizes.spacingLarge),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.paddingMedium),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: QrImageView(
                    data: upiUri,
                    version: QrVersions.auto,
                    size: 240,
                    gapless: false,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spacingMedium),
              Text(
                'UPI ID: $upiId',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Cancel',
                      isOutlined: true,
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacingMedium),
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      label: 'Payment Received',
                      icon: Icons.check_circle,
                      onPressed: () => Navigator.of(context).pop(true),
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
