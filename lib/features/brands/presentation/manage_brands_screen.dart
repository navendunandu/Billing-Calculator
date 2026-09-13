import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../domain/brand_model.dart';
import 'providers/brand_providers.dart';

class ManageBrandsScreen extends ConsumerStatefulWidget {
  const ManageBrandsScreen({super.key});

  @override
  ConsumerState<ManageBrandsScreen> createState() => _ManageBrandsScreenState();
}

class _ManageBrandsScreenState extends ConsumerState<ManageBrandsScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(brandManagerProvider.notifier).loadBrands();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(brandManagerProvider);
    final theme = Theme.of(context);

    final totalBrands = state.brands.length;
    final totalItems = state.brands.fold<int>(0, (sum, b) => sum + b.itemCount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Brand Master'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh brands',
            onPressed: () => ref.read(brandManagerProvider.notifier).loadBrands(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Brand',
            onPressed: () => _openBrandDialog(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openBrandDialog(),
        icon: const Icon(Icons.add),
        label: const Text('New Brand'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Stats summary header
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            margin: const EdgeInsets.all(AppSizes.paddingMedium),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.08),
                  AppColors.primary.withValues(alpha: 0.02),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.business_outlined,
                    label: 'Brands',
                    value: '$totalBrands',
                  ),
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
                Expanded(
                  child: _StatCard(
                    icon: Icons.inventory_2_outlined,
                    label: 'Assigned Items',
                    value: '$totalItems',
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
            child: TextField(
              controller: _searchController,
              onChanged: (q) => ref.read(brandManagerProvider.notifier).setSearchQuery(q),
              decoration: InputDecoration(
                hintText: 'Search brands...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(brandManagerProvider.notifier).setSearchQuery('');
                        },
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spacingSmall),

          // Content
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.filteredBrands.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.business_outlined,
                              size: 56,
                              color: theme.hintColor.withValues(alpha: 0.4),
                            ),
                            const SizedBox(height: AppSizes.spacingMedium),
                            Text(
                              state.searchQuery.isNotEmpty
                                  ? 'No brands match "${state.searchQuery}"'
                                  : 'No brands found',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.hintColor,
                              ),
                            ),
                            if (state.searchQuery.isNotEmpty) ...[
                              const SizedBox(height: AppSizes.spacingMedium),
                              ElevatedButton.icon(
                                onPressed: () => _openBrandDialog(initialName: state.searchQuery),
                                icon: const Icon(Icons.add),
                                label: Text('Create "${state.searchQuery}"'),
                              ),
                            ],
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(
                          left: AppSizes.paddingMedium,
                          right: AppSizes.paddingMedium,
                          top: AppSizes.paddingSmall,
                          bottom: 80, // Space for FAB
                        ),
                        itemCount: state.filteredBrands.length,
                        separatorBuilder: (context, index) => const SizedBox(height: AppSizes.spacingSmall),
                        itemBuilder: (context, index) {
                          final brand = state.filteredBrands[index];
                          return Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                              side: BorderSide(
                                color: theme.dividerColor.withValues(alpha: 0.2),
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.paddingMedium,
                                vertical: AppSizes.paddingSmall,
                              ),
                              leading: CircleAvatar(
                                radius: 22,
                                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                                child: Text(
                                  brand.name.isNotEmpty ? brand.name[0].toUpperCase() : '?',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      brand.name,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: brand.itemCount > 0
                                          ? AppColors.primary.withValues(alpha: 0.1)
                                          : theme.dividerColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${brand.itemCount} items',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: brand.itemCount > 0
                                            ? AppColors.primary
                                            : theme.hintColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  brand.description != null && brand.description!.isNotEmpty
                                      ? brand.description!
                                      : 'No description',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: brand.description != null && brand.description!.isNotEmpty
                                        ? null
                                        : theme.hintColor.withValues(alpha: 0.6),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              trailing: PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert),
                                onSelected: (action) {
                                  if (action == 'edit') {
                                    _openBrandDialog(brand: brand);
                                  } else if (action == 'delete') {
                                    _confirmDelete(brand);
                                  }
                                },
                                itemBuilder: (context) => [
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
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Future<void> _openBrandDialog({BrandModel? brand, String? initialName}) async {
    final isEditing = brand != null;
    final nameController = TextEditingController(
      text: isEditing ? brand.name : (initialName ?? ''),
    );
    final descController = TextEditingController(
      text: isEditing ? (brand.description ?? '') : '',
    );
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        bool isSaving = false;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
              ),
              title: Row(
                children: [
                  Icon(
                    isEditing ? Icons.edit_outlined : Icons.add_circle_outline,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSizes.spacingSmall),
                  Text(isEditing ? 'Edit Brand' : 'New Brand'),
                ],
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        autofocus: true,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Brand Name *',
                          hintText: 'e.g. Britannia',
                          prefixIcon: Icon(Icons.business_outlined),
                        ),
                        validator: (val) {
                          if ((val ?? '').trim().isEmpty) {
                            return 'Brand name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.spacingMedium),
                      TextFormField(
                        controller: descController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Description (Optional)',
                          hintText: 'Brief description of this brand',
                          prefixIcon: Icon(Icons.notes_outlined),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving ? null : () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;
                          setDialogState(() => isSaving = true);

                          final draft = BrandDraft(
                            name: nameController.text.trim(),
                            description: descController.text.trim().isEmpty
                                ? null
                                : descController.text.trim(),
                          );

                          final messenger = ScaffoldMessenger.of(context);
                          final nav = Navigator.of(dialogContext);

                          final notifier = ref.read(brandManagerProvider.notifier);
                          final error = isEditing
                              ? await notifier.updateBrand(brand.id, draft)
                              : await notifier.addBrand(draft);

                          if (!mounted) return;
                          setDialogState(() => isSaving = false);

                          if (error != null) {
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(error),
                                backgroundColor: AppColors.error,
                              ),
                            );
                            return;
                          }

                          nav.pop();
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                isEditing
                                    ? 'Brand updated successfully'
                                    : 'Brand added successfully',
                              ),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                  child: isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(isEditing ? 'Save Changes' : 'Create Brand'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _confirmDelete(BrandModel brand) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.warning),
              SizedBox(width: AppSizes.spacingSmall),
              Text('Delete Brand?'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Are you sure you want to delete "${brand.name}"?'),
              if (brand.itemCount > 0) ...[
                const SizedBox(height: AppSizes.spacingMedium),
                Container(
                  padding: const EdgeInsets.all(AppSizes.paddingSmall),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, size: 18, color: AppColors.warning),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${brand.itemCount} items currently use this brand.',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      final error = await ref
          .read(brandManagerProvider.notifier)
          .deleteBrand(brand.id);
      if (!mounted) return;

      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.error),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Brand deleted'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).hintColor,
          ),
        ),
      ],
    );
  }
}
