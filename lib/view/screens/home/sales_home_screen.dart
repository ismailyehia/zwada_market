import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/home/widget/main_slider.dart'
    as slider;
import 'package:flutter_restaurant/view/screens/home/widget/sales_active_orders.dart';
import 'package:flutter_restaurant/view/screens/menu/widget/options_view.dart';
import 'package:provider/provider.dart';

class SalesHomeScreen extends StatefulWidget {
  final bool fromAppBar;
  const SalesHomeScreen(this.fromAppBar, {Key? key}) : super(key: key);

  @override
  State<SalesHomeScreen> createState() => _SalesHomeScreenState();

  static Future<void> loadData(bool reload, {bool isFcmUpdate = false}) async {
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(Get.context!, listen: false);
    final isLogin =
        Provider.of<AuthProvider>(Get.context!, listen: false).isLoggedIn();

    if (isLogin) {
      await profileProvider.getUserInfo(reload, isUpdate: false);
      if (isFcmUpdate) {
        Provider.of<AuthProvider>(Get.context!, listen: false).updateToken();
      }
    }
  }
}

class _SalesHomeScreenState extends State<SalesHomeScreen> {
  final GlobalKey<ScaffoldState> drawerGlobalKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  @override
  // void initState() {
  //   // TODO : LOCATİON
  //   // final locationProvider =
  //   //     Provider.of<LocationProvider>(context, listen: false);

  //   // locationProvider.checkPermission(
  //   //   () => locationProvider
  //   //       .getCurrentLocation(context, false)
  //   //       .then((currentPosition) {}),
  //   //   context,
  //   // );

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerGlobalKey,
      endDrawerEnableOpenDragGesture: false,
      drawer: ResponsiveHelper.isTab(context)
          ? const Drawer(child: OptionsView(onTap: null))
          : const SizedBox(),
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(100), child: WebAppBar())
          : null,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            Provider.of<OrderProvider>(context, listen: false)
                .changeStatus(true, notify: true);
            Provider.of<SplashProvider>(context, listen: false)
                .initConfig(context)
                .then((value) {
              if (value) {
                SalesHomeScreen.loadData(true);
              }
            });
          },
          backgroundColor: Theme.of(context).primaryColor,
          color: Colors.white,
          child: ResponsiveHelper.isDesktop(context)
              ? _scrollView(_scrollController, context)
              : Stack(
                  children: [
                    _scrollView(_scrollController, context),
                    Consumer<SplashProvider>(
                        builder: (context, splashProvider, _) {
                      return !splashProvider.isRestaurantOpenNow(context)
                          ? Positioned(
                              bottom: Dimensions.paddingSizeExtraSmall,
                              left: 0,
                              right: 0,
                              child: Consumer<OrderProvider>(
                                builder: (context, orderProvider, _) {
                                  return orderProvider.isRestaurantCloseShow
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: Dimensions
                                                  .paddingSizeExtraSmall),
                                          alignment: Alignment.center,
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.9),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: Dimensions
                                                        .paddingSizeDefault),
                                                child: Text(
                                                  '${getTranslated('restaurant_is_close_now', context)}',
                                                  style: rubikRegular.copyWith(
                                                      fontSize: 12,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () => orderProvider
                                                    .changeStatus(false,
                                                        notify: true),
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: Dimensions
                                                          .paddingSizeSmall),
                                                  child: Icon(
                                                      Icons.cancel_outlined,
                                                      color: Colors.white,
                                                      size: Dimensions
                                                          .paddingSizeLarge),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox();
                                },
                              ),
                            )
                          : const SizedBox();
                    })
                  ],
                ),
        ),
      ),
    );
  }

  Scrollbar _scrollView(
      ScrollController scrollController, BuildContext context) {
    return Scrollbar(
      controller: scrollController,
      child: CustomScrollView(controller: scrollController, slivers: [
        // AppBar
        ResponsiveHelper.isDesktop(context)
            ? const SliverToBoxAdapter(child: SizedBox())
            : SliverAppBar(
                floating: true,
                elevation: 0,
                centerTitle: false,
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).cardColor,
                pinned: ResponsiveHelper.isTab(context) ? true : false,
                leading: ResponsiveHelper.isTab(context)
                    ? IconButton(
                        onPressed: () =>
                            drawerGlobalKey.currentState!.openDrawer(),
                        icon: const Icon(Icons.menu, color: Colors.black),
                      )
                    : null,
                title: Consumer<SplashProvider>(
                    builder: (context, splash, child) =>
                        Consumer<ProfileProvider>(
                            builder: (context, profileProvider, _) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ResponsiveHelper.isWeb()
                                  ? FadeInImage.assetNetwork(
                                      placeholder: Images.placeholderRectangle,
                                      height: 40,
                                      width: 40,
                                      image: splash.baseUrls != null
                                          ? '${splash.baseUrls!.restaurantImageUrl}/${splash.configModel!.restaurantLogo}'
                                          : '',
                                      imageErrorBuilder: (c, o, s) =>
                                          Image.asset(
                                              Images.placeholderRectangle,
                                              height: 40,
                                              width: 40),
                                    )
                                  : Image.asset(Images.logo,
                                      width: 40, height: 40),
                              const SizedBox(
                                  width: Dimensions.paddingSizeSmall),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(getTranslated('Sales User', context)!,
                                        style: rubikMedium.copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color)),
                                    GestureDetector(
                                      child: Text(
                                        '${profileProvider.userInfoModel!.fName} ${profileProvider.userInfoModel!.lName}',
                                        style: robotoRegular.copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color,
                                          fontSize: Dimensions.fontSizeSmall,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ]),
                            ],
                          );
                        })),
                actions: [
                  ResponsiveHelper.isTab(context)
                      ? IconButton(
                          onPressed: () =>
                              RouterHelper.getDashboardRoute('cart'),
                          icon: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Icon(Icons.shopping_cart,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                              Positioned(
                                top: -10,
                                right: -10,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red),
                                  child: Center(
                                    child: Text(
                                      Provider.of<CartProvider>(context)
                                          .cartList
                                          .length
                                          .toString(),
                                      style: rubikMedium.copyWith(
                                          color: Colors.white, fontSize: 8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 8.0),
                  child: Text(
                    getTranslated('Active Orders', context)!,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 73, 73, 73),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 1170,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ResponsiveHelper.isDesktop(context)
                                ? const Padding(
                                    padding: EdgeInsets.only(
                                        top: Dimensions.paddingSizeDefault),
                                    child: slider.MainSlider(),
                                  )
                                : const SizedBox(),
                            ResponsiveHelper.isDesktop(context)
                                ? const SizedBox()
                                : SalesActiveOrders(),
                          ]),
                    ),
                    if (ResponsiveHelper.isDesktop(context)) const FooterView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

//ResponsiveHelper

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 60 ||
        oldDelegate.minExtent != 60 ||
        child != oldDelegate.child;
  }
}




