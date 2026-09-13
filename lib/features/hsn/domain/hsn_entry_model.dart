/// Model representing an HSN / SAC code and its tax rate configuration
class HsnEntryModel {
  const HsnEntryModel({
    required this.id,
    required this.hsnCode,
    required this.description,
    required this.gstRate,
    required this.cgstRate,
    required this.sgstRate,
    required this.igstRate,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String hsnCode;
  final String description;
  final double gstRate;
  final double cgstRate;
  final double sgstRate;
  final double igstRate;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Clean display label for UI, e.g. "1001 • 5% GST"
  String get displayLabel => '$hsnCode • ${gstRate.toStringAsFixed(gstRate % 1 == 0 ? 0 : 1)}% GST';

  HsnEntryModel copyWith({
    int? id,
    String? hsnCode,
    String? description,
    double? gstRate,
    double? cgstRate,
    double? sgstRate,
    double? igstRate,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HsnEntryModel(
      id: id ?? this.id,
      hsnCode: hsnCode ?? this.hsnCode,
      description: description ?? this.description,
      gstRate: gstRate ?? this.gstRate,
      cgstRate: cgstRate ?? this.cgstRate,
      sgstRate: sgstRate ?? this.sgstRate,
      igstRate: igstRate ?? this.igstRate,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Draft data for creating or editing an HSN entry
class HsnEntryDraft {
  const HsnEntryDraft({
    required this.hsnCode,
    required this.description,
    required this.gstRate,
    double? cgstRate,
    double? sgstRate,
    double? igstRate,
    this.isDefault = false,
  })  : cgstRate = cgstRate ?? (gstRate / 2),
        sgstRate = sgstRate ?? (gstRate / 2),
        igstRate = igstRate ?? gstRate;

  final String hsnCode;
  final String description;
  final double gstRate;
  final double cgstRate;
  final double sgstRate;
  final double igstRate;
  final bool isDefault;
}
