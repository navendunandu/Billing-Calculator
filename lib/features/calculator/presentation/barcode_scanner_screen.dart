import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:billing_app_pos/core/widgets/common_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/currency_format.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import 'providers/calculator_providers.dart';
import '../domain/bill_item.dart';
import '../../inventory/presentation/providers/inventory_providers.dart';

/// Barcode scanner screen with bill items at bottom
class BarcodeScannerScreen extends ConsumerStatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  ConsumerState<BarcodeScannerScreen> createState() =>
      _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends ConsumerState<BarcodeScannerScreen> {
  static const double _maxScanWindowWidth = 280;
  static const double _maxScanWindowHeight = 170;
  static const Duration _minimumScanGap = Duration(milliseconds: 150);
  static const Duration _barcodeExitThreshold = Duration(milliseconds: 700);

  late final MobileScannerController _scannerController;
  late final AudioPlayer _beepPlayer;
  _BarcodeScanLock? _scanLock;

  bool get _supportsCamera =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      detectionTimeoutMs: 160,
      formats: const [
        BarcodeFormat.ean13,
        BarcodeFormat.ean8,
        BarcodeFormat.code128,
        BarcodeFormat.code39,
        BarcodeFormat.upcA,
        BarcodeFormat.upcE,
      ],
    );
    _beepPlayer = AudioPlayer();
    _beepPlayer.setReleaseMode(ReleaseMode.stop);
    _beepPlayer.setPlayerMode(PlayerMode.lowLatency);
  }

  @override
  void dispose() {
    _beepPlayer.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final barcode = _pickBestBarcode(capture.barcodes);
    final code = barcode?.rawValue?.trim();
    if (code == null || code.isEmpty) {
      return;
    }

    final now = DateTime.now();
    if (!_shouldAcceptBarcode(code: code, now: now)) {
      return;
    }

    _scanLock = _BarcodeScanLock(code: code, acceptedAt: now, lastSeenAt: now);

    ref.read(inventoryManagerProvider);
    final matchingItem = ref.read(inventoryBarcodeMapProvider)[code];

    if (matchingItem == null) {
      debugPrint('No inventory item found for barcode: $code');
      _showScannerMessage('No inventory item found for $code');
      return;
    }

    final calcState = ref.read(calculatorProvider);
    final calcNotifier = ref.read(calculatorProvider.notifier);

    final existingIndex = calcNotifier.findMatchingItemIndex(
      inventoryItemId: matchingItem.id,
      barcode: code,
    );

    if (existingIndex != -1) {
      final existingItem = calcState.billItems[existingIndex];
      final updatedQuantity = existingItem.quantity + 1;

      calcNotifier.updateItem(
        existingIndex,
        existingItem.copyWith(quantity: updatedQuantity),
      );

      unawaited(_playSuccessBeep());
      _showScannerMessage(
        '${matchingItem.name} qty increased to ${CurrencyFormatter.formatQuantity(updatedQuantity)}',
      );
      return;
    }

    calcNotifier.addBillItem(
      BillItem(
        id: matchingItem.id.toString(),
        inventoryItemId: matchingItem.id,
        barcode: code,
        name: matchingItem.name,
        quantity: 1,
        rate: matchingItem.price,
        hsnCode: matchingItem.hsnCode,
        taxRate: matchingItem.taxRate,
        isTaxInclusive: matchingItem.isTaxInclusive,
      ),
    );

    unawaited(_playSuccessBeep());
    _showScannerMessage('${matchingItem.name} added to bill');
  }

  Future<void> _playSuccessBeep() async {
    try {
      await _beepPlayer.stop();
      await _beepPlayer.play(AssetSource('sounds/scan_beep.wav'));
    } catch (_) {}
  }

  Barcode? _pickBestBarcode(List<Barcode> barcodes) {
    Barcode? bestBarcode;
    double bestArea = -1;

    for (final candidate in barcodes) {
      final code = candidate.rawValue?.trim();
      if (candidate.format == BarcodeFormat.qrCode ||
          code == null ||
          code.isEmpty) {
        continue;
      }

      final area = _barcodeArea(candidate);
      if (bestBarcode == null || area > bestArea) {
        bestBarcode = candidate;
        bestArea = area;
      }
    }

    return bestBarcode;
  }

  bool _shouldAcceptBarcode({required String code, required DateTime now}) {
    final scanLock = _scanLock;

    if (scanLock == null) {
      return true;
    }

    if (now.difference(scanLock.acceptedAt) < _minimumScanGap) {
      if (scanLock.code == code) {
        _scanLock = scanLock.copyWith(lastSeenAt: now);
      }
      return false;
    }

    if (scanLock.code != code) {
      return true;
    }

    if (now.difference(scanLock.lastSeenAt) >= _barcodeExitThreshold) {
      return true;
    }

    _scanLock = scanLock.copyWith(lastSeenAt: now);
    return false;
  }

  Rect _scanWindowFor(Size size) {
    final width = (size.width * 0.78)
        .clamp(220.0, _maxScanWindowWidth)
        .toDouble();
    final height = (size.height * 0.34)
        .clamp(120.0, _maxScanWindowHeight)
        .toDouble();

    return Rect.fromCenter(
      center: size.center(Offset.zero),
      width: width,
      height: height,
    );
  }

  double _barcodeArea(Barcode barcode) {
    if (barcode.size.isEmpty) {
      return 0;
    }

    return barcode.size.width * barcode.size.height;
  }

  void _showScannerMessage(String message) {
    if (!mounted) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CommonAppBar(title: Text('Barcode Scanner')),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: _supportsCamera
                ? LayoutBuilder(
                    builder: (context, constraints) {
                      final scanWindow = _scanWindowFor(constraints.biggest);

                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          MobileScanner(
                            controller: _scannerController,
                            scanWindow: scanWindow,
                            onDetect: _onDetect,
                            errorBuilder: (context, error) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                    AppSizes.paddingLarge,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.error_outline,
                                        color: Colors.white,
                                        size: 48,
                                      ),
                                      const SizedBox(
                                        height: AppSizes.spacingMedium,
                                      ),
                                      Text(
                                        'Camera error',
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(color: Colors.white),
                                      ),
                                      const SizedBox(
                                        height: AppSizes.spacingSmall,
                                      ),
                                      Text(
                                        'Check camera permission and try again.',
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            placeholderBuilder: (context) {
                              return Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: AppSizes.spacingMedium,
                                    ),
                                    Text(
                                      'Initializing camera...',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          IgnorePointer(
                            child: CustomPaint(
                              painter: _ScannerOverlayPainter(
                                scanWindow: scanWindow,
                              ),
                            ),
                          ),
                          Positioned(
                            left: AppSizes.paddingMedium,
                            right: AppSizes.paddingMedium,
                            bottom: AppSizes.paddingLarge,
                            child: Text(
                              'Align barcode fully inside the box. Move it outside the box, then bring it back to scan again.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )
                : Container(
                    color: Colors.black,
                    padding: const EdgeInsets.all(AppSizes.paddingLarge),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.qr_code_scanner,
                            color: Colors.white,
                            size: 56,
                          ),
                          const SizedBox(height: AppSizes.spacingMedium),
                          Text(
                            'Barcode scanning is available on Android and iOS.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: AppSizes.spacingSmall),
                          Text(
                            'Use a mobile device to scan items.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: theme.scaffoldBackgroundColor,
              child: const _ScannerBillPanel(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pop(),
        tooltip: 'Close scanner',
        child: const Icon(Icons.close),
      ),
    );
  }
}

class _ScannerBillPanel extends ConsumerWidget {
  const _ScannerBillPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calcState = ref.watch(calculatorProvider);
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bill Items (${calcState.itemCount})',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                CurrencyFormatter.format(calcState.subtotal),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: calcState.billItems.isEmpty
              ? Center(
                  child: Text(
                    'No items added yet',
                    style: theme.textTheme.bodyMedium,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingMedium,
                  ),
                  itemCount: calcState.billItems.length,
                  itemBuilder: (context, index) {
                    final item = calcState.billItems[index];
                    return _ScannerBillItemTile(
                      item: item,
                      index: index,
                      onDelete: () => ref
                          .read(calculatorProvider.notifier)
                          .removeItem(index),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _BarcodeScanLock {
  const _BarcodeScanLock({
    required this.code,
    required this.acceptedAt,
    required this.lastSeenAt,
  });

  final String code;
  final DateTime acceptedAt;
  final DateTime lastSeenAt;

  _BarcodeScanLock copyWith({
    String? code,
    DateTime? acceptedAt,
    DateTime? lastSeenAt,
  }) {
    return _BarcodeScanLock(
      code: code ?? this.code,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  const _ScannerOverlayPainter({required this.scanWindow});

  final Rect scanWindow;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Offset.zero & size);
    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          scanWindow,
          const Radius.circular(AppSizes.radiusLarge),
        ),
      );

    final overlayPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    canvas.drawPath(
      overlayPath,
      Paint()..color = Colors.black.withValues(alpha: 0.45),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        scanWindow,
        const Radius.circular(AppSizes.radiusLarge),
      ),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant _ScannerOverlayPainter oldDelegate) {
    return oldDelegate.scanWindow != scanWindow;
  }
}

class _ScannerBillItemTile extends StatelessWidget {
  const _ScannerBillItemTile({
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

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spacingSmall),
      child: ListTile(
        dense: true,
        leading: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          item.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              '${CurrencyFormatter.formatQuantity(item.quantity)} × ${CurrencyFormatter.formatWithoutSymbol(item.rate)}',
              style: theme.textTheme.labelSmall,
            ),
            if (item.hasTax) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  '${item.taxRate.toStringAsFixed(item.taxRate % 1 == 0 ? 0 : 1)}% GST',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.primary,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              CurrencyFormatter.format(item.total),
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () async {
                final shouldDelete = await showConfirmationDialog(
                  context,
                  title: 'Delete item',
                  message: 'Remove "${item.name}" from the current bill?',
                  confirmLabel: 'Delete',
                  isDestructive: true,
                );

                if (!shouldDelete || !context.mounted) {
                  return;
                }

                onDelete();
              },
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Remove item',
              color: AppColors.error,
            ),
          ],
        ),
      ),
    );
  }
}
