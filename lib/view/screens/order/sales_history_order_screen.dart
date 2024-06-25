import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/not_logged_in_screen.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/order/widget/sales_history_order_view.dart';
import 'package:provider/provider.dart';

class SalesHistoryOrderScreen extends StatefulWidget {
  const SalesHistoryOrderScreen({Key? key}) : super(key: key);

  @override
  State<SalesHistoryOrderScreen> createState() =>
      _SalesHistoryOrderScreenState();
}

class _SalesHistoryOrderScreenState extends State<SalesHistoryOrderScreen>
    with TickerProviderStateMixin {
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (_isLoggedIn) {
      Provider.of<OrderProvider>(context, listen: false).getOrderList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: (ResponsiveHelper.isDesktop(context)
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(100), child: WebAppBar())
              : CustomAppBar(
                  context: context,
                  title: getTranslated('orders_history', context),
                  isBackButtonExist: !ResponsiveHelper.isMobile()))
          as PreferredSizeWidget?,
      body: _isLoggedIn
          ? Consumer<OrderProvider>(
              builder: (context, order, child) {
                return const Column(children: [
                  Expanded(
                    child: SalesHistoryOrderView(isRunning: true),
                  ),
                ]);
              },
            )
          : const NotLoggedInScreen(),
    );
  }
}
