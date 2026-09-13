import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_format.dart';
import '../../../core/database/tables/invoices.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../../core/widgets/top_notification_banner.dart';
import '../../calculator/presentation/providers/calculator_providers.dart';
import '../../calculator/domain/bill_item.dart';
import '../../customers/domain/customer_model.dart';
import '../../customers/presentation/providers/customer_providers.dart';
import '../../invoices/domain/invoice_model.dart';
import '../../invoices/presentation/providers/invoice_providers.dart';
import '../../settings/domain/preferences_model.dart';
import 'widgets/add_customer_modal.dart';
import 'widgets/checkout_widgets.dart';

/// Checkout screen for reviewing and saving invoice
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  PaymentMode _selectedPaymentMode = PaymentMode.cash;
  int? _selectedCustomerId;
  double _discountAmount = 0.0;
  final _notesController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validatePaymentModeRestrictions();
    });
  }

  void _validatePaymentModeRestrictions() {
    if (!mounted) return;

    final prefs = ref.read(userPreferencesProvider);
    final creditPaymentEnabled = prefs.creditPaymentEnabled;
    final upiPaymentEnabled = prefs.upiPaymentEnabled;

    bool needsReset = false;

    if (!creditPaymentEnabled && _selectedPaymentMode == PaymentMode.credit) {
      _selectedPaymentMode = PaymentMode.cash;
      _selectedCustomerId = null;
      needsReset = true;
    }

    if (!upiPaymentEnabled && _selectedPaymentMode == PaymentMode.upi) {
      _selectedPaymentMode = PaymentMode.cash;
      _selectedCustomerId = null;
      needsReset = true;
    }

    if (needsReset && mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(CheckoutScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _validatePaymentModeRestrictions();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final calcState = ref.watch(calculatorProvider);
    final prefs = ref.watch(userPreferencesProvider);
    final theme = Theme.of(context);
    final creditPaymentEnabled = prefs.creditPaymentEnabled;
    final upiPaymentEnabled = prefs.upiPaymentEnabled;

    if (calcState.billItems.isEmpty) {
      return Scaffold(
        appBar: const CommonAppBar(title: Text('Checkout')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 64,
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
              ),
              const SizedBox(height: AppSizes.spacingLarge),
              Text('Your cart is empty', style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSizes.spacingLarge),
              AppButton(
                label: 'Go Back',
                onPressed: () => context.pop(),
                width: 200,
              ),
            ],
          ),
        ),
      );
    }

    final subtotal = calcState.subtotal;
    final discountValue = _discountAmount;
    final grandTotal = subtotal - discountValue;

    return Scaffold(
      appBar: CommonAppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CheckoutSectionCard(
              title: 'Bill Items',
              trailing: Text(
                '${calcState.itemCount} items',
                style: theme.textTheme.bodySmall,
              ),
              child: Column(
                children: [
                  for (int i = 0; i < calcState.billItems.length; i++)
                    CheckoutItemTile(item: calcState.billItems[i], index: i),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.spacingLarge),
            CheckoutSectionCard(
              title: 'Discount',
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Enter discount',
                        prefixText: '₹ ',
                      ),
                      onChanged: (value) {
                        setState(() {
                          _discountAmount = double.tryParse(value) ?? 0.0;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.spacingLarge),
            CheckoutSectionCard(
              title: 'Payment Mode',
              child: Wrap(
                spacing: AppSizes.spacingSmall,
                runSpacing: AppSizes.spacingSmall,
                children: [
                  CheckoutPaymentModeChip(
                    label: 'Cash',
                    icon: Icons.money,
                    color: AppColors.cash,
                    isSelected: _selectedPaymentMode == PaymentMode.cash,
                    onTap: () {
                      setState(() {
                        _selectedPaymentMode = PaymentMode.cash;
                        _selectedCustomerId = null;
                      });
                    },
                  ),
                  if (upiPaymentEnabled)
                    CheckoutPaymentModeChip(
                      label: 'UPI',
                      icon: Icons.phone_android,
                      color: AppColors.upi,
                      isSelected: _selectedPaymentMode == PaymentMode.upi,
                      onTap: () {
                        setState(() {
                          _selectedPaymentMode = PaymentMode.upi;
                          _selectedCustomerId = null;
                        });
                      },
                    ),
                  if (creditPaymentEnabled)
                    CheckoutPaymentModeChip(
                      label: 'Credit',
                      icon: Icons.credit_card,
                      color: AppColors.credit,
                      isSelected: _selectedPaymentMode == PaymentMode.credit,
                      onTap: () {
                        setState(() {
                          _selectedPaymentMode = PaymentMode.credit;
                        });
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.spacingLarge),
            if (creditPaymentEnabled &&
                _selectedPaymentMode == PaymentMode.credit) ...[
              CheckoutSectionCard(
                title: 'Customer',
                trailing: TextButton.icon(
                  onPressed: () => _showAddCustomerModal(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                child: StreamBuilder<List<CustomerModel>>(
                  stream: ref
                      .watch(customerRepositoryProvider)
                      .watchAllCustomers(),
                  builder: (context, snapshot) {
                    final customers = snapshot.data ?? const <CustomerModel>[];

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSizes.paddingMedium,
                        ),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (customers.isEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'No customers found. Add a customer from Manage Customers first.',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: AppSizes.spacingSmall),
                          TextButton.icon(
                            onPressed: () => _showAddCustomerModal(context),
                            icon: const Icon(Icons.person_add_alt_1),
                            label: const Text('Add Customer'),
                          ),
                        ],
                      );
                    }

                    final hasSelection = customers.any(
                      (c) => c.id == _selectedCustomerId,
                    );
                    final selectedValue = hasSelection
                        ? _selectedCustomerId
                        : null;
                    CustomerModel? selectedCustomer;
                    for (final customer in customers) {
                      if (customer.id == selectedValue) {
                        selectedCustomer = customer;
                        break;
                      }
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DropdownButtonFormField<int>(
                          initialValue: selectedValue,
                          decoration: const InputDecoration(
                            labelText: 'Select customer *',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          items: customers
                              .map(
                                (customer) => DropdownMenuItem<int>(
                                  value: customer.id,
                                  child: Text(
                                    customer.phone == null ||
                                            customer.phone!.isEmpty
                                        ? customer.name
                                        : '${customer.name} (${customer.phone})',
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() => _selectedCustomerId = value);
                          },
                        ),
                        if (selectedCustomer != null) ...[
                          const SizedBox(height: AppSizes.spacingMedium),
                          CustomerCreditSummary(
                            customer: selectedCustomer,
                            projectedPurchaseAmount: grandTotal,
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSizes.spacingLarge),
            ],
            CheckoutSectionCard(
              title: 'Notes (Optional)',
              child: TextField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(hintText: 'Add any notes...'),
              ),
            ),
            const SizedBox(height: AppSizes.spacingXLarge),
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingLarge),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  CheckoutSummaryRow(
                    label: 'Subtotal',
                    value: CurrencyFormatter.format(subtotal),
                  ),
                  if (calcState.hasTax) ...[
                    const SizedBox(height: AppSizes.spacingSmall),
                    CheckoutSummaryRow(
                      label: 'Taxable Amount',
                      value: CurrencyFormatter.format(calcState.totalTaxableAmount),
                    ),
                    const SizedBox(height: AppSizes.spacingSmall),
                    CheckoutSummaryRow(
                      label: 'CGST',
                      value: CurrencyFormatter.format(calcState.totalCgstAmount),
                    ),
                    const SizedBox(height: AppSizes.spacingSmall),
                    CheckoutSummaryRow(
                      label: 'SGST',
                      value: CurrencyFormatter.format(calcState.totalSgstAmount),
                    ),
                  ],
                  if (discountValue > 0) ...[
                    const SizedBox(height: AppSizes.spacingSmall),
                    CheckoutSummaryRow(
                      label: 'Discount',
                      value: '- ${CurrencyFormatter.format(discountValue)}',
                      valueColor: AppColors.error,
                    ),
                  ],
                  const Divider(height: AppSizes.spacingLarge),
                  CheckoutSummaryRow(
                    label: 'Grand Total',
                    value: CurrencyFormatter.format(grandTotal),
                    isTotal: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.spacingXLarge),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Cancel',
                    isOutlined: true,
                    onPressed: () => context.pop(),
                  ),
                ),
                const SizedBox(width: AppSizes.spacingMedium),
                Expanded(
                  flex: 2,
                  child: AppButton(
                    label: 'Confirm & Save',
                    icon: Icons.check_circle,
                    isLoading: _isSaving,
                    height: AppSizes.buttonHeightLarge,
                    onPressed: () => _handleConfirmAndSave(
                      calcState.billItems,
                      subtotal,
                      discountValue,
                      grandTotal,
                      prefs,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacingXLarge),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddCustomerModal(BuildContext context) async {
    final customerId = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => const AddCustomerModal(),
    );

    if (customerId != null && context.mounted) {
      setState(() => _selectedCustomerId = customerId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Customer added and selected')),
      );
    }
  }

  Future<void> _saveInvoice(
    List<BillItem> items,
    double subtotal,
    double discount,
    double grandTotal,
  ) async {
    if (_selectedPaymentMode == PaymentMode.credit &&
        _selectedCustomerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a customer for credit payment'),
        ),
      );
      return;
    }

    if (_selectedPaymentMode == PaymentMode.credit) {
      final customer = await ref
          .read(customerRepositoryProvider)
          .getCustomerById(_selectedCustomerId!);

      if (!mounted) return;

      if (customer == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selected customer was not found')),
        );
        return;
      }

      final projectedDue = customer.creditDue + grandTotal;
      if (projectedDue > customer.creditLimit) {
        final shouldContinue = await _confirmOverCreditLimit(
          customer: customer,
          projectedDue: projectedDue,
          invoiceAmount: grandTotal,
        );
        if (!shouldContinue) return;
      }
    }

    setState(() => _isSaving = true);

    try {
      final repository = ref.read(invoiceRepositoryProvider);
      final paymentState = _resolvePaymentState(grandTotal);

      final calcState = ref.read(calculatorProvider);
      final result = await repository.saveInvoice(
        SaveInvoiceRequest(
          items: items,
          subtotal: subtotal,
          discount: discount,
          grandTotal: grandTotal,
          taxableAmount: calcState.totalTaxableAmount,
          totalTaxAmount: calcState.totalTaxAmount,
          cgstAmount: calcState.totalCgstAmount,
          sgstAmount: calcState.totalSgstAmount,
          paymentMode: _selectedPaymentMode,
          paidAmount: paymentState.paidAmount,
          paymentStatus: paymentState.paymentStatus,
          customerId: _selectedPaymentMode == PaymentMode.credit
              ? _selectedCustomerId
              : null,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        ),
      );

      ref.read(calculatorProvider.notifier).clearBill();
      ref.invalidate(invoiceListProvider);

      if (mounted) {
        showTopNotification(
          context,
          message: 'Invoice ${result.invoiceNo} saved successfully!',
          backgroundColor: AppColors.success,
        );
        context.go('/');
      }
    } on StateError catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: AppColors.error),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error saving invoice. Please try again.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  ({double paidAmount, PaymentStatus paymentStatus}) _resolvePaymentState(
    double grandTotal,
  ) {
    switch (_selectedPaymentMode) {
      case PaymentMode.cash:
      case PaymentMode.upi:
        return (paidAmount: grandTotal, paymentStatus: PaymentStatus.fulfilled);
      case PaymentMode.credit:
        return (paidAmount: 0.0, paymentStatus: PaymentStatus.pending);
    }
  }

  Future<bool> _confirmOverCreditLimit({
    required CustomerModel customer,
    required double projectedDue,
    required double invoiceAmount,
  }) async {
    final overBy = projectedDue - customer.creditLimit;
    final shouldContinue = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Credit limit exceeded'),
          content: Text(
            '${customer.name} will exceed the credit limit by ${CurrencyFormatter.format(overBy)}.\n\n'
            'Current due: ${CurrencyFormatter.format(customer.creditDue)}\n'
            'This bill: ${CurrencyFormatter.format(invoiceAmount)}\n'
            'Projected due: ${CurrencyFormatter.format(projectedDue)}\n'
            'Limit: ${CurrencyFormatter.format(customer.creditLimit)}\n\n'
            'Continue anyway?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );

    return shouldContinue == true;
  }

  Future<void> _handleConfirmAndSave(
    List<BillItem> items,
    double subtotal,
    double discount,
    double grandTotal,
    UserPreferences prefs,
  ) async {
    if (_selectedPaymentMode != PaymentMode.upi) {
      await _saveInvoice(items, subtotal, discount, grandTotal);
      return;
    }

    if (!prefs.upiPaymentEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('UPI payment is disabled in settings')),
      );
      return;
    }

    final upiId = prefs.upiId.trim();
    if (!_isValidUpiId(upiId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Set a valid UPI ID in Settings before using UPI'),
        ),
      );
      return;
    }

    final paymentDone = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => UpiQrPaymentScreen(amount: grandTotal, upiId: upiId),
      ),
    );

    if (paymentDone != true || !mounted) return;

    await _saveInvoice(items, subtotal, discount, grandTotal);
  }

  bool _isValidUpiId(String value) {
    return value.contains('@') && value.length >= 5;
  }
}
