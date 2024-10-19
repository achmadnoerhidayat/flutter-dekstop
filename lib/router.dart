import 'package:go_router/go_router.dart';
import 'package:kasir_dekstop/page/auth/login_screen.dart';
import 'package:kasir_dekstop/page/auth/register_screen.dart';
import 'package:kasir_dekstop/page/home/home_screen.dart';
import 'package:kasir_dekstop/page/home/transaksi_succes.dart';
import 'package:kasir_dekstop/page/ofiice/category/category_screen.dart';
import 'package:kasir_dekstop/page/ofiice/customer/daftar_customer_screen.dart';
import 'package:kasir_dekstop/page/ofiice/dashboard_screen.dart';
import 'package:kasir_dekstop/page/ofiice/discount/discount_screen.dart';
import 'package:kasir_dekstop/page/ofiice/finance/finance_screen.dart';
import 'package:kasir_dekstop/page/ofiice/gula/gula_screen.dart';
import 'package:kasir_dekstop/page/ofiice/hutang/hutang_gula_screen.dart';
import 'package:kasir_dekstop/page/ofiice/inventory/adjustment/adjustment_screen.dart';
import 'package:kasir_dekstop/page/ofiice/inventory/order/order_screen.dart';
import 'package:kasir_dekstop/page/ofiice/inventory/summary/summart_screen.dart';
import 'package:kasir_dekstop/page/ofiice/inventory/suplier/suplier_screen.dart';
import 'package:kasir_dekstop/page/ofiice/kasbon/kasbon_screen.dart';
import 'package:kasir_dekstop/page/ofiice/library/item_library_screen.dart';
import 'package:kasir_dekstop/page/ofiice/promo/add_promo.dart';
import 'package:kasir_dekstop/page/ofiice/promo/promo_screen.dart';
import 'package:kasir_dekstop/page/ofiice/report/sales/sales_category_screen.dart';
import 'package:kasir_dekstop/page/ofiice/report/sales/sales_gros_screen.dart';
import 'package:kasir_dekstop/page/ofiice/report/sales/sales_items_screen.dart';
import 'package:kasir_dekstop/page/ofiice/report/sales/sales_payment_screen.dart';
import 'package:kasir_dekstop/page/ofiice/report/sales/sales_sumarry_screen.dart';
import 'package:kasir_dekstop/page/ofiice/report/transaksi_screen.dart';
import 'package:kasir_dekstop/page/ofiice/setting/receipt_screen.dart';
import 'package:kasir_dekstop/page/ofiice/shift/history_shift.dart';
import 'package:kasir_dekstop/page/ofiice/shift/shift_screen.dart';

class AppRoutes {
  static GoRouter router =
      GoRouter(initialLocation: LoginScreen.routeName, routes: [
    GoRoute(
      path: LoginScreen.routeName,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RegisterScreen.routeName,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: HomeScreen.routeName,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: DashboardScreen.routeName,
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: ItemLibraryScreen.routeName,
      builder: (context, state) => const ItemLibraryScreen(),
    ),
    GoRoute(
      path: CategoryScreen.routeName,
      builder: (context, state) => const CategoryScreen(),
    ),
    GoRoute(
      path: DiscountScreen.routeName,
      builder: (context, state) => const DiscountScreen(),
    ),
    GoRoute(
      path: DaftarCustomerScreen.routeName,
      builder: (context, state) => const DaftarCustomerScreen(),
    ),
    GoRoute(
      path: PromoScreen.routeName,
      builder: (context, state) => const PromoScreen(),
    ),
    GoRoute(
      path: AddPromo.routeName,
      builder: (context, state) => const AddPromo(),
    ),
    GoRoute(
      path: SalesSumarryScreen.routeName,
      builder: (context, state) => const SalesSumarryScreen(),
    ),
    GoRoute(
      path: SalesGrosScreen.routeName,
      builder: (context, state) => const SalesGrosScreen(),
    ),
    GoRoute(
      path: SalesPaymentScreen.routeName,
      builder: (context, state) => const SalesPaymentScreen(),
    ),
    GoRoute(
      path: SalesItemsScreen.routeName,
      builder: (context, state) => const SalesItemsScreen(),
    ),
    GoRoute(
      path: SalesCategoryScreen.routeName,
      builder: (context, state) => const SalesCategoryScreen(),
    ),
    GoRoute(
      path: TransaksiScreen.routeName,
      builder: (context, state) => const TransaksiScreen(),
    ),
    GoRoute(
      path: ReceiptScreen.routeName,
      builder: (context, state) => const ReceiptScreen(),
    ),
    GoRoute(
      path: GulaScreen.routeName,
      builder: (context, state) => const GulaScreen(),
    ),
    GoRoute(
      path: HutangGulaScreen.routeName,
      builder: (context, state) => const HutangGulaScreen(),
    ),
    GoRoute(
      path: OrderScreen.routeName,
      builder: (context, state) => const OrderScreen(),
    ),
    GoRoute(
      path: SuplierScreen.routeName,
      builder: (context, state) => const SuplierScreen(),
    ),
    GoRoute(
      path: SummaryScreen.routeName,
      builder: (context, state) => const SummaryScreen(),
    ),
    GoRoute(
      path: KasbonScreen.routeName,
      builder: (context, state) => const KasbonScreen(),
    ),
    GoRoute(
      path: ShiftScreen.routeName,
      builder: (context, state) => const ShiftScreen(),
    ),
    GoRoute(
      path: HistoryShift.routeName,
      builder: (context, state) => const HistoryShift(),
    ),
    GoRoute(
      path: AdjustmentScreen.routeName,
      builder: (context, state) => const AdjustmentScreen(),
    ),
    GoRoute(
      path: FinanceScreen.routeName,
      builder: (context, state) => const FinanceScreen(),
    ),
    GoRoute(
      path: '${TransaksiSucces.routeName}/:id',
      builder: (context, state) =>
          TransaksiSucces(id: int.parse(state.pathParameters['id']!)),
    ),
  ]);
}
