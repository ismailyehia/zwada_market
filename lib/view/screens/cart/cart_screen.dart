import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/coupon_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_directionality.dart';
import 'package:flutter_restaurant/view/base/custom_divider.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/screens/cart/widget/cart_product_widget.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<CouponProvider>(context, listen: false).removeCouponData(false);
    Provider.of<OrderProvider>(context, listen: false).setOrderType(
      Provider.of<SplashProvider>(context, listen: false)
              .configModel!
              .homeDelivery!
          ? 'delivery'
          : 'take_away',
      notify: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context)
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(100), child: WebAppBar())
              : CustomAppBar(
                  context: context,
                  title: getTranslated('my_cart', context),
                  isBackButtonExist: !ResponsiveHelper.isMobile()))
          as PreferredSizeWidget?,
      body: Consumer<OrderProvider>(builder: (context, order, child) {
        return Consumer<CartProvider>(
          builder: (context, cart, child) {
            List<bool> availableList = [];
            double itemPrice = 0;
            double discount = 0;
            double tax = 0;
            for (var cartModel in cart.cartList) {
              availableList.add(true);

              itemPrice = itemPrice + (cartModel!.price! * cartModel.quantity!);

              discount =
                  discount + (cartModel.discountAmount! * cartModel.quantity!);

              tax = tax + (cartModel.taxAmount! * cartModel.quantity!);
            }
            double subTotal = itemPrice;
            double total = subTotal - discount;
            double totalWithoutDeliveryFee = subTotal - discount;

            double orderAmount = itemPrice;

            return cart.cartList.isNotEmpty
                ? Column(
                    children: [
                      Expanded(
                          child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(
                                Dimensions.paddingSizeSmall),
                            child: Center(
                                child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight:
                                      !ResponsiveHelper.isDesktop(context) &&
                                              height < 600
                                          ? height
                                          : height - 400),
                              child: SizedBox(
                                  width: 1170,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (ResponsiveHelper.isDesktop(context))
                                        Expanded(
                                            child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeLarge,
                                              vertical:
                                                  Dimensions.paddingSizeLarge),
                                          child: CartListWidget(
                                              cart: cart,
                                              availableList: availableList),
                                        )),
                                      if (ResponsiveHelper.isDesktop(context))
                                        const SizedBox(
                                            width: Dimensions.paddingSizeLarge),
                                      Expanded(
                                          child: Container(
                                        decoration: ResponsiveHelper.isDesktop(
                                                context)
                                            ? BoxDecoration(
                                                color: Theme.of(context)
                                                    .canvasColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(context)
                                                          .shadowColor,
                                                      blurRadius: 10,
                                                    )
                                                  ])
                                            : const BoxDecoration(),
                                        margin:
                                            ResponsiveHelper.isDesktop(context)
                                                ? const EdgeInsets.symmetric(
                                                    horizontal: Dimensions
                                                        .paddingSizeSmall,
                                                    vertical: Dimensions
                                                        .paddingSizeLarge)
                                                : const EdgeInsets.all(0),
                                        padding:
                                            ResponsiveHelper.isDesktop(context)
                                                ? const EdgeInsets.symmetric(
                                                    horizontal: Dimensions
                                                        .paddingSizeLarge,
                                                    vertical: Dimensions
                                                        .paddingSizeLarge)
                                                : const EdgeInsets.all(0),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Product
                                              if (!ResponsiveHelper.isDesktop(
                                                  context))
                                                CartListWidget(
                                                    cart: cart,
                                                    availableList:
                                                        availableList),

                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeLarge),

                                              // Order type
                                              Text(
                                                  getTranslated(
                                                      'Billing Details',
                                                      context)!,
                                                  style: rubikMedium.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeLarge)),

                                              const SizedBox(height: 10),

                                              // Total
                                              ItemView(
                                                title: getTranslated(
                                                    'items_price', context)!,
                                                subTitle:
                                                    PriceConverter.convertPrice(
                                                        itemPrice),
                                              ),
                                              const SizedBox(height: 10),

                                              ItemView(
                                                title: getTranslated(
                                                    'discount', context)!,
                                                subTitle:
                                                    '(-) ${PriceConverter.convertPrice(discount)}',
                                              ),
                                              const SizedBox(height: 10),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: Dimensions
                                                        .paddingSizeSmall),
                                                child: CustomDivider(),
                                              ),

                                              ItemView(
                                                title: getTranslated(
                                                    'subtotal', context)!,
                                                subTitle:
                                                    PriceConverter.convertPrice(
                                                        total),
                                                style: rubikMedium.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeExtraLarge,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),

                                              if (ResponsiveHelper.isDesktop(
                                                  context))
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeDefault),

                                              if (ResponsiveHelper.isDesktop(
                                                  context))
                                                CheckOutButtonView(
                                                  orderAmount: orderAmount,
                                                  totalWithoutDeliveryFee:
                                                      totalWithoutDeliveryFee,
                                                ),
                                            ]),
                                      )),
                                    ],
                                  )),
                            )),
                          ),
                          if (ResponsiveHelper.isDesktop(context))
                            const FooterView(),
                        ]),
                      )),
                      if (!ResponsiveHelper.isDesktop(context))
                        CheckOutButtonView(
                          orderAmount: orderAmount,
                          totalWithoutDeliveryFee: totalWithoutDeliveryFee,
                        ),
                    ],
                  )
                : const NoDataScreen(isCart: true);
          },
        );
      }),
    );
  }
}

class CheckOutButtonView extends StatelessWidget {
  const CheckOutButtonView({
    Key? key,
    required this.orderAmount,
    required this.totalWithoutDeliveryFee,
  }) : super(key: key);

  final double orderAmount;
  final double totalWithoutDeliveryFee;

  @override
  Widget build(BuildContext context) {
    ConfigModel configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel!;
    return ((configModel.selfPickup ?? false) ||
            (configModel.homeDelivery ?? false))
        ? Container(
            width: 1170,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: CustomButton(
                btnTxt: getTranslated('continue_checkout', context),
                onTap: () {
                  if (orderAmount <
                      Provider.of<SplashProvider>(context, listen: false)
                          .configModel!
                          .minimumOrderValue!) {
                    showCustomSnackBar(
                      // getTranslated('Minimum order amount is ${PriceConverter.convertPrice(Provider.of<SplashProvider>(context, listen: false).configModel!.minimumOrderValue)}, you have ${PriceConverter.convertPrice(orderAmount)} in your cart, please add more item.', context)
                        '${getTranslated('Minimum order amount is', context)} '
                        '${PriceConverter.convertPrice(Provider.of<SplashProvider>(context, listen: false).configModel!.minimumOrderValue)} ,'
                        '${getTranslated('you have', context)} '
                        '${PriceConverter.convertPrice(orderAmount)} '
                        '${getTranslated('in your cart, please add more item.', context)}'
                        

                        );
                  } else {
                    RouterHelper.getCheckoutRoute(
                        totalWithoutDeliveryFee,
                        'cart',
                        Provider.of<OrderProvider>(context, listen: false).orderType
                      );
                  }
                }),
          )
        : const SizedBox();
  }
}

class ItemView extends StatelessWidget {
  const ItemView({
    Key? key,
    required this.title,
    required this.subTitle,
    this.style,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title,
          style: style ??
              rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
      CustomDirectionality(
          child: Text(
        subTitle,
        style:
            style ?? rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
      )),
    ]);
  }
}

class CartListWidget extends StatelessWidget {
  final CartProvider cart;
  final List<bool> availableList;
  const CartListWidget(
      {Key? key, required this.cart, required this.availableList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: cart.cartList.length,
      itemBuilder: (context, index) {
        return CartProductWidget(
            cart: cart.cartList[index],
            cartIndex: index,
            isAvailable: availableList[index]);
      },
    );
  }
}
