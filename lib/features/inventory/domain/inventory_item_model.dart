enum InventoryStatus { available, outOfStock, archived }

enum InventoryUom { pcs, kg, g, l, ml, pack, box }

extension InventoryUomLabel on InventoryUom {
  String get label {
    switch (this) {
      case InventoryUom.pcs:
        return 'pcs';
      case InventoryUom.kg:
        return 'kg';
      case InventoryUom.g:
        return 'g';
      case InventoryUom.l:
        return 'l';
      case InventoryUom.ml:
        return 'ml';
      case InventoryUom.pack:
        return 'pack';
      case InventoryUom.box:
        return 'box';
    }
  }
}

/// App-level inventory entity used by UI and state management.
class InventoryItemModel {
  const InventoryItemModel({
    required this.id,
    required this.code,
    this.barcode,
    required this.name,
    required this.category,
    required this.brand,
    required this.price,
    required this.uom,
    required this.unitValue,
    required this.status,
    required this.createdAt,
    this.imagePath,
    this.hsnCode,
    this.taxRate = 0.0,
    this.isTaxInclusive = true,
  });

  final int id;
  final String code;
  final String? barcode;
  final String name;
  final String category;
  final String brand;
  final double price;
  final InventoryUom uom;
  final double unitValue;
  final String? imagePath;
  final InventoryStatus status;
  final DateTime createdAt;
  final String? hsnCode;
  final double taxRate;
  final bool isTaxInclusive;

  /// Effective tax percentage string (e.g. "5% GST")
  String get taxLabel => '${taxRate.toStringAsFixed(taxRate % 1 == 0 ? 0 : 1)}% GST';

  InventoryItemModel copyWith({
    int? id,
    String? code,
    String? barcode,
    String? name,
    String? category,
    String? brand,
    double? price,
    InventoryUom? uom,
    double? unitValue,
    String? imagePath,
    InventoryStatus? status,
    DateTime? createdAt,
    String? hsnCode,
    double? taxRate,
    bool? isTaxInclusive,
  }) {
    return InventoryItemModel(
      id: id ?? this.id,
      code: code ?? this.code,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      uom: uom ?? this.uom,
      unitValue: unitValue ?? this.unitValue,
      imagePath: imagePath ?? this.imagePath,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      hsnCode: hsnCode ?? this.hsnCode,
      taxRate: taxRate ?? this.taxRate,
      isTaxInclusive: isTaxInclusive ?? this.isTaxInclusive,
    );
  }
}

/// Data needed to create or update an item.
class InventoryItemDraft {
  const InventoryItemDraft({
    required this.code,
    this.barcode,
    required this.name,
    required this.category,
    required this.brand,
    required this.price,
    this.uom = InventoryUom.pcs,
    this.unitValue = 1.0,
    this.imagePath,
    this.status = InventoryStatus.available,
    this.hsnCode,
    this.taxRate = 0.0,
    this.isTaxInclusive = true,
  });

  final String code;
  final String? barcode;
  final String name;
  final String category;
  final String brand;
  final double price;
  final InventoryUom uom;
  final double unitValue;
  final String? imagePath;
  final InventoryStatus status;
  final String? hsnCode;
  final double taxRate;
  final bool isTaxInclusive;
}
