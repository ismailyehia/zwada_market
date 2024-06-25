import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/network_info.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/view/base/third_party_chat_widget.dart';
import 'package:flutter_restaurant/view/screens/home/sales_home_screen.dart';
import 'package:flutter_restaurant/view/screens/menu/menu_screen.dart';
import 'package:flutter_restaurant/view/screens/order/sales_history_order_screen.dart';
import 'package:flutter_restaurant/view/screens/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';

class SalesDashboardScreen extends StatefulWidget {
  final int pageIndex;
  const SalesDashboardScreen({Key? key, required this.pageIndex}) : super(key: key);

  @override
  State<SalesDashboardScreen> createState() => _SalesDashboardScreenState();
}

class _SalesDashboardScreenState extends State<SalesDashboardScreen> {
  PageController? _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    final splashProvider = Provider.of<SplashProvider>(context, listen: false);

    if(splashProvider.policyModel == null) {
      Provider.of<SplashProvider>(context, listen: false).getPolicyPage();
    }
    SalesHomeScreen.loadData(false);

    Provider.of<OrderProvider>(context, listen: false).changeStatus(true);
    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      const SalesHomeScreen(true),
      const SalesHistoryOrderScreen(),
      const WishListScreen(),
      MenuScreen(role: 'sales', onTap: (int pageIndex) {
        _setPage(pageIndex);
      }),
    ];

    if(ResponsiveHelper.isMobilePhone()) {
      NetworkInfo.checkConnectivity(_scaffoldKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButton: !ResponsiveHelper.isDesktop(context) && _pageIndex == 0
            ? const ThirdPartyChatWidget() : null,
        bottomNavigationBar: !ResponsiveHelper.isDesktop(context) ? BottomNavigationBar(
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).hintColor.withOpacity(0.7),
          showUnselectedLabels: true,
          currentIndex: _pageIndex,
          type: BottomNavigationBarType.fixed,

          items: [
            _barItem(Icons.home, getTranslated('home', context), 0),
            _barItem(Icons.history, getTranslated('history', context), 1),
            _barItem(Icons.message, getTranslated('Messages', context), 2),
            _barItem(Icons.menu, getTranslated('menu', context), 3)
          ],
          onTap: (int index) {
            index == 2 ? null
            : _setPage(index);
          },
        ) : const SizedBox(),

        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _barItem(IconData icon, String? label, int index) {
    return BottomNavigationBarItem(

      icon: Stack(
        clipBehavior: Clip.none, children: [
          Icon(icon, color: index == _pageIndex ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withOpacity(0.7), size: 25),
        ],
      ),
      label: label,
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}


