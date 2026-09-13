import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/invoices.dart';
import 'tables/invoice_items.dart';
import 'tables/customers.dart';
import 'tables/ledgers.dart';
import 'tables/vouchers.dart';
import 'tables/ledger_entries.dart';
import 'tables/inventory_items.dart';
import 'tables/document_series_numbers.dart';
import 'tables/hsn_entries.dart';
import 'tables/categories.dart';

part 'app_database.g.dart';

/// Main database class for the billing app
@DriftDatabase(
  tables: [
    Invoices,
    InvoiceItems,
    InventoryItems,
    DocumentSeriesNumbers,
    Customers,
    Ledgers,
    Vouchers,
    LedgerEntries,
    HsnEntries,
    Categories,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// In-memory database for unit/integration tests.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 11;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await ensureDefaultItemSeries();
        await ensureDefaultHsnEntries();
        await ensureDefaultCategories();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Run migrations cumulatively so users can jump multiple schema
        // versions in a single upgrade. Every step is guarded so it can be
        // re-run safely against partially migrated databases.
        if (from < 2) {
          if (!await _tableExists('inventory_items')) {
            await m.createTable(inventoryItems);
          }
        }

        if (from < 3) {
          if (!await _columnExists('inventory_items', 'barcode')) {
            await m.addColumn(inventoryItems, inventoryItems.barcode);
          }
        }

        if (from < 4) {
          if (!await _columnExists('inventory_items', 'uom')) {
            await m.addColumn(inventoryItems, inventoryItems.uom);
          }
          if (!await _columnExists('inventory_items', 'unit_value')) {
            await m.addColumn(inventoryItems, inventoryItems.unitValue);
          }
        }

        if (from < 5) {
          if (!await _tableExists('document_series_numbers')) {
            await m.createTable(documentSeriesNumbers);
          }
          await ensureDefaultItemSeries();
        }

        if (from < 6) {
          if (!await _tableExists('ledgers')) {
            await m.createTable(ledgers);
          }
          if (!await _tableExists('customers')) {
            await m.createTable(customers);
          }
          if (!await _tableExists('vouchers')) {
            await m.createTable(vouchers);
          }
          if (!await _tableExists('ledger_entries')) {
            await m.createTable(ledgerEntries);
          }
          if (!await _columnExists('invoices', 'customer_id')) {
            await m.addColumn(invoices, invoices.customerId);
          }
          if (!await _columnExists('invoices', 'paid_amount')) {
            await m.addColumn(invoices, invoices.paidAmount);
          }
        }

        if (from < 7) {
          if (!await _columnExists('customers', 'credit_limit')) {
            await m.addColumn(customers, customers.creditLimit);
          }
          if (!await _columnExists('customers', 'credit_due')) {
            await m.addColumn(customers, customers.creditDue);
          }
        }

        if (from < 8) {
          await _normalizeInvoicePaymentData();
        }

        if (from < 9) {
          if (!await _tableExists('hsn_entries')) {
            await m.createTable(hsnEntries);
          }
          await ensureDefaultHsnEntries();

          if (!await _columnExists('inventory_items', 'hsn_code')) {
            await m.addColumn(inventoryItems, inventoryItems.hsnCode);
          }
          if (!await _columnExists('inventory_items', 'tax_rate')) {
            await m.addColumn(inventoryItems, inventoryItems.taxRate);
          }
          if (!await _columnExists('inventory_items', 'is_tax_inclusive')) {
            await m.addColumn(inventoryItems, inventoryItems.isTaxInclusive);
          }
        }

        if (from < 10) {
          if (!await _columnExists('invoices', 'taxable_amount')) {
            await m.addColumn(invoices, invoices.taxableAmount);
          }
          if (!await _columnExists('invoices', 'total_tax_amount')) {
            await m.addColumn(invoices, invoices.totalTaxAmount);
          }
          if (!await _columnExists('invoices', 'cgst_amount')) {
            await m.addColumn(invoices, invoices.cgstAmount);
          }
          if (!await _columnExists('invoices', 'sgst_amount')) {
            await m.addColumn(invoices, invoices.sgstAmount);
          }
          if (!await _columnExists('invoice_items', 'hsn_code')) {
            await m.addColumn(invoiceItems, invoiceItems.hsnCode);
          }
          if (!await _columnExists('invoice_items', 'tax_rate')) {
            await m.addColumn(invoiceItems, invoiceItems.taxRate);
          }
          if (!await _columnExists('invoice_items', 'taxable_amount')) {
            await m.addColumn(invoiceItems, invoiceItems.taxableAmount);
          }
          if (!await _columnExists('invoice_items', 'tax_amount')) {
            await m.addColumn(invoiceItems, invoiceItems.taxAmount);
          }
          if (!await _columnExists('invoice_items', 'cgst_amount')) {
            await m.addColumn(invoiceItems, invoiceItems.cgstAmount);
          }
          if (!await _columnExists('invoice_items', 'sgst_amount')) {
            await m.addColumn(invoiceItems, invoiceItems.sgstAmount);
          }
          if (!await _columnExists('invoice_items', 'is_tax_inclusive')) {
            await m.addColumn(invoiceItems, invoiceItems.isTaxInclusive);
          }
        }

        if (from < 11) {
          if (!await _tableExists('categories')) {
            await m.createTable(categories);
          }
          await ensureDefaultCategories();
        }
      },
    );
  }

  static const String itemSeriesModule = 'item';

  // ============ Invoice Operations ============

  /// Get all invoices ordered by creation date (newest first)
  Future<List<Invoice>> getAllInvoices() {
    return (select(
      invoices,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }

  /// Get invoices by date range
  Future<List<Invoice>> getInvoicesByDateRange(DateTime start, DateTime end) {
    return (select(invoices)
          ..where((t) => t.createdAt.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Get invoices by payment mode
  Future<List<Invoice>> getInvoicesByPaymentMode(PaymentMode mode) {
    return (select(invoices)
          ..where((t) => t.paymentMode.equals(mode.index))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Get single invoice by ID
  Future<Invoice?> getInvoiceById(int id) {
    return (select(invoices)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Get invoice by invoice number
  Future<Invoice?> getInvoiceByNumber(String invoiceNo) {
    return (select(
      invoices,
    )..where((t) => t.invoiceNo.equals(invoiceNo))).getSingleOrNull();
  }

  /// Insert a new invoice
  Future<int> insertInvoice(InvoicesCompanion invoice) {
    return into(invoices).insert(invoice);
  }

  /// Update an invoice
  Future<bool> updateInvoice(Invoice invoice) {
    return update(invoices).replace(invoice);
  }

  /// Delete an invoice
  Future<int> deleteInvoice(int id) {
    return (delete(invoices)..where((t) => t.id.equals(id))).go();
  }

  /// Get invoice count for a specific date (for serial number generation)
  Future<int> getInvoiceCountForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final result = await (select(
      invoices,
    )..where((t) => t.createdAt.isBetweenValues(startOfDay, endOfDay))).get();

    return result.length;
  }

  /// Get daily summary (total amount, count per payment mode)
  Future<Map<String, dynamic>> getDailySummary(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final dayInvoices = await (select(
      invoices,
    )..where((t) => t.createdAt.isBetweenValues(startOfDay, endOfDay))).get();

    double totalAmount = 0;
    double cashAmount = 0;
    double upiAmount = 0;
    double creditAmount = 0;

    for (final inv in dayInvoices) {
      totalAmount += inv.totalAmount;
      switch (inv.paymentMode) {
        case PaymentMode.cash:
          cashAmount += inv.totalAmount;
          break;
        case PaymentMode.upi:
          upiAmount += inv.totalAmount;
          break;
        case PaymentMode.credit:
          creditAmount += inv.totalAmount;
          break;
      }
    }

    return {
      'date': date,
      'invoiceCount': dayInvoices.length,
      'totalAmount': totalAmount,
      'cashAmount': cashAmount,
      'upiAmount': upiAmount,
      'creditAmount': creditAmount,
    };
  }

  // ============ Invoice Items Operations ============

  /// Get all items for an invoice
  Future<List<InvoiceItem>> getItemsForInvoice(int invoiceId) {
    return (select(invoiceItems)
          ..where((t) => t.invoiceId.equals(invoiceId))
          ..orderBy([(t) => OrderingTerm.asc(t.serialNo)]))
        .get();
  }

  /// Insert invoice item
  Future<int> insertInvoiceItem(InvoiceItemsCompanion item) {
    return into(invoiceItems).insert(item);
  }

  /// Insert multiple invoice items
  Future<void> insertInvoiceItems(List<InvoiceItemsCompanion> items) async {
    await batch((batch) {
      batch.insertAll(invoiceItems, items);
    });
  }

  /// Delete all items for an invoice
  Future<int> deleteItemsForInvoice(int invoiceId) {
    return (delete(
      invoiceItems,
    )..where((t) => t.invoiceId.equals(invoiceId))).go();
  }

  /// Get total items count across all invoices
  Future<int> getTotalItemsCount() async {
    final result = await select(invoiceItems).get();
    return result.length;
  }

  // ============ Inventory Operations ============

  /// Watch all inventory items (excluding archived by default)
  Stream<List<InventoryItem>> watchAllInventoryItems({
    bool includeArchived = false,
  }) {
    final query = select(inventoryItems)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);

    if (!includeArchived) {
      query.where(
        (t) => t.status.isNotValue(InventoryItemStatus.archived.index),
      );
    }

    return query.watch();
  }

  /// Get inventory item by unique code
  Future<InventoryItem?> getInventoryItemByCode(String code) {
    return (select(
      inventoryItems,
    )..where((t) => t.code.equals(code))).getSingleOrNull();
  }

  /// Get inventory item by ID
  Future<InventoryItem?> getInventoryItemById(int id) {
    return (select(
      inventoryItems,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Insert a new inventory item
  Future<int> insertInventoryItem(InventoryItemsCompanion item) {
    return into(inventoryItems).insert(item);
  }

  /// Update an existing inventory item
  Future<bool> updateInventoryItem(InventoryItem item) {
    return update(inventoryItems).replace(item);
  }

  /// Delete inventory item by ID
  Future<int> deleteInventoryItem(int id) {
    return (delete(inventoryItems)..where((t) => t.id.equals(id))).go();
  }

  // ============ Ledger Operations ============

  /// Insert a new ledger entry and return the generated id.
  Future<int> insertLedger(LedgersCompanion ledger) {
    return into(ledgers).insert(ledger);
  }

  // ============ Customer Operations ============

  /// Watch all customers ordered by newest first.
  Stream<List<Customer>> watchAllCustomers() {
    return (select(
      customers,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();
  }

  /// Get single customer by ID.
  Future<Customer?> getCustomerById(int id) {
    return (select(customers)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Insert a new customer.
  Future<int> insertCustomer(CustomersCompanion customer) {
    return into(customers).insert(customer);
  }

  /// Create a customer and linked customer ledger in a single transaction.
  Future<int> createCustomerWithLedger({
    required String customerName,
    String? phone,
    String? address,
  }) {
    return transaction(() async {
      final normalizedName = customerName.trim();
      final normalizedPhone = phone?.trim();
      final normalizedAddress = address?.trim();

      final ledgerId = await insertLedger(
        LedgersCompanion.insert(name: normalizedName, type: 'customer'),
      );

      return insertCustomer(
        CustomersCompanion.insert(
          name: normalizedName,
          creditLimit: const Value(500.0),
          creditDue: const Value(0.0),
          phone: Value(
            normalizedPhone == null || normalizedPhone.isEmpty
                ? null
                : normalizedPhone,
          ),
          address: Value(
            normalizedAddress == null || normalizedAddress.isEmpty
                ? null
                : normalizedAddress,
          ),
          ledgerId: ledgerId,
        ),
      );
    });
  }

  /// Update an existing customer.
  Future<bool> updateCustomer(Customer customer) {
    return update(customers).replace(customer);
  }

  /// Delete customer by ID.
  Future<int> deleteCustomer(int id) {
    return (delete(customers)..where((t) => t.id.equals(id))).go();
  }

  // ============ Document Series Operations ============

  Future<DocumentSeriesNumber?> getSeriesByModule(String module) {
    return (select(documentSeriesNumbers)
          ..where((t) => t.module.equals(module.trim().toLowerCase())))
        .getSingleOrNull();
  }

  Future<void> ensureDefaultItemSeries() async {
    await customStatement('''
      CREATE TABLE IF NOT EXISTS document_series_numbers (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        module TEXT NOT NULL UNIQUE,
        starting_number INTEGER NOT NULL DEFAULT 1001,
        current_number INTEGER NOT NULL DEFAULT 1001,
        prefix TEXT,
        suffix TEXT,
        pattern TEXT NOT NULL DEFAULT '{prefix}-{current_number}',
        status INTEGER NOT NULL DEFAULT 1,
        created_at INTEGER NOT NULL DEFAULT (strftime('%s','now') * 1000),
        updated_at INTEGER NOT NULL DEFAULT (strftime('%s','now') * 1000)
      )
    ''');

    // Repair older rows where timestamps may have been stored as text.
    await customStatement('''
      UPDATE document_series_numbers
      SET created_at = CAST(strftime('%s', created_at) AS INTEGER) * 1000
      WHERE typeof(created_at) = 'text'
    ''');

    await customStatement('''
      UPDATE document_series_numbers
      SET updated_at = CAST(strftime('%s', updated_at) AS INTEGER) * 1000
      WHERE typeof(updated_at) = 'text'
    ''');

    final existing = await getSeriesByModule(itemSeriesModule);
    if (existing != null) {
      return;
    }

    await into(documentSeriesNumbers).insert(
      DocumentSeriesNumbersCompanion.insert(
        module: itemSeriesModule,
        prefix: const Value('ITM'),
        startingNumber: const Value(1001),
        currentNumber: const Value(1001),
        pattern: const Value('{prefix}-{current_number}'),
        status: const Value(1),
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<void> incrementSeriesNumber(String module) async {
    final normalizedModule = module.trim().toLowerCase();
    final nowMillis = DateTime.now().millisecondsSinceEpoch;

    await customStatement(
      'UPDATE document_series_numbers '
      'SET current_number = current_number + 1, updated_at = ? '
      'WHERE module = ?',
      [nowMillis, normalizedModule],
    );
  }

  Future<void> _normalizeInvoicePaymentData() async {
    final cashMode = PaymentMode.cash.index;
    final upiMode = PaymentMode.upi.index;
    final creditMode = PaymentMode.credit.index;
    final pendingStatus = PaymentStatus.pending.index;
    final partialStatus = PaymentStatus.partial.index;
    final fulfilledStatus = PaymentStatus.fulfilled.index;

    await customStatement(
      'UPDATE invoices '
      'SET paid_amount = total_amount '
      'WHERE payment_mode IN (?, ?)',
      [cashMode, upiMode],
    );

    await customStatement(
      'UPDATE invoices '
      'SET payment_status = ? '
      'WHERE payment_mode IN (?, ?)',
      [fulfilledStatus, cashMode, upiMode],
    );

    await customStatement(
      'UPDATE invoices '
      'SET payment_status = CASE '
      '  WHEN paid_amount <= 0 THEN ? '
      '  WHEN paid_amount >= total_amount THEN ? '
      '  ELSE ? '
      'END '
      'WHERE payment_mode = ?',
      [pendingStatus, fulfilledStatus, partialStatus, creditMode],
    );
  }

  /// Check whether a table exists using sqlite_master.
  Future<bool> _tableExists(String table) async {
    try {
      final rows = await customSelect(
        'SELECT name FROM sqlite_master WHERE type = ? AND name = ? LIMIT 1',
        variables: [Variable<String>('table'), Variable<String>(table)],
      ).get();
      return rows.isNotEmpty;
    } catch (e) {
      debugPrint('Failed to check table existence for $table: $e');
      return false;
    }
  }

  /// Check whether a specific column exists in a table using PRAGMA.
  Future<bool> _columnExists(String table, String column) async {
    try {
      final rows = await customSelect('PRAGMA table_info("$table")').get();
      for (final row in rows) {
        try {
          final name = row.read<String>('name');
          if (name == column) return true;
        } catch (_) {
          // ignore rows that don't have the expected column
        }
      }
      return false;
    } catch (e) {
      debugPrint('Failed to check column existence for $table.$column: $e');
      // If we can't determine, be conservative and return false so migration will attempt
      return false;
    }
  }

  // ============ HSN Operations ============

  /// Get all HSN entries ordered by code
  Future<List<HsnEntry>> getAllHsnEntries() {
    return (select(hsnEntries)
          ..orderBy([(t) => OrderingTerm.asc(t.hsnCode)]))
        .get();
  }

  /// Get a single HSN entry by code
  Future<HsnEntry?> getHsnByCode(String code) {
    return (select(hsnEntries)
          ..where((t) => t.hsnCode.equals(code.trim())))
        .getSingleOrNull();
  }

  /// Get a single HSN entry by primary key ID
  Future<HsnEntry?> getHsnById(int id) {
    return (select(hsnEntries)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Insert a new HSN entry
  Future<int> insertHsnEntry(HsnEntriesCompanion entry) {
    return into(hsnEntries).insert(entry);
  }

  /// Update an existing HSN entry
  Future<bool> updateHsnEntry(HsnEntriesCompanion entry) {
    return update(hsnEntries).replace(entry);
  }

  /// Delete an HSN entry by ID
  Future<int> deleteHsnEntry(int id) {
    return (delete(hsnEntries)..where((t) => t.id.equals(id))).go();
  }

  /// Ensure common GST tax slabs are populated
  Future<void> ensureDefaultHsnEntries() async {
    try {
      final count = await customSelect('SELECT COUNT(*) AS c FROM hsn_entries').getSingle();
      final total = count.read<int>('c');
      if (total == 0) {
        final now = DateTime.now().millisecondsSinceEpoch;
        final defaultSlabs = [
          ('0000', 'Exempted / Nil Rated Goods & Services', 0.0, 0.0, 0.0, 0.0, true),
          ('0808', 'Fresh Fruits (Apples, Pears, etc.)', 0.0, 0.0, 0.0, 0.0, false),
          ('1001', 'Wheat and Meslin / Food Grains', 5.0, 2.5, 2.5, 5.0, false),
          ('0401', 'Dairy Products (Milk, Cream, etc.)', 5.0, 2.5, 2.5, 5.0, false),
          ('1905', 'Bakery, Pastries, Biscuits & Cakes', 12.0, 6.0, 6.0, 12.0, false),
          ('2106', 'Packaged Food & Confectionery', 18.0, 9.0, 9.0, 18.0, false),
          ('8471', 'Electronics, Computers & POS Hardware', 18.0, 9.0, 9.0, 18.0, false),
          ('2202', 'Aerated Beverages & Luxury Items', 28.0, 14.0, 14.0, 28.0, false),
        ];

        for (final slab in defaultSlabs) {
          await customStatement(
            'INSERT OR IGNORE INTO hsn_entries (hsn_code, description, gst_rate, cgst_rate, sgst_rate, igst_rate, is_default, created_at, updated_at) '
            'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
            [slab.$1, slab.$2, slab.$3, slab.$4, slab.$5, slab.$6, slab.$7 ? 1 : 0, now, now],
          );
        }
      }
    } catch (e) {
      debugPrint('ensureDefaultHsnEntries failed: $e');
    }
  }

  // ============ Category Operations ============

  /// Stream of all categories ordered by name ascending
  Stream<List<Category>> watchAllCategories() {
    return (select(categories)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();
  }

  /// Get all categories ordered by name ascending
  Future<List<Category>> getAllCategories() {
    return (select(categories)..orderBy([(t) => OrderingTerm.asc(t.name)])).get();
  }

  /// Get single category by ID
  Future<Category?> getCategoryById(int id) {
    return (select(categories)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Get single category by name (case-insensitive)
  Future<Category?> getCategoryByName(String name) {
    final trimmed = name.trim().toLowerCase();
    return (select(categories)..where((t) => t.name.lower().equals(trimmed))).getSingleOrNull();
  }

  /// Insert a new category
  Future<int> insertCategory(CategoriesCompanion entry) {
    return into(categories).insert(entry);
  }

  /// Update an existing category
  Future<bool> updateCategory(CategoriesCompanion entry) {
    return update(categories).replace(entry);
  }

  /// Delete a category by ID
  Future<int> deleteCategory(int id) {
    return (delete(categories)..where((t) => t.id.equals(id))).go();
  }

  /// Get item counts per category for active inventory items
  Future<Map<String, int>> getCategoryItemCounts() async {
    final result = <String, int>{};
    try {
      if (await _tableExists('inventory_items')) {
        final rows = await customSelect(
          'SELECT category, COUNT(*) as cnt FROM inventory_items WHERE status != ? GROUP BY category',
          variables: [Variable.withInt(InventoryItemStatus.archived.index)],
        ).get();
        for (final row in rows) {
          final cat = row.read<String?>('category');
          if (cat != null && cat.isNotEmpty) {
            result[cat] = row.read<int>('cnt');
          }
        }
      }
    } catch (e) {
      debugPrint('getCategoryItemCounts failed: $e');
    }
    return result;
  }

  /// Ensure default product categories are populated
  Future<void> ensureDefaultCategories() async {
    try {
      final defaultCategories = [
        ('Fruits', 'Fresh seasonal & imported fruits'),
        ('Vegetables', 'Fresh farm vegetables & greens'),
        ('Dairy', 'Milk, cheese, butter, yogurt & curd'),
        ('Bakery', 'Bread, cakes, cookies & pastries'),
        ('Beverages', 'Juices, soda, tea, coffee & soft drinks'),
        ('Snacks', 'Chips, namkeen, biscuits & packaged snacks'),
        ('Poultry', 'Eggs, poultry, meat & fresh protein'),
        ('Electronics', 'Cables, chargers, batteries & gadgets'),
        ('Home', 'Cleaning, personal care & household essentials'),
      ];

      final now = DateTime.now().millisecondsSinceEpoch;
      for (final cat in defaultCategories) {
        await customStatement(
          'INSERT OR IGNORE INTO categories (name, description, created_at, updated_at) '
          'VALUES (?, ?, ?, ?)',
          [cat.$1, cat.$2, now, now],
        );
      }

      // Also backfill any categories from inventory_items that might not be in defaults
      if (await _tableExists('inventory_items')) {
        final existingRows = await customSelect(
          "SELECT DISTINCT category FROM inventory_items WHERE category IS NOT NULL AND TRIM(category) != ''",
        ).get();
        for (final row in existingRows) {
          final catName = row.read<String>('category').trim();
          if (catName.isNotEmpty) {
            await customStatement(
              'INSERT OR IGNORE INTO categories (name, created_at, updated_at) VALUES (?, ?, ?)',
              [catName, now, now],
            );
          }
        }
      }
    } catch (e) {
      debugPrint('ensureDefaultCategories failed: $e');
    }
  }
}

/// Opens a connection to the database
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'billing_app.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
