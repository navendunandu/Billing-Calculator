import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../domain/invoice_model.dart';
import 'providers/invoice_providers.dart';
import 'widgets/invoice_detail_body.dart';

/// Invoice detail screen showing full invoice information
class InvoiceDetailScreen extends ConsumerWidget {
  const InvoiceDetailScreen({super.key, required this.invoiceId});

  final int invoiceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(invoiceDetailProvider(invoiceId));

    return detailAsync.when(
      loading: () => Scaffold(
        appBar: const CommonAppBar(title: Text('Invoice')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: const CommonAppBar(title: Text('Invoice')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Failed to load invoice'),
              TextButton(
                onPressed: () =>
                    ref.invalidate(invoiceDetailProvider(invoiceId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (detail) {
        if (detail == null) {
          return Scaffold(
            appBar: const CommonAppBar(title: Text('Invoice')),
            body: const Center(child: Text('Invoice not found')),
          );
        }

        return Scaffold(
          appBar: CommonAppBar(
            title: Text(detail.invoice.invoiceNo),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Share PDF',
                onPressed: () => _sharePdf(context, ref, detail),
              ),
              IconButton(
                icon: const Icon(Icons.print),
                tooltip: 'Print',
                onPressed: () => _printInvoice(context, ref, detail),
              ),
            ],
          ),
          body: InvoiceDetailBody(detail: detail),
        );
      },
    );
  }

  Future<void> _sharePdf(
    BuildContext context,
    WidgetRef ref,
    InvoiceDetailModel detail,
  ) async {
    try {
      final prefs = ref.read(userPreferencesProvider);
      await ref.read(invoiceExportServiceProvider).sharePdf(
        detail,
        storeName: prefs.storeName,
        storeGstin: prefs.storeGstin,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Share failed: $e')));
      }
    }
  }

  Future<void> _printInvoice(
    BuildContext context,
    WidgetRef ref,
    InvoiceDetailModel detail,
  ) async {
    try {
      final prefs = ref.read(userPreferencesProvider);
      await ref.read(invoiceExportServiceProvider).printInvoice(
        detail,
        storeName: prefs.storeName,
        storeGstin: prefs.storeGstin,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Print failed: $e')));
      }
    }
  }
}
