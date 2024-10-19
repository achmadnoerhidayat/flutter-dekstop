import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kasir_dekstop/page/auth/login_screen.dart';
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
import 'package:kasir_dekstop/page/ofiice/promo/promo_screen.dart';
import 'package:kasir_dekstop/page/ofiice/report/sales/sales_sumarry_screen.dart';
import 'package:kasir_dekstop/page/ofiice/report/transaksi_screen.dart';
import 'package:kasir_dekstop/page/ofiice/setting/receipt_screen.dart';
import 'package:kasir_dekstop/page/ofiice/shift/history_shift.dart';
import 'package:kasir_dekstop/page/ofiice/shift/shift_screen.dart';
import 'package:kasir_dekstop/util/utils.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    SideMenuController sideMenu = SideMenuController();
    return Container(
      color: const Color(0xFF0F1837),
      width: MediaQuery.of(context).size.width * 0.2,
      height: double.infinity,
      child: SideMenu(
        controller: sideMenu,
        style: SideMenuStyle(
          selectedColor: Colors.transparent,
          displayMode: SideMenuDisplayMode.auto,
          selectedTitleTextStyle: const TextStyle(color: Colors.white),
          selectedIconColor: Colors.white,
          unselectedIconColor: Colors.white70,
          unselectedTitleTextStyle: const TextStyle(color: Colors.white70),
          showHamburger: false,
          selectedIconColorExpandable: Colors.white,
          unselectedIconColorExpandable: Colors.white,
          arrowCollapse: Colors.white,
          arrowOpen: Colors.white,
          // openSideMenuWidth: 200
        ),
        items: [
          SideMenuItem(
            onTap: (index, _) {
              context.go(DashboardScreen.routeName);
            },
            title: 'Dashboard',
            icon: const Icon(Icons.dashboard),
          ),
          SideMenuItem(
            onTap: (index, _) {
              context.go(FinanceScreen.routeName);
            },
            title: 'Finance',
            icon: const Icon(Icons.money),
          ),
          SideMenuExpansionItem(
            title: "Shift",
            icon: const Icon(Icons.refresh),
            children: [
              SideMenuItem(
                onTap: (index, _) {
                  context.go(ShiftScreen.routeName);
                },
                badgeColor: Colors.white,
                title: 'Shift Saat Ini',
              ),
              SideMenuItem(
                onTap: (index, _) {
                  context.go(HistoryShift.routeName);
                },
                title: 'History Shift',
              ),
            ],
          ),
          SideMenuExpansionItem(
            title: "Report",
            icon: const Icon(Icons.report),
            children: [
              SideMenuItem(
                onTap: (index, _) {
                  context.go(SalesSumarryScreen.routeName);
                },
                badgeColor: Colors.white,
                title: 'Sales',
              ),
              SideMenuItem(
                onTap: (index, _) {
                  context.go(TransaksiScreen.routeName);
                },
                title: 'Transaction',
              ),
              SideMenuItem(
                onTap: (index, _) {},
                title: 'Invoice',
              ),
              SideMenuItem(
                onTap: (index, _) {},
                title: 'Shift',
              ),
            ],
          ),
          SideMenuExpansionItem(
            title: "Library",
            icon: const Icon(Icons.library_books),
            children: [
              SideMenuItem(
                onTap: (index, _) {
                  context.go(ItemLibraryScreen.routeName);
                },
                title: 'Item Library',
              ),
              SideMenuItem(
                onTap: (index, _) {
                  context.go(CategoryScreen.routeName);
                },
                title: 'Category',
              ),
              SideMenuItem(
                onTap: (index, _) {
                  context.go(DiscountScreen.routeName);
                },
                title: 'Discount',
              ),
              SideMenuItem(
                onTap: (index, _) {
                  context.go(PromoScreen.routeName);
                },
                title: 'Promo',
              ),
              SideMenuItem(
                onTap: (index, _) {
                  context.go(GulaScreen.routeName);
                },
                title: 'Gula',
              ),
            ],
          ),
          SideMenuExpansionItem(
            title: "Customers",
            icon: const Icon(Icons.people),
            children: [
              SideMenuItem(
                onTap: (index, _) {
                  context.go(DaftarCustomerScreen.routeName);
                },
                title: 'List Customer',
              ),
              SideMenuItem(
                onTap: (index, _) {},
                title: 'Program Loyality',
              ),
            ],
          ),
          SideMenuExpansionItem(
            title: "Debt Monitor",
            icon: const Icon(Icons.account_balance_wallet),
            children: [
              SideMenuItem(
                onTap: (index, _) {
                  context.go(HutangGulaScreen.routeName);
                },
                title: 'Sugar Debt Monitor',
              ),
              SideMenuItem(
                onTap: (index, _) {
                  context.go(KasbonScreen.routeName);
                },
                title: 'Daily Debt Watch',
              ),
            ],
          ),
          SideMenuExpansionItem(
            title: "Inventory",
            icon: const Icon(Icons.inventory),
            children: [
              SideMenuItem(
                onTap: (index, _) {
                  context.go(SummaryScreen.routeName);
                },
                title: 'Summary',
              ),
              SideMenuItem(
                onTap: (index, _) {
                  context.go(AdjustmentScreen.routeName);
                },
                title: 'Adjustment',
              ),
              SideMenuItem(
                onTap: (index, _) {
                  context.go(SuplierScreen.routeName);
                },
                title: 'Suplier',
              ),
              SideMenuItem(
                onTap: (index, _) {
                  context.go(OrderScreen.routeName);
                },
                title: 'Purchase Order (PO)',
              ),
            ],
          ),
          SideMenuExpansionItem(
            title: "Setting",
            icon: const Icon(Icons.settings),
            children: [
              SideMenuItem(
                onTap: (index, _) {
                  context.go(DaftarCustomerScreen.routeName);
                },
                title: 'Account',
              ),
              SideMenuItem(
                onTap: (index, _) {},
                title: 'Payment Method',
              ),
              SideMenuItem(
                onTap: (index, _) {
                  context.go(ReceiptScreen.routeName);
                },
                title: 'Receipt',
              ),
              SideMenuItem(
                onTap: (index, _) {
                  Utils.shiftModel = null;
                  Utils.userModel = null;
                  context.go(LoginScreen.routeName);
                },
                title: 'Logout',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
