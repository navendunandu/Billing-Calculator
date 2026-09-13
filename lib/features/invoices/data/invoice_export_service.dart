import 'dart:typed_data';

import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/database/tables/invoices.dart';
import '../../../core/utils/currency_format.dart';
import '../../../core/utils/date_helpers.dart';
import '../domain/invoice_model.dart';

class InvoiceExportService {
  const InvoiceExportService();

  Future<void> sharePdf(
    InvoiceDetailModel detail, {
    String? storeName,
    String? storeGstin,
  }) async {
    final bytes = await buildPdfBytes(
      detail,
      storeName: storeName,
      storeGstin: storeGstin,
    );
    final file = await _writeTempFile('${detail.invoice.invoiceNo}.pdf', bytes);
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  }

  Future<void> printInvoice(
    InvoiceDetailModel detail, {
    String? storeName,
    String? storeGstin,
  }) async {
    final bytes = await buildPdfBytes(
      detail,
      storeName: storeName,
      storeGstin: storeGstin,
    );
    await Printing.layoutPdf(onLayout: (_) async => bytes);
  }

  Future<void> shareExcel(List<InvoiceModel> invoices) async {
    final bytes = buildExcelBytes(invoices);
    final file = await _writeTempFile('invoice_export.xlsx', bytes);
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  }

  Future<Uint8List> buildPdfBytes(
    InvoiceDetailModel detail, {
    String? storeName,
    String? storeGstin,
  }) async {
    final invoice = detail.invoice;
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (storeName != null && storeName.isNotEmpty)
                  pw.Text(
                    storeName,
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                if (storeGstin != null && storeGstin.isNotEmpty)
                  pw.Text(
                    'GSTIN: $storeGstin',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                pw.SizedBox(height: 4),
                pw.Text(
                  invoice.invoiceNo,
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          pw.Text(DateHelpers.formatDateTime(invoice.createdAt)),
          pw.SizedBox(height: 12),
          pw.Text('Payment: ${_paymentModeLabel(invoice.paymentMode)}'),
          pw.Divider(),
          pw.TableHelper.fromTextArray(
            headers: detail.hasTax
                ? const ['#', 'Item', 'HSN', 'Qty', 'Rate', 'Total']
                : const ['#', 'Item', 'Qty', 'Rate', 'Total'],
            data: detail.items.asMap().entries.map((entry) {
              final item = entry.value;
              if (detail.hasTax) {
                return [
                  '${entry.key + 1}',
                  item.itemName,
                  item.hsnCode ?? '-',
                  CurrencyFormatter.formatQuantity(item.quantity),
                  CurrencyFormatter.formatWithoutSymbol(item.rate),
                  CurrencyFormatter.formatWithoutSymbol(item.total),
                ];
              }
              return [
                '${entry.key + 1}',
                item.itemName,
                CurrencyFormatter.formatQuantity(item.quantity),
                CurrencyFormatter.formatWithoutSymbol(item.rate),
                CurrencyFormatter.formatWithoutSymbol(item.total),
              ];
            }).toList(),
          ),
          if (detail.hasTax && detail.hsnSummary.isNotEmpty) ...[
            pw.SizedBox(height: 14),
            pw.Text(
              'Tax Breakdown (HSN)',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.TableHelper.fromTextArray(
              headers: const [
                'HSN',
                'Rate',
                'Taxable',
                'CGST',
                'SGST',
                'Total Tax',
              ],
              data: detail.hsnSummary
                  .map(
                    (s) => [
                      s.hsnCode,
                      '${s.taxRate.toStringAsFixed(s.taxRate % 1 == 0 ? 0 : 1)}%',
                      CurrencyFormatter.formatWithoutSymbol(s.taxableAmount),
                      CurrencyFormatter.formatWithoutSymbol(s.cgstAmount),
                      CurrencyFormatter.formatWithoutSymbol(s.sgstAmount),
                      CurrencyFormatter.formatWithoutSymbol(s.totalTax),
                    ],
                  )
                  .toList(),
            ),
          ],
          pw.SizedBox(height: 16),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Subtotal'),
              pw.Text(CurrencyFormatter.format(invoice.subtotalAmount)),
            ],
          ),
          if (detail.hasTax) ...[
            pw.SizedBox(height: 4),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Taxable Value'),
                pw.Text(CurrencyFormatter.format(invoice.taxableAmount)),
              ],
            ),
            pw.SizedBox(height: 4),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('CGST'),
                pw.Text(CurrencyFormatter.format(invoice.cgstAmount)),
              ],
            ),
            pw.SizedBox(height: 4),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('SGST'),
                pw.Text(CurrencyFormatter.format(invoice.sgstAmount)),
              ],
            ),
          ],
          if (invoice.discountAmount > 0)
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Discount'),
                pw.Text(
                  '- ${CurrencyFormatter.format(invoice.discountAmount)}',
                ),
              ],
            ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Grand Total',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                CurrencyFormatter.format(invoice.totalAmount),
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
          if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
            pw.SizedBox(height: 12),
            pw.Text('Notes: ${invoice.notes}'),
          ],
        ],
      ),
    );

    return doc.save();
  }

  List<int> buildExcelBytes(List<InvoiceModel> invoices) {
    final excel = Excel.createExcel();
    final sheet = excel['Invoices'];
    excel.delete('Sheet1');

    sheet.appendRow([
      TextCellValue('Invoice No'),
      TextCellValue('Date'),
      TextCellValue('Subtotal'),
      TextCellValue('Taxable'),
      TextCellValue('CGST'),
      TextCellValue('SGST'),
      TextCellValue('Total Tax'),
      TextCellValue('Discount'),
      TextCellValue('Total'),
      TextCellValue('Payment Mode'),
      TextCellValue('Status'),
    ]);

    for (final invoice in invoices) {
      sheet.appendRow([
        TextCellValue(invoice.invoiceNo),
        TextCellValue(DateHelpers.formatDateTime(invoice.createdAt)),
        DoubleCellValue(invoice.subtotalAmount),
        DoubleCellValue(invoice.taxableAmount),
        DoubleCellValue(invoice.cgstAmount),
        DoubleCellValue(invoice.sgstAmount),
        DoubleCellValue(invoice.totalTaxAmount),
        DoubleCellValue(invoice.discountAmount),
        DoubleCellValue(invoice.totalAmount),
        TextCellValue(_paymentModeLabel(invoice.paymentMode)),
        TextCellValue(_paymentStatusLabel(invoice.paymentStatus)),
      ]);
    }

    return excel.encode()!;
  }

  Future<File> _writeTempFile(String name, List<int> bytes) async {
    final dir = await getTemporaryDirectory();
    final file = File(p.join(dir.path, name));
    await file.writeAsBytes(bytes);
    return file;
  }

  String _paymentModeLabel(PaymentMode mode) {
    switch (mode) {
      case PaymentMode.cash:
        return 'Cash';
      case PaymentMode.upi:
        return 'UPI';
      case PaymentMode.credit:
        return 'Credit';
    }
  }

  String _paymentStatusLabel(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.fulfilled:
        return 'Paid';
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.partial:
        return 'Partial';
    }
  }
}
