import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasir_dekstop/page/ofiice/report/sales/sales_category_screen.dart';
import 'package:kasir_dekstop/page/ofiice/report/sales/sales_gros_screen.dart';
import 'package:kasir_dekstop/page/ofiice/report/sales/sales_items_screen.dart';
import 'package:kasir_dekstop/page/ofiice/report/sales/sales_payment_screen.dart';
import 'package:kasir_dekstop/page/ofiice/report/sales/sales_sumarry_screen.dart';

class SidebarSales extends StatefulWidget {
  final String type;
  const SidebarSales({super.key, required this.type});

  @override
  State<SidebarSales> createState() => _SidebarSalesState();
}

class _SidebarSalesState extends State<SidebarSales> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> side = [
      {
        "title": "Sales Summary",
        "selected": (widget.type == 'summary') ? true : false,
        "route": SalesSumarryScreen.routeName
      },
      {
        "title": "Gros Profit",
        "selected": (widget.type == 'gros') ? true : false,
        "route": SalesGrosScreen.routeName
      },
      {
        "title": "Payment Methods",
        "selected": (widget.type == 'payment') ? true : false,
        "route": SalesPaymentScreen.routeName
      },
      {
        "title": "Item Sales",
        "selected": (widget.type == 'items') ? true : false,
        "route": SalesItemsScreen.routeName
      },
      {
        "title": "Category Sales",
        "selected": (widget.type == 'category') ? true : false,
        "route": SalesCategoryScreen.routeName
      },
    ];
    return Column(
      children: [
        for (var i = 0; i < side.length; i++)
          Card(
            child: ListTile(
              onTap: () {
                context.go(side[i]['route']);
              },
              title: Text(side[i]['title'],
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      color:
                          (side[i]['selected']) ? Colors.white : Colors.black)),
              selectedTileColor: const Color(0XFF2334A6),
              selected: side[i]['selected'],
            ),
          ),
      ],
    );
  }
}
