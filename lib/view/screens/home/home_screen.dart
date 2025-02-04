import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/product_type.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/banner_provider.dart';
import 'package:flutter_restaurant/provider/brand_provider.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/title_widget.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/category_web_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/banner_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/category_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/feature_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/main_slider.dart'
    as slider;
import 'package:flutter_restaurant/view/screens/home/widget/offer_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/product_view.dart';
import 'package:flutter_restaurant/view/screens/menu/widget/options_view.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final bool fromAppBar;
  const HomeScreen(this.fromAppBar, {Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  static Future<void> loadData(bool reload, {bool isFcmUpdate = false}) async {
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(Get.context!, listen: false);
    final OrderProvider orderProvider =
        Provider.of<OrderProvider>(Get.context!, listen: false);
    final CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(Get.context!, listen: false);
    final BrandProvider brandProvider =
        Provider.of<BrandProvider>(Get.context!, listen: false);
    final BannerProvider bannerProvider =
        Provider.of<BannerProvider>(Get.context!, listen: false);
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(Get.context!, listen: false);
    final isLogin =
        Provider.of<AuthProvider>(Get.context!, listen: false).isLoggedIn();

    if (isLogin) {
      profileProvider.getUserInfo(reload, isUpdate: false);
      if (isFcmUpdate) {
        Provider.of<AuthProvider>(Get.context!, listen: false).updateToken();
      }
    } else {
      profileProvider.setUserInfoModel = null;
    }
    if (isLogin) {
      await bannerProvider.getBannerList(reload);
      await productProvider.getFeatureProductList(reload);
      await productProvider.getOnSaleProductList(reload, '1', '4');
      await productProvider.getOfferProductList(reload, '1', '10');
      await orderProvider.getOrderList();
      await categoryProvider.getCategoryList(reload);
      await brandProvider.getBrandsList(reload);
    }
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> drawerGlobalKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // final locationProvider = Provider.of<LocationProvider>(context, listen: false);

    // locationProvider.checkPermission(()=>
    //     locationProvider.getCurrentLocation(context, false).then((currentPosition) {
    //     }), context,
    // );

    // Provider.of<ProductProvider>(context, listen: false).seeMoreReturn();
    // Provider.of<ProductProvider>(context, listen: false).getLatestProductList(true, '1');
    super.initState();
  }

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
            await loadData(true);
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
                                    Text(
                                        getTranslated('Current User', context)!,
                                        style: rubikMedium.copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color)),
                                    GestureDetector(
                                      onTap: () =>
                                          RouterHelper.getAddressRoute(),
                                      child: Text(
                                        '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.fName : ''} ${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.lName : ''}',
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
                              // Expanded(
                              //   child: GestureDetector(
                              //     onTap: () {
                              //       RouterHelper.getSearchRoute(); // Assuming this method navigates to the search page
                              //     },
                              //     child: Align(
                              //       alignment: Alignment.centerRight,
                              //       child: Icon(
                              //         Icons.tune,
                              //         size: 20,
                              //         color: Theme.of(context).primaryColor,
                              //       ),
                              //     ),
                              //   ),
                              // ),
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

        // Search Button
        if (!ResponsiveHelper.isDesktop(context))
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverDelegate(
                child: Center(
              child: InkWell(
                onTap: () => RouterHelper.getSearchRoute(),
                child: Container(
                  height: 60,
                  width: 1170,
                  color: Theme.of(context).cardColor,
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeSmall, vertical: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: ColorResources.getSearchBg(context),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(children: [
                      const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeSmall),
                          child: Icon(Icons.search, size: 25)),
                      Expanded(
                          child: Text(
                              getTranslated('Search Any Product', context)!,
                              style: rubikRegular.copyWith(fontSize: 12))),
                    ]),
                  ),
                ),
              ),
            )),
          ),

        SliverToBoxAdapter(
          child: Center(
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
                            : const BannerView(),
                        ResponsiveHelper.isDesktop(context)
                            ? const SizedBox()
                            : const FeatureView(),
                        ResponsiveHelper.isDesktop(context)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                    child: Text(
                                        getTranslated(
                                            'Feature Products', context)!,
                                        style: rubikRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeOverLarge)),
                                  ),
                                ],
                              )
                            : ResponsiveHelper.isDesktop(context)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 20, 0, 20),
                                        child: Text(
                                            getTranslated('On Sale', context)!,
                                            style: rubikRegular.copyWith(
                                                fontSize: Dimensions
                                                    .fontSizeOverLarge)),
                                      ),
                                    ],
                                  )
                                : Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 20, 10, 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TitleWidget(
                                            title: getTranslated(
                                                'On Sale', context)),
                                        InkWell(
                                          onTap: () =>
                                              RouterHelper.getOnSaleListRoute(
                                                  isSale: 'true'),
                                          child: Text(
                                            getTranslated('View All', context)!,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                        ProductView(
                            productType: ProductType.onSaleProduct,
                            scrollController: scrollController),
                        ResponsiveHelper.isDesktop(context)
                            ? const SizedBox()
                            : const OfferView(),
                        ResponsiveHelper.isDesktop(context)
                            ? const CategoryViewWeb()
                            : const CategoryView(),
                      ]),
                ),
                if (ResponsiveHelper.isDesktop(context)) const FooterView(),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  loadData(bool reload, {bool isFcmUpdate = false}) async {
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(Get.context!, listen: false);
    final OrderProvider orderProvider =
        Provider.of<OrderProvider>(Get.context!, listen: false);
    final CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(Get.context!, listen: false);
    final BrandProvider brandProvider =
        Provider.of<BrandProvider>(Get.context!, listen: false);
    final BannerProvider bannerProvider =
        Provider.of<BannerProvider>(Get.context!, listen: false);
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(Get.context!, listen: false);
    final isLogin =
        Provider.of<AuthProvider>(Get.context!, listen: false).isLoggedIn();

    if (isLogin) {
      profileProvider.getUserInfo(reload, isUpdate: false);
      if (isFcmUpdate) {
        Provider.of<AuthProvider>(Get.context!, listen: false).updateToken();
      }
    } else {
      profileProvider.setUserInfoModel = null;
    }
    if (isLogin) {
      await bannerProvider.getBannerList(reload);
      await productProvider.getFeatureProductList(reload);
      await productProvider.getOnSaleProductList(reload, '1', '4');
      await productProvider.getOfferProductList(reload, '1', '10');
      await orderProvider.getOrderList();
      await categoryProvider.getCategoryList(reload);
      await brandProvider.getBrandsList(reload);
    }
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
