import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/image_storage.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../domain/inventory_item_model.dart';
import '../../hsn/presentation/manage_hsn_screen.dart';
import '../../categories/presentation/widgets/category_picker_modal.dart';
import 'providers/inventory_providers.dart';

class InventoryItemFormScreen extends ConsumerStatefulWidget {
  const InventoryItemFormScreen({super.key, this.itemId});

  final int? itemId;

  bool get isEditing => itemId != null;

  @override
  ConsumerState<InventoryItemFormScreen> createState() =>
      _InventoryItemFormScreenState();
}

class _InventoryItemFormScreenState
    extends ConsumerState<InventoryItemFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _codeController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _unitValueController;
  late final TextEditingController _brandController;
  late final TextEditingController _imagePathController;

  String? _selectedCategory;
  InventoryUom _selectedUom = InventoryUom.pcs;
  String? _selectedHsnCode;
  double _taxRate = 0.0;
  bool _isTaxInclusive = true;
  bool _isInitializing = false;
  String? _codeLoadError;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
    _barcodeController = TextEditingController();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _unitValueController = TextEditingController(text: '1');
    _brandController = TextEditingController();
    _imagePathController = TextEditingController();

    if (widget.isEditing) {
      _loadItem();
    } else {
      _loadNextItemCode();
    }
  }

  Future<void> _loadNextItemCode() async {
    setState(() => _isInitializing = true);
    try {
      final code = await ref
          .read(inventoryRepositoryProvider)
          .getNextItemCode();
      if (!mounted) {
        return;
      }
      setState(() {
        _codeController.text = code;
        _codeLoadError = null;
      });
    } catch (error) {
      debugPrint('Error generating item code: $error');
      if (!mounted) {
        return;
      }
      setState(() {
        _codeController.text = '';
        _codeLoadError = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    }
  }

  Future<void> _loadItem() async {
    setState(() => _isInitializing = true);
    final item = await ref
        .read(inventoryRepositoryProvider)
        .getItemById(widget.itemId!);

    if (!mounted) {
      return;
    }

    if (item != null) {
      _codeController.text = item.code;
      _barcodeController.text = item.barcode ?? '';
      _nameController.text = item.name;
      _priceController.text = item.price.toStringAsFixed(2);
      _unitValueController.text = item.unitValue.toString();
      _brandController.text = item.brand;
      _imagePathController.text = item.imagePath ?? '';
      _selectedCategory = item.category;
      _selectedUom = item.uom;
      _selectedHsnCode = item.hsnCode;
      _taxRate = item.taxRate;
      _isTaxInclusive = item.isTaxInclusive;
    }

    setState(() => _isInitializing = false);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _barcodeController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _unitValueController.dispose();
    _brandController.dispose();
    _imagePathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inventoryManagerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CommonAppBar(
        title: Text(widget.isEditing ? 'Edit Inventory Item' : 'Add New Item'),
      ),
      body: _isInitializing
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.paddingLarge),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Full-width modern product card with 16:9 banner
                      _ItemProductCard(
                        imagePath: _imagePathController.text,
                        onTap: _showImagePickerModal,
                        onPickFromCamera: () => _pickImage(ImageSource.camera),
                        onPickFromGallery: () => _pickImage(ImageSource.gallery),
                        onRemove: _clearImage,
                      ),
                      const SizedBox(height: AppSizes.spacingLarge),

                      // Section 1: Basic Information
                      const _SectionHeader(
                        title: 'Basic Information',
                        icon: Icons.info_outline,
                      ),
                      TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Item Name *',
                          hintText: 'e.g., Fresh Apples',
                          prefixIcon: Icon(Icons.inventory_2_outlined),
                        ),
                        validator: (value) {
                          if ((value ?? '').trim().isEmpty) {
                            return 'Item name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.spacingMedium),

                      TextFormField(
                        controller: _codeController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Item Code',
                          hintText: 'Generating code...',
                          prefixIcon: const Icon(Icons.qr_code_2_outlined),
                          suffixIcon: _codeLoadError != null
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.refresh,
                                    color: AppColors.primary,
                                  ),
                                  onPressed: _loadNextItemCode,
                                  tooltip: 'Retry code generation',
                                )
                              : const Icon(
                                  Icons.lock_outline,
                                  size: 18,
                                  color: AppColors.textSecondaryLight,
                                ),
                        ),
                      ),
                      if (_codeLoadError != null) ...[
                        const SizedBox(height: AppSizes.spacingXSmall),
                        Text(
                          _codeLoadError!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSizes.spacingMedium),

                      TextFormField(
                        controller: _barcodeController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Barcode',
                          hintText: 'Scan or type barcode',
                          prefixIcon: const Icon(Icons.qr_code_scanner),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_barcodeController.text.isNotEmpty)
                                IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: () => setState(
                                    () => _barcodeController.clear(),
                                  ),
                                  tooltip: 'Clear barcode',
                                ),
                              IconButton(
                                icon: const Icon(Icons.center_focus_strong),
                                color: AppColors.primary,
                                onPressed: _scanBarcode,
                                tooltip: 'Scan barcode with camera',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacingLarge),

                      // Section 2: Pricing & Measurement
                      const _SectionHeader(
                        title: 'Pricing & Measurement',
                        icon: Icons.local_atm_outlined,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: _priceController,
                              textInputAction: TextInputAction.next,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: const InputDecoration(
                                labelText: 'Price *',
                                hintText: '0.00',
                                prefixIcon: Icon(Icons.currency_rupee),
                              ),
                              validator: (value) {
                                if ((value ?? '').trim().isEmpty) {
                                  return 'Required';
                                }
                                final parsed = double.tryParse(value!.trim());
                                if (parsed == null || parsed < 0) {
                                  return 'Invalid';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: AppSizes.spacingSmall),
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<InventoryUom>(
                              initialValue: _selectedUom,
                              isExpanded: true,
                              decoration: const InputDecoration(
                                labelText: 'UOM *',
                                prefixIcon: Icon(Icons.straighten),
                              ),
                              items: InventoryUom.values
                                  .map(
                                    (uom) => DropdownMenuItem<InventoryUom>(
                                      value: uom,
                                      child: Text(
                                        uom.label,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _selectedUom = value);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: AppSizes.spacingSmall),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _unitValueController,
                              textInputAction: TextInputAction.next,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: const InputDecoration(
                                labelText: 'Unit Val *',
                                hintText: 'e.g. 1',
                              ),
                              validator: (value) {
                                if ((value ?? '').trim().isEmpty) {
                                  return 'Required';
                                }
                                final parsed = double.tryParse(value!.trim());
                                if (parsed == null || parsed <= 0) {
                                  return 'Invalid';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.spacingMedium),

                      // HSN / Tax Slab Selector
                      InkWell(
                        onTap: () async {
                          final selected = await showHsnPickerModal(
                            context,
                            ref,
                          );
                          if (selected != null) {
                            setState(() {
                              _selectedHsnCode = selected.hsnCode;
                              _taxRate = selected.gstRate;
                            });
                          }
                        },
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusMedium,
                        ),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'HSN / Tax Slab',
                            hintText: 'Select HSN code & tax slab',
                            prefixIcon: const Icon(
                              Icons.receipt_long_outlined,
                            ),
                            suffixIcon: _selectedHsnCode != null
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    tooltip: 'Clear tax rate',
                                    onPressed: () {
                                      setState(() {
                                        _selectedHsnCode = null;
                                        _taxRate = 0.0;
                                      });
                                    },
                                  )
                                : const Icon(Icons.arrow_drop_down),
                          ),
                          child: Text(
                            _selectedHsnCode != null
                                ? 'HSN $_selectedHsnCode • ${_taxRate.toStringAsFixed(_taxRate % 1 == 0 ? 0 : 1)}% GST'
                                : 'No tax slab selected (0% GST)',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: _selectedHsnCode != null
                                  ? theme.colorScheme.onSurface
                                  : theme.hintColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacingSmall),

                      // Tax Inclusive (MRP) Toggle
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Price includes Tax (MRP)'),
                        subtitle: Text(
                          _isTaxInclusive
                              ? 'Tax is extracted from price during billing'
                              : 'Tax will be added on top of base price at checkout',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color?.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                        value: _isTaxInclusive,
                        onChanged: (val) => setState(() => _isTaxInclusive = val),
                      ),
                      const SizedBox(height: AppSizes.spacingLarge),

                      // Section 3: Categorization
                      const _SectionHeader(
                        title: 'Categorization',
                        icon: Icons.category_outlined,
                      ),
                      FormField<String>(
                        initialValue: _selectedCategory,
                        validator: (value) {
                          if ((_selectedCategory ?? '').trim().isEmpty) {
                            return 'Category is required';
                          }
                          return null;
                        },
                        builder: (fieldState) {
                          final hasCategory = _selectedCategory != null &&
                              _selectedCategory!.trim().isNotEmpty;
                          return InkWell(
                            onTap: () async {
                              final selected = await showCategoryPickerModal(
                                context,
                                ref,
                                selectedCategory: _selectedCategory,
                              );
                              if (selected != null) {
                                setState(() => _selectedCategory = selected);
                                fieldState.didChange(selected);
                              }
                            },
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusMedium,
                            ),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Category *',
                                hintText: 'Select or search category',
                                prefixIcon: const Icon(Icons.category_outlined),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (hasCategory)
                                      IconButton(
                                        icon: const Icon(Icons.clear, size: 18),
                                        tooltip: 'Clear category',
                                        onPressed: () {
                                          setState(() => _selectedCategory = null);
                                          fieldState.didChange(null);
                                        },
                                      ),
                                    const Icon(Icons.arrow_drop_down),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                                errorText: fieldState.errorText,
                              ),
                              child: Text(
                                hasCategory
                                    ? _selectedCategory!
                                    : 'Select or search category',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: hasCategory
                                      ? theme.colorScheme.onSurface
                                      : theme.hintColor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppSizes.spacingMedium),

                      TextFormField(
                        controller: _brandController,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: 'Brand *',
                          hintText: 'e.g., Farm Fresh',
                          prefixIcon: Icon(Icons.business_outlined),
                        ),
                        validator: (value) {
                          if ((value ?? '').trim().isEmpty) {
                            return 'Brand is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.spacingXLarge),

                      // Save Button
                      AppButton(
                        onPressed: state.isSaving ? null : _handleSave,
                        isLoading: state.isSaving,
                        label: widget.isEditing ? 'Update Item' : 'Save Item',
                        icon: Icons.save_outlined,
                        backgroundColor: AppColors.primary,
                      ),
                      if (state.errorMessage != null) ...[
                        const SizedBox(height: AppSizes.spacingMedium),
                        Text(
                          state.errorMessage!,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _showImagePickerModal() {
    final normalized = _imagePathController.text.trim();
    final hasImage = normalized.isNotEmpty && File(normalized).existsSync();
    final theme = Theme.of(context);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXLarge),
        ),
      ),
      builder: (modalContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingLarge,
              vertical: AppSizes.paddingMedium,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSizes.paddingMedium),
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  hasImage ? 'Change Item Photo' : 'Add Item Photo',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSizes.spacingMedium),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.accentBackground,
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  title: const Text('Take a Photo'),
                  subtitle: const Text('Use camera to capture item photo'),
                  onTap: () {
                    Navigator.pop(modalContext);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.accentBackground,
                    child: Icon(
                      Icons.photo_library_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  title: const Text('Choose from Gallery'),
                  subtitle: const Text('Select an image from device storage'),
                  onTap: () {
                    Navigator.pop(modalContext);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                if (hasImage) ...[
                  const Divider(),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.destructiveBackground,
                      child: Icon(
                        Icons.delete_outline,
                        color: AppColors.destructiveIcon,
                      ),
                    ),
                    title: const Text(
                      'Remove Photo',
                      style: TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(modalContext);
                      _clearImage();
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_codeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Item code is unavailable. Please retry code generation.',
          ),
        ),
      );
      return;
    }

    final price = double.parse(_priceController.text.trim());
    final unitValue = double.parse(_unitValueController.text.trim());

    final draft = InventoryItemDraft(
      code: _codeController.text.trim(),
      barcode: _barcodeController.text.trim(),
      name: _nameController.text.trim(),
      category: (_selectedCategory ?? '').trim(),
      brand: _brandController.text.trim(),
      price: price,
      uom: _selectedUom,
      unitValue: unitValue,
      imagePath: _imagePathController.text.trim(),
      hsnCode: _selectedHsnCode,
      taxRate: _taxRate,
      isTaxInclusive: _isTaxInclusive,
    );

    final notifier = ref.read(inventoryManagerProvider.notifier);
    final error = widget.isEditing
        ? await notifier.updateItem(widget.itemId!, draft)
        : await notifier.addItem(draft);

    if (!mounted) {
      return;
    }

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(widget.isEditing ? 'Item updated' : 'Item saved')),
    );
    Navigator.of(context).pop();
  }

  Future<void> _pickImage(ImageSource source) async {
    final previousPath = _imagePathController.text.trim();

    try {
      final storedPath = await LocalImageStorage.pickAndStoreImage(
        source: source,
      );

      if (!mounted || storedPath == null) {
        return;
      }

      setState(() {
        _imagePathController.text = storedPath;
      });

      if (previousPath.isNotEmpty && previousPath != storedPath) {
        await LocalImageStorage.deleteIfManaged(previousPath);
      }
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to select image. Please try again.'),
        ),
      );
    }
  }

  Future<void> _clearImage() async {
    final previousPath = _imagePathController.text.trim();
    if (previousPath.isEmpty) {
      return;
    }

    final shouldClear = await showConfirmationDialog(
      context,
      title: 'Remove image',
      message: 'Remove the current image from this item?',
      confirmLabel: 'Remove',
      isDestructive: true,
    );

    if (!shouldClear || !mounted) {
      return;
    }

    setState(() {
      _imagePathController.clear();
    });

    await LocalImageStorage.deleteIfManaged(previousPath);
  }

  Future<void> _scanBarcode() async {
    final scannedCode = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const _BarcodeScannerScreen()),
    );

    if (!mounted || scannedCode == null || scannedCode.trim().isEmpty) {
      return;
    }

    setState(() {
      _barcodeController.text = scannedCode.trim();
    });
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spacingMedium),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: AppSizes.spacingSmall),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemProductCard extends StatelessWidget {
  const _ItemProductCard({
    required this.imagePath,
    required this.onTap,
    required this.onPickFromCamera,
    required this.onPickFromGallery,
    required this.onRemove,
  });

  final String imagePath;
  final VoidCallback onTap;
  final VoidCallback onPickFromCamera;
  final VoidCallback onPickFromGallery;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final normalized = imagePath.trim();
    final imageFile = normalized.isEmpty ? null : File(normalized);
    final hasImage = imageFile != null && imageFile.existsSync();

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: hasImage
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                    ),
                    // Gradient overlay
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 80,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Bottom actions overlay
                    Positioned(
                      left: AppSizes.paddingMedium,
                      right: AppSizes.paddingMedium,
                      bottom: AppSizes.paddingMedium,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.45),
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusSmall,
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Product Image',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusFull,
                            ),
                            elevation: 2,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusFull,
                              ),
                              onTap: onTap,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.edit_outlined,
                                      size: 14,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Change',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSizes.spacingSmall),
                          Material(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusFull,
                            ),
                            elevation: 2,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusFull,
                              ),
                              onTap: onRemove,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.delete_outline,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Remove',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : CustomPaint(
              painter: _DashedBorderPainter(
                color: AppColors.primary.withValues(alpha: 0.35),
                strokeWidth: 1.5,
                gap: 5,
                dashLength: 7,
                radius: AppSizes.radiusLarge,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.accentBackground.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.paddingMedium),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 26,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Upload Product Photo',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Optional • Visible on calculator & receipts',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color?.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FilledButton.tonalIcon(
                              onPressed: onPickFromCamera,
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                size: 16,
                              ),
                              label: const Text('Camera'),
                              style: FilledButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.paddingMedium,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSizes.spacingMedium),
                            FilledButton.tonalIcon(
                              onPressed: onPickFromGallery,
                              icon: const Icon(
                                Icons.photo_library_outlined,
                                size: 16,
                              ),
                              label: const Text('Gallery'),
                              style: FilledButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.paddingMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
    required this.dashLength,
    required this.radius,
  });

  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final length = (distance + dashLength < metric.length)
            ? dashLength
            : metric.length - distance;
        final extractPath = metric.extractPath(distance, distance + length);
        canvas.drawPath(extractPath, paint);
        distance += dashLength + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gap != gap ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.radius != radius;
  }
}

class _BarcodeScannerScreen extends StatefulWidget {
  const _BarcodeScannerScreen();

  @override
  State<_BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<_BarcodeScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    formats: const [
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.code128,
      BarcodeFormat.code39,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
      BarcodeFormat.qrCode,
    ],
  );
  final AudioPlayer _beepPlayer = AudioPlayer();

  bool _hasDetected = false;

  @override
  void initState() {
    super.initState();
    _beepPlayer.setReleaseMode(ReleaseMode.stop);
    _beepPlayer.setPlayerMode(PlayerMode.lowLatency);
  }

  @override
  void dispose() {
    _beepPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: Text('Scan Barcode')),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              if (_hasDetected) {
                return;
              }

              final code = capture.barcodes.isEmpty
                  ? null
                  : capture.barcodes.first.rawValue;
              if (code == null || code.trim().isEmpty) {
                return;
              }

              _hasDetected = true;
              _beepPlayer.play(AssetSource('sounds/scan_beep.wav'));
              Navigator.of(context).pop(code);
            },
            errorBuilder: (context, error) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingLarge),
                  child: Text(
                    'Unable to open camera for scanning. Please check permission and try again.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            },
          ),
          IgnorePointer(
            child: Center(
              child: Container(
                width: 260,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: AppSizes.paddingLarge,
            child: Text(
              'Align barcode inside the frame',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
