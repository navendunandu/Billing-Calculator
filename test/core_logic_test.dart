import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:billing_app_pos/core/database/app_database.dart';
import 'package:billing_app_pos/features/calculator/domain/bill_item.dart';
import 'package:billing_app_pos/features/calculator/domain/calc_logic.dart';
import 'package:billing_app_pos/features/calculator/presentation/providers/calculator_providers.dart';
import 'package:billing_app_pos/features/customers/data/customer_repository.dart';
import 'package:billing_app_pos/features/customers/domain/customer_model.dart';
import 'package:billing_app_pos/features/invoices/data/invoice_repository.dart';
import 'package:billing_app_pos/features/invoices/domain/invoice_model.dart';
import 'package:billing_app_pos/core/database/tables/invoices.dart';
import 'package:billing_app_pos/features/hsn/data/hsn_repository.dart';
import 'package:billing_app_pos/features/hsn/domain/hsn_entry_model.dart';
import 'package:billing_app_pos/features/inventory/data/inventory_repository.dart';
import 'package:billing_app_pos/features/inventory/domain/inventory_item_model.dart';
import 'package:billing_app_pos/features/categories/data/category_repository.dart';
import 'package:billing_app_pos/features/categories/domain/category_model.dart';
import 'package:billing_app_pos/core/services/document_series_service.dart';
import 'package:billing_app_pos/features/settings/domain/preferences_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('CalculatorNotifier', () {
    late ProviderContainer container;
    late CalculatorNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(calculatorProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('appendDigit builds rate input', () {
      notifier.appendDigit('1');
      notifier.appendDigit('2');
      notifier.appendDigit('5');

      expect(notifier.state.rateInput, '125');
      expect(notifier.state.rate, 125);
    });

    test('appendDigit limits decimal places to two', () {
      notifier.appendDigit('1');
      notifier.appendDigit('.');
      notifier.appendDigit('2');
      notifier.appendDigit('3');
      notifier.appendDigit('4');

      expect(notifier.state.rateInput, '1.23');
    });

    test('addBillItem requires quantity and rate', () {
      notifier.appendDigit('0');
      expect(notifier.state.canAddItem, isFalse);

      notifier.clearInput();
      notifier.appendDigit('2');
      notifier.setMode(CalcInputMode.quantity);
      expect(notifier.state.canAddItem, isFalse);
    });

    test('addItem adds line and clears inputs', () {
      notifier.setMode(CalcInputMode.quantity);
      notifier.appendDigit('2');
      notifier.setMode(CalcInputMode.rate);
      notifier.appendDigit('5');
      notifier.appendDigit('0');

      notifier.addItem();

      expect(notifier.state.billItems, hasLength(1));
      expect(notifier.state.billItems.first.total, 100);
      expect(notifier.state.quantityInput, isEmpty);
      expect(notifier.state.rateInput, isEmpty);
    });

    test('addBillItem merges by barcode', () {
      notifier.addBillItem(
        BillItem(id: '1', name: 'Rice', quantity: 1, rate: 10, barcode: '123'),
      );
      notifier.addBillItem(
        BillItem(id: '2', name: 'Rice', quantity: 2, rate: 10, barcode: '123'),
      );

      expect(notifier.state.billItems, hasLength(1));
      expect(notifier.state.billItems.first.quantity, 3);
    });

    test('clearBill resets items', () {
      notifier.setMode(CalcInputMode.quantity);
      notifier.appendDigit('1');
      notifier.setMode(CalcInputMode.rate);
      notifier.appendDigit('1');
      notifier.addItem();

      notifier.clearBill();

      expect(notifier.state.billItems, isEmpty);
      expect(notifier.state.subtotal, 0);
    });
  });

  group('DriftCustomerRepository', () {
    late AppDatabase db;
    late DriftCustomerRepository repository;

    setUp(() async {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      await db.ensureDefaultItemSeries();
      repository = DriftCustomerRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('insertCustomer creates customer with ledger', () async {
      final id = await repository.insertCustomer(
        const CustomerDraft(name: 'Alice', phone: '9876543210'),
      );

      final customer = await repository.getCustomerById(id);
      expect(customer, isNotNull);
      expect(customer!.name, 'Alice');
      expect(customer.ledgerId, greaterThan(0));
    });

    test('insertCustomer rejects empty name', () async {
      expect(
        () => repository.insertCustomer(const CustomerDraft(name: '  ')),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('DriftInvoiceRepository', () {
    late AppDatabase db;
    late DriftInvoiceRepository invoiceRepository;
    late DriftCustomerRepository customerRepository;

    setUp(() async {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      await db.ensureDefaultItemSeries();
      invoiceRepository = DriftInvoiceRepository(db);
      customerRepository = DriftCustomerRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('saveInvoice persists invoice and line items', () async {
      final result = await invoiceRepository.saveInvoice(
        SaveInvoiceRequest(
          items: [BillItem(id: '1', name: 'Rice', quantity: 2, rate: 50)],
          subtotal: 100,
          discount: 0,
          grandTotal: 100,
          paymentMode: PaymentMode.cash,
          paidAmount: 100,
          paymentStatus: PaymentStatus.fulfilled,
        ),
      );

      expect(result.invoiceNo, startsWith('INV-'));

      final detail = await invoiceRepository.getInvoiceDetail(result.invoiceId);
      expect(detail, isNotNull);
      expect(detail!.items, hasLength(1));
      expect(detail.invoice.totalAmount, 100);
    });

    test('saveInvoice updates customer credit for credit payment', () async {
      final customerId = await customerRepository.insertCustomer(
        const CustomerDraft(name: 'Bob'),
      );

      await invoiceRepository.saveInvoice(
        SaveInvoiceRequest(
          items: [BillItem(id: '1', name: 'Oil', quantity: 1, rate: 200)],
          subtotal: 200,
          discount: 0,
          grandTotal: 200,
          paymentMode: PaymentMode.credit,
          paidAmount: 0,
          paymentStatus: PaymentStatus.pending,
          customerId: customerId,
        ),
      );

      final customer = await customerRepository.getCustomerById(customerId);
      expect(customer!.creditDue, 200);
    });

    test('saveInvoice persists and loads tax fields and HSN summaries', () async {
      final item1 = BillItem(
        id: '1',
        name: 'Atta 5kg',
        quantity: 2,
        rate: 210,
        hsnCode: '1101',
        taxRate: 5.0,
        isTaxInclusive: true,
      );
      final item2 = BillItem(
        id: '2',
        name: 'Electric Cable',
        quantity: 1,
        rate: 500,
        hsnCode: '8544',
        taxRate: 18.0,
        isTaxInclusive: false,
      );

      final state = CalculatorState(billItems: [item1, item2]);

      final result = await invoiceRepository.saveInvoice(
        SaveInvoiceRequest(
          items: state.billItems,
          subtotal: state.subtotal,
          discount: 0,
          grandTotal: state.subtotal,
          taxableAmount: state.totalTaxableAmount,
          totalTaxAmount: state.totalTaxAmount,
          cgstAmount: state.totalCgstAmount,
          sgstAmount: state.totalSgstAmount,
          paymentMode: PaymentMode.cash,
          paidAmount: state.subtotal,
          paymentStatus: PaymentStatus.fulfilled,
        ),
      );

      final detail = await invoiceRepository.getInvoiceDetail(result.invoiceId);
      expect(detail, isNotNull);
      expect(detail!.invoice.hasTax, isTrue);
      expect(detail.invoice.totalAmount, 420.0 + 590.0);
      expect(detail.invoice.taxableAmount, closeTo(400.0 + 500.0, 0.001));
      expect(detail.invoice.totalTaxAmount, closeTo(20.0 + 90.0, 0.001));
      expect(detail.invoice.cgstAmount, closeTo(10.0 + 45.0, 0.001));
      expect(detail.invoice.sgstAmount, closeTo(10.0 + 45.0, 0.001));

      expect(detail.items, hasLength(2));
      final line1 = detail.items.firstWhere((i) => i.itemName == 'Atta 5kg');
      expect(line1.hsnCode, '1101');
      expect(line1.taxRate, 5.0);
      expect(line1.taxableAmount, closeTo(400.0, 0.001));
      expect(line1.taxAmount, closeTo(20.0, 0.001));
      expect(line1.cgstAmount, closeTo(10.0, 0.001));
      expect(line1.sgstAmount, closeTo(10.0, 0.001));

      final summaries = detail.hsnSummary;
      expect(summaries, hasLength(2));
      final hsn1101 = summaries.firstWhere((s) => s.hsnCode == '1101');
      expect(hsn1101.taxRate, 5.0);
      expect(hsn1101.taxableAmount, closeTo(400.0, 0.001));
      expect(hsn1101.totalTax, closeTo(20.0, 0.001));
    });
  });

  group('AppDatabase migrations', () {
    test('creates schema on fresh database', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);

      final count = await db.getTotalItemsCount();
      expect(count, 0);

      expect(db.schemaVersion, 11);
    });

    test('HSN repository inserts and reads HSN slabs', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final repo = DriftHsnRepository(db);

      final id = await repo.insertHsnEntry(
        const HsnEntryDraft(
          hsnCode: '9999',
          description: 'Custom Test Service',
          gstRate: 18.0,
        ),
      );

      final entry = await repo.getHsnById(id);
      expect(entry, isNotNull);
      expect(entry!.hsnCode, '9999');
      expect(entry.gstRate, 18.0);
      expect(entry.cgstRate, 9.0);
      expect(entry.sgstRate, 9.0);
    });

    test('Inventory repository persists and loads tax fields', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final seriesService = DocumentSeriesService(db);
      final repo = DriftInventoryRepository(db, seriesService);

      final id = await repo.insertItem(
        const InventoryItemDraft(
          code: 'ITM-9001',
          name: 'Fresh Mangoes',
          category: 'Fruits',
          brand: 'Farm Fresh',
          price: 150.0,
          hsnCode: '0804',
          taxRate: 5.0,
          isTaxInclusive: true,
        ),
      );

      final item = await repo.getItemById(id);
      expect(item, isNotNull);
      expect(item!.hsnCode, '0804');
      expect(item.taxRate, 5.0);
      expect(item.isTaxInclusive, isTrue);
      expect(item.taxLabel, '5% GST');
    });

    test('Category repository seeds defaults, manages CRUD and item counts', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final categoryRepo = DriftCategoryRepository(db);
      final seriesService = DocumentSeriesService(db);
      final inventoryRepo = DriftInventoryRepository(db, seriesService);

      // Default categories seeded
      final defaults = await categoryRepo.getAllCategories();
      expect(defaults, isNotEmpty);
      final names = defaults.map((c) => c.name).toSet();
      expect(names.contains('Fruits'), isTrue);
      expect(names.contains('Dairy'), isTrue);
      expect(names.contains('Bakery'), isTrue);

      // Insert new category
      final created = await categoryRepo.insertCategory(
        const CategoryDraft(
          name: 'Frozen Foods',
          description: 'Ice cream and frozen vegetables',
        ),
      );
      expect(created.id, greaterThan(0));
      expect(created.name, 'Frozen Foods');

      // Case-insensitive lookup
      final fetched = await categoryRepo.getCategoryByName('frozen foods');
      expect(fetched, isNotNull);
      expect(fetched!.name, 'Frozen Foods');

      // Add items under 'Frozen Foods' and verify count
      await inventoryRepo.insertItem(
        const InventoryItemDraft(
          code: 'ITM-9101',
          name: 'Vanilla Ice Cream',
          category: 'Frozen Foods',
          brand: 'Creamy',
          price: 80.0,
        ),
      );
      await inventoryRepo.insertItem(
        const InventoryItemDraft(
          code: 'ITM-9102',
          name: 'Frozen Green Peas',
          category: 'Frozen Foods',
          brand: 'Farm Green',
          price: 45.0,
        ),
      );

      final withCounts = await categoryRepo.getAllCategories(withItemCounts: true);
      final frozenCategory = withCounts.firstWhere((c) => c.name == 'Frozen Foods');
      expect(frozenCategory.itemCount, 2);

      // Update category
      final updated = await categoryRepo.updateCategory(
        created.id,
        const CategoryDraft(
          name: 'Frozen & Chilled Foods',
          description: 'Updated description',
        ),
      );
      expect(updated, isTrue);

      final afterUpdate = await categoryRepo.getCategoryById(created.id);
      expect(afterUpdate?.name, 'Frozen & Chilled Foods');

      // Delete category
      final deleted = await categoryRepo.deleteCategory(created.id);
      expect(deleted, isTrue);
      final afterDelete = await categoryRepo.getCategoryById(created.id);
      expect(afterDelete, isNull);
    });
  });

  group('BillItem & CalculatorState Tax Logic', () {
    test('Tax-inclusive (MRP) item calculates taxable amount and tax correctly', () {
      final item = BillItem(
        id: '1',
        name: 'Biscuit MRP',
        quantity: 2,
        rate: 105,
        taxRate: 5.0,
        isTaxInclusive: true,
      );

      expect(item.grossAmount, 210.0);
      expect(item.taxableAmount, closeTo(200.0, 0.001));
      expect(item.taxAmount, closeTo(10.0, 0.001));
      expect(item.cgstAmount, closeTo(5.0, 0.001));
      expect(item.sgstAmount, closeTo(5.0, 0.001));
      expect(item.total, 210.0);
    });

    test('Tax-exclusive item calculates taxable amount and adds tax on top', () {
      final item = BillItem(
        id: '2',
        name: 'Hardware Tool',
        quantity: 1,
        rate: 500,
        taxRate: 18.0,
        isTaxInclusive: false,
      );

      expect(item.grossAmount, 500.0);
      expect(item.taxableAmount, 500.0);
      expect(item.taxAmount, 90.0);
      expect(item.cgstAmount, 45.0);
      expect(item.sgstAmount, 45.0);
      expect(item.total, 590.0);
    });

    test('Zero tax item behaves identical to standard line item', () {
      final item = BillItem(
        id: '3',
        name: 'Exempt Food',
        quantity: 3,
        rate: 40,
        taxRate: 0.0,
      );

      expect(item.grossAmount, 120.0);
      expect(item.taxableAmount, 120.0);
      expect(item.taxAmount, 0.0);
      expect(item.cgstAmount, 0.0);
      expect(item.sgstAmount, 0.0);
      expect(item.total, 120.0);
      expect(item.hasTax, isFalse);
    });

    test('CalculatorState aggregates totals, taxable, and taxes accurately', () {
      final item1 = BillItem(
        id: '1',
        name: 'Item Inclusive 5%',
        quantity: 2,
        rate: 105,
        taxRate: 5.0,
        isTaxInclusive: true,
      );
      final item2 = BillItem(
        id: '2',
        name: 'Item Exclusive 18%',
        quantity: 1,
        rate: 500,
        taxRate: 18.0,
        isTaxInclusive: false,
      );

      final state = CalculatorState(billItems: [item1, item2]);

      expect(state.itemCount, 2);
      expect(state.totalQuantity, 3);
      expect(state.hasTax, isTrue);
      expect(state.subtotal, 210.0 + 590.0);
      expect(state.totalTaxableAmount, closeTo(200.0 + 500.0, 0.001));
      expect(state.totalTaxAmount, closeTo(10.0 + 90.0, 0.001));
      expect(state.totalCgstAmount, closeTo(5.0 + 45.0, 0.001));
      expect(state.totalSgstAmount, closeTo(5.0 + 45.0, 0.001));
    });

    test('CalculatorNotifier addBillItem preserves tax attributes when merging', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(calculatorProvider.notifier);

      notifier.addBillItem(
        BillItem(
          id: '1',
          name: 'Shampoo',
          quantity: 1,
          rate: 100,
          barcode: 'BAR-SHAMPOO',
          hsnCode: '3305',
          taxRate: 18.0,
          isTaxInclusive: true,
        ),
      );
      notifier.addBillItem(
        BillItem(
          id: '2',
          name: 'Shampoo',
          quantity: 2,
          rate: 100,
          barcode: 'BAR-SHAMPOO',
          hsnCode: '3305',
          taxRate: 18.0,
          isTaxInclusive: true,
        ),
      );

      expect(notifier.state.billItems, hasLength(1));
      final merged = notifier.state.billItems.first;
      expect(merged.quantity, 3);
      expect(merged.hsnCode, '3305');
      expect(merged.taxRate, 18.0);
      expect(merged.isTaxInclusive, isTrue);
      expect(merged.total, 300.0);
    });
  });

  group('UserPreferences Tax & Store Settings', () {
    test('default preferences have GST billing enabled and empty store credentials', () {
      const prefs = UserPreferences();
      expect(prefs.gstBillingEnabled, isTrue);
      expect(prefs.storeGstin, isEmpty);
      expect(prefs.storeName, isEmpty);
    });

    test('saves and loads GST and store preferences from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        'gstBillingEnabled': false,
        'storeGstin': '27ABCDE1234F1Z5',
        'storeName': 'Apex Retailers',
      });

      final sp = await SharedPreferences.getInstance();
      final loaded = UserPreferences.fromPrefs(sp);

      expect(loaded.gstBillingEnabled, isFalse);
      expect(loaded.storeGstin, '27ABCDE1234F1Z5');
      expect(loaded.storeName, 'Apex Retailers');

      final modified = loaded.copyWith(
        gstBillingEnabled: true,
        storeGstin: '29ABCDE9876F1Z2',
        storeName: 'Metro Stores',
      );
      await modified.saveToPrefs(sp);

      final reloaded = UserPreferences.fromPrefs(sp);
      expect(reloaded.gstBillingEnabled, isTrue);
      expect(reloaded.storeGstin, '29ABCDE9876F1Z2');
      expect(reloaded.storeName, 'Metro Stores');
    });
  });
}
