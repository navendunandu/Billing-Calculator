import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../domain/hsn_entry_model.dart';
import 'providers/hsn_providers.dart';

/// Screen to view, search, and manage HSN/SAC codes and tax rates
class ManageHsnScreen extends ConsumerStatefulWidget {
  const ManageHsnScreen({super.key});

  @override
  ConsumerState<ManageHsnScreen> createState() => _ManageHsnScreenState();
}

class _ManageHsnScreenState extends ConsumerState<ManageHsnScreen> {
  late final TextEditingController _searchController;

  static const List<double> _taxSlabs = [0.0, 5.0, 12.0, 18.0, 28.0];

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
    final state = ref.watch(hsnManagerProvider);
    final notifier = ref.read(hsnManagerProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CommonAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: const Text('HSN & Tax Master'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSizes.paddingMedium),
            child: FilledButton.icon(
              onPressed: () => _openHsnForm(context),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add HSN'),
              style: FilledButton.styleFrom(
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search field
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.paddingLarge,
                AppSizes.paddingMedium,
                AppSizes.paddingLarge,
                AppSizes.paddingSmall,
              ),
              child: TextField(
                controller: _searchController,
                onChanged: notifier.setSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Search by HSN code or description...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: state.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            notifier.setSearchQuery('');
                          },
                        )
                      : null,
                ),
              ),
            ),

            // Tax slab filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingLarge,
                vertical: AppSizes.paddingSmall,
              ),
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All Slabs'),
                    selected: state.selectedRateFilter == null,
                    onSelected: (_) => notifier.setRateFilter(null),
                  ),
                  const SizedBox(width: AppSizes.spacingSmall),
                  for (final slab in _taxSlabs) ...[
                    FilterChip(
                      label: Text('${slab.toStringAsFixed(0)}% GST'),
                      selected: state.selectedRateFilter == slab,
                      onSelected: (selected) {
                        notifier.setRateFilter(selected ? slab : null);
                      },
                    ),
                    const SizedBox(width: AppSizes.spacingSmall),
                  ],
                ],
              ),
            ),

            if (state.errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(AppSizes.paddingLarge),
                child: Text(
                  state.errorMessage!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),

            // Entries List
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.filteredEntries.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.paddingLarge),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 56,
                              color: theme.colorScheme.primary.withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: AppSizes.spacingMedium),
                            Text(
                              state.searchQuery.isNotEmpty || state.selectedRateFilter != null
                                  ? 'No matching HSN codes found'
                                  : 'No HSN codes available',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: AppSizes.spacingSmall),
                            Text(
                              'Add your first HSN code to link tax rates with items.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        AppSizes.paddingLarge,
                        AppSizes.paddingSmall,
                        AppSizes.paddingLarge,
                        AppSizes.paddingLarge,
                      ),
                      itemCount: state.filteredEntries.length,
                      itemBuilder: (context, index) {
                        final entry = state.filteredEntries[index];
                        return _HsnTile(
                          entry: entry,
                          onEdit: () => _openHsnForm(context, entry: entry),
                          onDelete: () => _handleDelete(entry),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openHsnForm(BuildContext context, {HsnEntryModel? entry}) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXLarge),
        ),
      ),
      builder: (_) => _HsnFormSheet(entry: entry),
    );
  }

  Future<void> _handleDelete(HsnEntryModel entry) async {
    final messenger = ScaffoldMessenger.of(context);
    final shouldDelete = await showConfirmationDialog(
      context,
      title: 'Delete HSN Code',
      message: 'Are you sure you want to delete HSN "${entry.hsnCode} (${entry.description})"?',
      confirmLabel: 'Delete',
      isDestructive: true,
    );

    if (!shouldDelete || !mounted) return;

    final error = await ref.read(hsnManagerProvider.notifier).deleteHsn(entry.id);
    if (!mounted) return;

    if (error != null) {
      messenger.showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(content: Text('HSN "${entry.hsnCode}" deleted')),
      );
    }
  }
}

class _HsnTile extends StatelessWidget {
  const _HsnTile({
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  });

  final HsnEntryModel entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rateStr = '${entry.gstRate.toStringAsFixed(entry.gstRate % 1 == 0 ? 0 : 1)}%';

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spacingMedium),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMedium,
          vertical: AppSizes.spacingSmall,
        ),
        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.25),
            ),
          ),
          child: Center(
            child: Text(
              rateStr,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            Text(
              'HSN ${entry.hsnCode}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (entry.isDefault) ...[
              const SizedBox(width: AppSizes.spacingSmall),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accentBackground,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
                child: const Text(
                  'Default',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              entry.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'CGST: ${(entry.cgstRate).toStringAsFixed(1)}% | SGST: ${(entry.sgstRate).toStringAsFixed(1)}% | IGST: ${(entry.igstRate).toStringAsFixed(1)}%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                fontSize: 11,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) {
            if (action == 'edit') onEdit();
            if (action == 'delete') onDelete();
          },
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, size: 18),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: AppColors.error)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HsnFormSheet extends ConsumerStatefulWidget {
  const _HsnFormSheet({this.entry});

  final HsnEntryModel? entry;

  bool get isEditing => entry != null;

  @override
  ConsumerState<_HsnFormSheet> createState() => _HsnFormSheetState();
}

class _HsnFormSheetState extends ConsumerState<_HsnFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _codeController;
  late final TextEditingController _descController;
  late final TextEditingController _rateController;

  static const List<double> _quickRates = [0.0, 5.0, 12.0, 18.0, 28.0];

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.entry?.hsnCode ?? '');
    _descController = TextEditingController(text: widget.entry?.description ?? '');
    _rateController = TextEditingController(
      text: widget.entry != null ? widget.entry!.gstRate.toStringAsFixed(widget.entry!.gstRate % 1 == 0 ? 0 : 1) : '5',
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _descController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  double get _currentRate => double.tryParse(_rateController.text.trim()) ?? 0.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSaving = ref.watch(hsnManagerProvider).isSaving;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: AppSizes.paddingMedium),
                    decoration: BoxDecoration(
                      color: theme.dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  widget.isEditing ? 'Edit HSN / SAC Code' : 'Add HSN / SAC Code',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.spacingMedium),

                // HSN Code
                TextFormField(
                  controller: _codeController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'HSN / SAC Code *',
                    hintText: 'e.g., 1001, 0808, 9983',
                    prefixIcon: Icon(Icons.tag),
                  ),
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return 'HSN Code is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.spacingMedium),

                // Description
                TextFormField(
                  controller: _descController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Description *',
                    hintText: 'e.g., Wheat and Meslin / Food Grains',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return 'Description is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.spacingMedium),

                // GST Rate %
                TextFormField(
                  controller: _rateController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Total GST Rate (%) *',
                    hintText: 'e.g., 5, 12, 18, 28',
                    prefixIcon: Icon(Icons.percent),
                  ),
                  onChanged: (_) => setState(() {}),
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return 'GST rate is required';
                    }
                    final rate = double.tryParse(value!.trim());
                    if (rate == null || rate < 0 || rate > 100) {
                      return 'Enter a valid rate between 0 and 100';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.spacingSmall),

                // Quick Slabs
                Wrap(
                  spacing: AppSizes.spacingSmall,
                  children: [
                    for (final rate in _quickRates)
                      ActionChip(
                        label: Text('${rate.toStringAsFixed(0)}%'),
                        backgroundColor: (_currentRate == rate)
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : null,
                        side: (_currentRate == rate)
                            ? const BorderSide(color: AppColors.primary, width: 1.5)
                            : null,
                        onPressed: () {
                          setState(() {
                            _rateController.text = rate.toStringAsFixed(0);
                          });
                        },
                      ),
                  ],
                ),
                const SizedBox(height: AppSizes.spacingMedium),

                // Tax breakdown preview
                Container(
                  padding: const EdgeInsets.all(AppSizes.paddingMedium),
                  decoration: BoxDecoration(
                    color: AppColors.accentBackground.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _TaxStatColumn(label: 'CGST', value: '${(_currentRate / 2).toStringAsFixed(1)}%'),
                      _TaxStatColumn(label: 'SGST', value: '${(_currentRate / 2).toStringAsFixed(1)}%'),
                      _TaxStatColumn(label: 'IGST', value: '${_currentRate.toStringAsFixed(1)}%'),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.spacingXLarge),

                AppButton(
                  onPressed: isSaving ? null : _saveHsn,
                  isLoading: isSaving,
                  label: widget.isEditing ? 'Update HSN' : 'Save HSN',
                  icon: Icons.save_outlined,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveHsn() async {
    if (!_formKey.currentState!.validate()) return;

    final rate = double.parse(_rateController.text.trim());
    final draft = HsnEntryDraft(
      hsnCode: _codeController.text.trim(),
      description: _descController.text.trim(),
      gstRate: rate,
      isDefault: widget.entry?.isDefault ?? false,
    );

    final notifier = ref.read(hsnManagerProvider.notifier);
    final error = widget.isEditing
        ? await notifier.updateHsn(widget.entry!.id, draft)
        : await notifier.addHsn(draft);

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
      return;
    }

    Navigator.pop(context);
  }
}

class _TaxStatColumn extends StatelessWidget {
  const _TaxStatColumn({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

/// Reusable modal sheet to search and pick an HSN code for item form
Future<HsnEntryModel?> showHsnPickerModal(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<HsnEntryModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).cardColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXLarge)),
    ),
    builder: (sheetContext) {
      return const _HsnPickerSheet();
    },
  );
}

class _HsnPickerSheet extends ConsumerStatefulWidget {
  const _HsnPickerSheet();

  @override
  ConsumerState<_HsnPickerSheet> createState() => _HsnPickerSheetState();
}

class _HsnPickerSheetState extends ConsumerState<_HsnPickerSheet> {
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
    final state = ref.watch(hsnManagerProvider);
    final theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Column(
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: AppSizes.paddingMedium),
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select HSN / Tax Slab',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('New HSN'),
                    onPressed: () {
                      Navigator.pop(context);
                      context.push('/hsn');
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingLarge),
              child: TextField(
                controller: _searchController,
                onChanged: (q) => ref.read(hsnManagerProvider.notifier).setSearchQuery(q),
                decoration: const InputDecoration(
                  hintText: 'Search HSN or commodity name...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: state.filteredEntries.isEmpty
                  ? Center(
                      child: Text(
                        'No matching HSN codes',
                        style: theme.textTheme.bodyMedium,
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
                      itemCount: state.filteredEntries.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final entry = state.filteredEntries[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                            child: Text(
                              '${entry.gstRate.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          title: Text('HSN ${entry.hsnCode} • ${entry.gstRate}% GST'),
                          subtitle: Text(
                            entry.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () => Navigator.pop(context, entry),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
