import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../providers/category_providers.dart';

/// Reusable modal bottom sheet to search, select, or quick-create a category
Future<String?> showCategoryPickerModal(
  BuildContext context,
  WidgetRef ref, {
  String? selectedCategory,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).cardColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSizes.radiusXLarge),
      ),
    ),
    builder: (sheetContext) {
      return _CategoryPickerSheet(initialSelected: selectedCategory);
    },
  );
}

class _CategoryPickerSheet extends ConsumerStatefulWidget {
  const _CategoryPickerSheet({this.initialSelected});

  final String? initialSelected;

  @override
  ConsumerState<_CategoryPickerSheet> createState() => _CategoryPickerSheetState();
}

class _CategoryPickerSheetState extends ConsumerState<_CategoryPickerSheet> {
  late final TextEditingController _searchController;
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    // Ensure fresh categories list
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryManagerProvider.notifier).loadCategories();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoryManagerProvider);
    final theme = Theme.of(context);
    final searchQuery = _searchController.text.trim();

    // Filter categories based on search query
    final filtered = state.categories.where((c) {
      if (searchQuery.isEmpty) return true;
      final q = searchQuery.toLowerCase();
      final nameMatches = c.name.toLowerCase().contains(q);
      final descMatches = c.description?.toLowerCase().contains(q) ?? false;
      return nameMatches || descMatches;
    }).toList();

    // Check if query exactly matches an existing category (case-insensitive)
    final exactMatchExists = state.categories.any(
      (c) => c.name.trim().toLowerCase() == searchQuery.toLowerCase(),
    );
    final canQuickCreate = searchQuery.isNotEmpty && !exactMatchExists;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.82,
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
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

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingLarge,
                vertical: AppSizes.paddingSmall,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                        ),
                        child: const Icon(
                          Icons.category_outlined,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: AppSizes.spacingSmall),
                      Text(
                        'Select Category',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.settings_outlined, size: 16),
                    label: const Text('Manage'),
                    onPressed: () {
                      Navigator.pop(context);
                      context.push('/categories');
                    },
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingLarge,
                vertical: AppSizes.paddingSmall,
              ),
              child: TextField(
                controller: _searchController,
                autofocus: false,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search or type new category...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                ),
              ),
            ),

            // Quick Create Banner if query has no exact match
            if (canQuickCreate)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingLarge,
                  vertical: AppSizes.paddingSmall,
                ),
                child: Material(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  child: InkWell(
                    onTap: _isCreating ? null : () => _quickCreate(searchQuery),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingMedium,
                        vertical: AppSizes.paddingMedium,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: _isCreating
                                ? const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.add, color: Colors.white, size: 16),
                          ),
                          const SizedBox(width: AppSizes.spacingMedium),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                    children: [
                                      const TextSpan(text: 'Create "'),
                                      TextSpan(
                                        text: searchQuery,
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      const TextSpan(text: '"'),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Tap to add and select instantly',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // List of Categories
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty && !canQuickCreate
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSizes.paddingLarge),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.category_outlined,
                                  size: 48,
                                  color: theme.hintColor.withValues(alpha: 0.4),
                                ),
                                const SizedBox(height: AppSizes.spacingSmall),
                                Text(
                                  'No categories found',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.hintColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingLarge,
                            vertical: AppSizes.paddingSmall,
                          ),
                          itemCount: filtered.length,
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final cat = filtered[index];
                            final isSelected = widget.initialSelected != null &&
                                widget.initialSelected!.trim().toLowerCase() ==
                                    cat.name.trim().toLowerCase();

                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.paddingSmall,
                                vertical: 2,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: isSelected
                                    ? AppColors.primary
                                    : AppColors.primary.withValues(alpha: 0.1),
                                child: Text(
                                  cat.name.isNotEmpty ? cat.name[0].toUpperCase() : '?',
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                cat.name,
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? AppColors.primary : null,
                                ),
                              ),
                              subtitle: cat.description != null && cat.description!.isNotEmpty
                                  ? Text(
                                      cat.description!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodySmall,
                                    )
                                  : null,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (cat.itemCount > 0)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.dividerColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${cat.itemCount} items',
                                        style: theme.textTheme.labelSmall?.copyWith(
                                          color: theme.hintColor,
                                        ),
                                      ),
                                    ),
                                  if (isSelected) ...[
                                    const SizedBox(width: 8),
                                    const Icon(Icons.check_circle, color: AppColors.primary),
                                  ],
                                ],
                              ),
                              onTap: () => Navigator.pop(context, cat.name),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _quickCreate(String name) async {
    setState(() => _isCreating = true);
    final created = await ref
        .read(categoryManagerProvider.notifier)
        .quickCreateCategory(name);
    if (!mounted) return;
    setState(() => _isCreating = false);

    if (created != null) {
      Navigator.pop(context, created.name);
    }
  }
}
