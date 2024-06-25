import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/branch_button_view.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/cart/cart_screen.dart';
import 'package:flutter_restaurant/view/screens/checkout/widget/confirm_button_view.dart';
import 'package:provider/provider.dart';

import 'widget/cost_summery_view.dart';

class CheckoutScreen extends StatefulWidget {
  final double? amount;
  final String? orderType;
  final List<CartModel>? cartList;
  final bool fromCart;
  const CheckoutScreen(
      {Key? key,
      required this.amount,
      required this.orderType,
      required this.fromCart,
      required this.cartList})
      : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late List<CartModel?> _cartList;
  final List<PaymentMethod> _paymentList = [];
  final List<Color> _paymentColor = [];
  Branches? currentBranch;

  @override
  void initState() {
    super.initState();
    final OrderProvider orderProvider =
        Provider.of<OrderProvider>(context, listen: false);
    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);

    if (cartProvider.cartList.isEmpty) {
      RouterHelper.getDashboardRoute('cart');
    }

    splashProvider.getOfflinePaymentMethod(true);

    orderProvider.clearPrevData();

    if (splashProvider.configModel!.cashOnDelivery!) {
      _paymentList.add(PaymentMethod(
          getWay: 'cash_on_delivery', getWayImage: Images.cashOnDelivery));
      _paymentColor.add(Colors
          .primaries[Random().nextInt(Colors.primaries.length)]
          .withOpacity(0.02));
    }

    if (splashProvider.configModel!.walletStatus!) {
      _paymentList.add(PaymentMethod(
          getWay: 'wallet_payment', getWayImage: Images.walletPayment));
      _paymentColor.add(Colors
          .primaries[Random().nextInt(Colors.primaries.length)]
          .withOpacity(0.1));
    }

    for (var method in splashProvider.configModel!.activePaymentMethodList!) {
      _paymentList.add(method);
      _paymentColor.add(Colors
          .primaries[Random().nextInt(Colors.primaries.length)]
          .withOpacity(0.1));
    }

    profileProvider.getUserInfo(false, isUpdate: false);

    _cartList = [];
    widget.fromCart
        ? _cartList
            .addAll(Provider.of<CartProvider>(context, listen: false).cartList)
        : _cartList.addAll(widget.cartList!);
  }

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);
    final configModel = splashProvider.configModel!;
    bool kmWiseCharge = configModel.deliveryManagement!.status == 1;
    bool takeAway = widget.orderType == 'take_away';

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: (ResponsiveHelper.isDesktop(context)
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(100), child: WebAppBar())
              : CustomAppBar(
                  context: context, title: getTranslated('checkout', context)))
          as PreferredSizeWidget?,
      body: Column(
        children: [
          Expanded(
              child: CustomScrollView(slivers: [
            SliverToBoxAdapter(child: Consumer<LocationProvider>(
                builder: (context, locationProvider, _) {
              return Consumer<OrderProvider>(
                  builder: (context, orderProvider, _) {
                double? deliveryCharge = 0;

                if (!takeAway && kmWiseCharge) {
                  deliveryCharge = orderProvider.distance *
                      configModel.deliveryManagement!.shippingPerKm!;
                  if (deliveryCharge <
                      configModel.deliveryManagement!.minShippingCharge!) {
                    deliveryCharge =
                        configModel.deliveryManagement!.minShippingCharge;
                  }
                } else if (!takeAway && !kmWiseCharge) {
                  deliveryCharge = configModel.deliveryCharge;
                }
                return Center(
                    child: Container(
                  margin: EdgeInsets.symmetric(
                      vertical: ResponsiveHelper.isDesktop(context)
                          ? Dimensions.paddingSizeLarge
                          : 0),
                  alignment: Alignment.topCenter,
                  width: Dimensions.webScreenWidth,
                  decoration: ResponsiveHelper.isDesktop(context)
                      ? BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .shadowColor
                                    .withOpacity(0.5),
                                blurRadius: 10,
                              )
                            ])
                      : const BoxDecoration(),
                  child: Column(children: [
                    if (ResponsiveHelper.isDesktop(context))
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeLarge),
                        child: Text(getTranslated('checkout', context)!,
                            style: rubikBold.copyWith(
                              fontSize: Dimensions.fontSizeOverLarge,
                            )),
                      ),
                    if (splashProvider.isBranchSelectDisable())
                      Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(getTranslated('branch', context)!,
                                      style: rubikMedium.copyWith(
                                          fontSize: Dimensions.fontSizeLarge,
                                          color:
                                              Theme.of(context).primaryColor)),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const BranchButtonView(isRow: true),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (ResponsiveHelper.isDesktop(context))
                            const Expanded(flex: 4, child: SizedBox())
                        ],
                      ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 6,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        height: Dimensions.paddingSizeDefault),
                                    if (!ResponsiveHelper.isDesktop(context))
                                      CostSummeryView(
                                        kmWiseCharge: kmWiseCharge,
                                        subtotal: widget.amount,
                                      ),
                                  ])),
                          if (ResponsiveHelper.isDesktop(context))
                            Expanded(
                              flex: 4,
                              child: Container(
                                padding: ResponsiveHelper.isDesktop(context)
                                    ? const EdgeInsets.symmetric(
                                        horizontal: Dimensions.paddingSizeLarge,
                                        vertical: Dimensions.paddingSizeLarge)
                                    : const EdgeInsets.all(0),
                                margin: ResponsiveHelper.isDesktop(context)
                                    ? const EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.paddingSizeDefault,
                                        vertical: Dimensions.paddingSizeSmall)
                                    : const EdgeInsets.all(0),
                                decoration: ResponsiveHelper.isDesktop(context)
                                    ? BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                            BoxShadow(
                                              color: ColorResources
                                                  .cardShadowColor
                                                  .withOpacity(0.2),
                                              blurRadius: 10,
                                            )
                                          ])
                                    : const BoxDecoration(),
                                child: Column(children: [
                                  CostSummeryView(
                                    kmWiseCharge: kmWiseCharge,
                                    subtotal: widget.amount,
                                  ),
                                  if (ResponsiveHelper.isDesktop(context))
                                    ConfirmButtonView(
                                      callBack: _callback,
                                      cartList: _cartList,
                                      kmWiseCharge: kmWiseCharge,
                                      orderAmount: widget.amount!,
                                    ),
                                ]),
                              ),
                            ),
                        ]),
                  ]),
                ));
              });
            })),
            if (ResponsiveHelper.isDesktop(context))
              const SliverFillRemaining(
                hasScrollBody: false,
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  SizedBox(height: Dimensions.paddingSizeLarge),
                  FooterView(),
                ]),
              ),
          ])),
          if (!ResponsiveHelper.isDesktop(context))
            Consumer<OrderProvider>(builder: (context, orderProvider, _) {
              double? deliveryCharge = 0;

              if (!takeAway && kmWiseCharge) {
                deliveryCharge = orderProvider.distance *
                    configModel.deliveryManagement!.shippingPerKm!;
                if (deliveryCharge <
                    configModel.deliveryManagement!.minShippingCharge!) {
                  deliveryCharge =
                      configModel.deliveryManagement!.minShippingCharge;
                }
              } else if (!takeAway && !kmWiseCharge) {
                deliveryCharge = configModel.deliveryCharge;
              }

              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        blurRadius: 10)
                  ],
                ),
                child: Column(children: [
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeLarge,
                        vertical: Dimensions.paddingSizeSmall),
                    child: ItemView(
                      title: getTranslated('total_amount', context)!,
                      subTitle: PriceConverter.convertPrice(
                          widget.amount! + deliveryCharge!),
                      style: rubikMedium.copyWith(
                          fontSize: Dimensions.fontSizeExtraLarge,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                  ConfirmButtonView(
                    callBack: _callback,
                    cartList: _cartList,
                    kmWiseCharge: kmWiseCharge,
                    orderAmount: widget.amount!,
                  ),
                ]),
              );
            }),
        ],
      ),
    );
  }

  void _callback(bool isSuccess, String message, String orderID) async {
    if (isSuccess) {
      if (widget.fromCart) {
        Provider.of<CartProvider>(context, listen: false).clearCartList();
      }
      Provider.of<OrderProvider>(context, listen: false).stopLoader();
      RouterHelper.getOrderSuccessScreen(orderID, 'success');
    } else {
      showCustomSnackBar(message);
    }
  }

  Future<Uint8List> convertAssetToUnit8List(String imagePath,
      {int width = 30}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
