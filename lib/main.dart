import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kasir_dekstop/bloc/adjustment/adjustment_bloc.dart';
import 'package:kasir_dekstop/bloc/finance/finance_bloc.dart';
import 'package:kasir_dekstop/bloc/shift/shift_bloc.dart';
import 'package:kasir_dekstop/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'package:kasir_dekstop/bloc/bill/bill_bloc.dart';
import 'package:kasir_dekstop/bloc/cart/cart_bloc.dart';
import 'package:kasir_dekstop/bloc/gula/gula_bloc.dart';
import 'package:kasir_dekstop/bloc/user/user_bloc.dart';
import 'package:kasir_dekstop/bloc/order/order_bloc.dart';
import 'package:kasir_dekstop/bloc/promo/promo_bloc.dart';
import 'package:kasir_dekstop/service/product_helper.dart';
import 'package:kasir_dekstop/bloc/receipt/receipt_bloc.dart';
import 'package:kasir_dekstop/bloc/suplier/suplier_bloc.dart';
import 'package:kasir_dekstop/bloc/product/product_bloc.dart';
import 'package:kasir_dekstop/bloc/category/category_bloc.dart';
import 'package:kasir_dekstop/bloc/customer/customer_bloc.dart';
import 'package:kasir_dekstop/bloc/discount/discount_bloc.dart';
import 'package:kasir_dekstop/bloc/transaksi/transaksi_bloc.dart';
import 'package:kasir_dekstop/bloc/deb_watch/deb_watch_bloc.dart';
import 'package:kasir_dekstop/bloc/debt_sugar/debt_sugar_bloc.dart';
import 'package:kasir_dekstop/bloc/request_variant/request_variant_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await ProductHelper.createTables();
  await windowManager.ensureInitialized();
  await hotKeyManager.unregisterAll();
  // Use it only after calling `hiddenWindowAtLaunch`
  windowManager.waitUntilReadyToShow().then((_) async {
    // Hide window title bar
    // await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    await windowManager.setSize(const Size(1372, 730));
    await windowManager.center();
    await windowManager.show();
    await windowManager.setSkipTaskbar(false);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductBloc(),
        ),
        BlocProvider(
          create: (context) => CategoryBloc(),
        ),
        BlocProvider(
          create: (context) => DiscountBloc(),
        ),
        BlocProvider(
          create: (context) => CustomerBloc(),
        ),
        BlocProvider(
          create: (context) => PromoBloc(),
        ),
        BlocProvider(
          create: (context) => CartBloc(),
        ),
        BlocProvider(
          create: (context) => TransaksiBloc(),
        ),
        BlocProvider(
          create: (context) => ReceiptBloc(),
        ),
        BlocProvider(
          create: (context) => RequestVariantBloc(ProductHelper()),
        ),
        BlocProvider(
          create: (context) => GulaBloc(),
        ),
        BlocProvider(
          create: (context) => DebtSugarBloc(),
        ),
        BlocProvider(
          create: (context) => OrderBloc(),
        ),
        BlocProvider(
          create: (context) => SuplierBloc(),
        ),
        BlocProvider(
          create: (context) => DebWatchBloc(),
        ),
        BlocProvider(
          create: (context) => BillBloc(),
        ),
        BlocProvider(
          create: (context) => UserBloc(),
        ),
        BlocProvider(
          create: (context) => ShiftBloc(),
        ),
        BlocProvider(
          create: (context) => AdjustmentBloc(),
        ),
        BlocProvider(
          create: (context) => FinanceBloc(),
        ),
      ],
      child: MaterialApp.router(
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {PointerDeviceKind.mouse},
        ),
        debugShowCheckedModeBanner: false,
        title: 'Aplikasi Kasir',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: AppRoutes.router,
      ),
    );
  }
}
