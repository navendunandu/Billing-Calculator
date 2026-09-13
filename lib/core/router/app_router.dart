import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/calculator/presentation/calculator_screen.dart';
import '../../features/calculator/presentation/barcode_scanner_screen.dart';
import '../../features/checkout/presentation/checkout_screen.dart';
import '../../features/invoices/presentation/invoice_list_screen.dart';
import '../../features/invoices/presentation/invoice_detail_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/inventory/presentation/manage_items_screen.dart';
import '../../features/inventory/presentation/item_form_screen.dart';
import '../../features/customers/presentation/manage_customers_screen.dart';
import '../../features/customers/presentation/customer_detail_screen.dart';
import '../../features/customers/presentation/customer_form_screen.dart';
import '../../features/hsn/presentation/manage_hsn_screen.dart';
import '../../features/categories/presentation/manage_categories_screen.dart';

/// App router configuration using go_router
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    // Splash Screen
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),

    // Calculator (Main) Screen
    GoRoute(path: '/', builder: (context, state) => const CalculatorScreen()),

    // Barcode Scanner Screen
    GoRoute(
      path: '/scanner',
      builder: (context, state) => const BarcodeScannerScreen(),
    ),

    // Checkout Screen
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),

    // Invoice List Screen
    GoRoute(
      path: '/invoices',
      builder: (context, state) => const InvoiceListScreen(),
    ),

    // Invoice Detail Screen
    GoRoute(
      path: '/invoices/:id',
      builder: (context, state) {
        final idStr = state.pathParameters['id'] ?? '0';
        final id = int.tryParse(idStr) ?? 0;
        return InvoiceDetailScreen(invoiceId: id);
      },
    ),

    // Settings Screen
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),

    // HSN & Tax Master Screen
    GoRoute(
      path: '/hsn',
      builder: (context, state) => const ManageHsnScreen(),
    ),

    // Category Master Screen
    GoRoute(
      path: '/categories',
      builder: (context, state) => const ManageCategoriesScreen(),
    ),

    // Inventory Management Screen
    GoRoute(
      path: '/inventory',
      builder: (context, state) => const ManageItemsScreen(),
    ),

    // Add Inventory Item Screen
    GoRoute(
      path: '/inventory/new',
      builder: (context, state) => const InventoryItemFormScreen(),
    ),

    // Edit Inventory Item Screen
    GoRoute(
      path: '/inventory/edit/:id',
      builder: (context, state) {
        final idStr = state.pathParameters['id'] ?? '0';
        final id = int.tryParse(idStr);
        if (id == null) {
          return const ManageItemsScreen();
        }
        return InventoryItemFormScreen(itemId: id);
      },
    ),

    // Customer Management Screen
    GoRoute(
      path: '/customers',
      builder: (context, state) => const ManageCustomersScreen(),
    ),

    // Add Customer Screen
    GoRoute(
      path: '/customers/new',
      builder: (context, state) => const CustomerFormScreen(),
    ),

    // Edit Customer Screen
    GoRoute(
      path: '/customers/edit/:id',
      builder: (context, state) {
        final idStr = state.pathParameters['id'] ?? '0';
        final id = int.tryParse(idStr);
        if (id == null) {
          return const ManageCustomersScreen();
        }
        return CustomerFormScreen(customerId: id);
      },
    ),

    GoRoute(
      path: '/customers/:id',
      builder: (context, state) {
        final idStr = state.pathParameters['id'] ?? '0';
        final id = int.tryParse(idStr);
        if (id == null) {
          return const ManageCustomersScreen();
        }
        return CustomerDetailScreen(customerId: id);
      },
    ),
  ],
);
