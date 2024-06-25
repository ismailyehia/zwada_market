import 'dart:core';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/data/model/response/response_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_divider.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/cart/cart_screen.dart';
import 'package:flutter_restaurant/view/screens/order/widget/user_details_view.dart';
import 'package:provider/provider.dart';
import 'widget/button_view.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel? orderModel;
  final int? orderId;
  final String? phoneNumber;
  const OrderDetailsScreen(
      {Key? key,
      required this.orderModel,
      required this.orderId,
      this.phoneNumber})
      : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffold = GlobalKey();

  void _loadData(BuildContext context) async {
    final OrderProvider orderProvider =
        Provider.of<OrderProvider>(context, listen: false);
    final String? userId =
        Provider.of<AuthProvider>(context, listen: false).getGuestId();

    ResponseModel? response = await orderProvider.trackOrder(
        widget.orderId.toString(),
        orderModel: null,
        fromTracking: false);

    await orderProvider.getOrderDetails(widget.orderId.toString(),
        userId: userId, isApiCheck: response != null && response.isSuccess);
  }

  @override
  void initState() {
    super.initState();

    _loadData(context);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffold,
      appBar: (ResponsiveHelper.isDesktop(context)
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(100), child: WebAppBar())
              : CustomAppBar(
                  context: context,
                  title: getTranslated('order_details', context)))
          as PreferredSizeWidget?,
      body: Consumer<OrderProvider>(
        builder: (context, order, child) {
          double itemsPrice = 0;
          double discount = 0;
          if (order.orderDetails != null &&
              order.orderDetails!.isNotEmpty &&
              (order.trackModel != null && order.trackModel?.id != -1)) {
            for (OrderDetailsModel orderDetails in order.orderDetails!) {
              double? price = orderDetails.productDetails!.subProducts != null
                  ? orderDetails.productDetails!.offerPrice
                  : orderDetails.productDetails!.price;
              itemsPrice = itemsPrice + (price! * orderDetails.quantity!);
              discount = discount +
                  (orderDetails.discountOnProduct! * orderDetails.quantity!);
            }
          }

          double subTotal = itemsPrice;

          double total = itemsPrice - discount;

          return !order.isLoading &&
                  order.orderDetails != null &&
                  order.trackModel != null
              ? order.orderDetails!.isNotEmpty
                  ? ResponsiveHelper.isDesktop(context)
                      ? SingleChildScrollView(
                          child: Column(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight:
                                      !ResponsiveHelper.isDesktop(context) &&
                                              height < 600
                                          ? height
                                          : height - 400,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: SizedBox(
                                      width: 1170,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: width > 700 ? 700 : width,
                                              padding: width > 700
                                                  ? const EdgeInsets.all(
                                                      Dimensions
                                                          .paddingSizeDefault)
                                                  : null,
                                              decoration: width > 700
                                                  ? BoxDecoration(
                                                      color: Theme.of(context)
                                                          .canvasColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                              Theme.of(context)
                                                                  .shadowColor,
                                                          blurRadius: 5,
                                                          spreadRadius: 1,
                                                        )
                                                      ],
                                                    )
                                                  : null,
                                              child: const UserDetailsView(),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: 400,
                                              padding: width > 700
                                                  ? const EdgeInsets.all(
                                                      Dimensions
                                                          .paddingSizeDefault)
                                                  : null,
                                              decoration: width > 700
                                                  ? BoxDecoration(
                                                      color: Theme.of(context)
                                                          .canvasColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                              Theme.of(context)
                                                                  .shadowColor,
                                                          blurRadius: 5,
                                                          spreadRadius: 1,
                                                        )
                                                      ],
                                                    )
                                                  : null,
                                              child: OrderAmountView(
                                                itemsPrice: itemsPrice,
                                                discount: discount,
                                                total: total,
                                                subTotal: subTotal,
                                                phoneNumber: widget.phoneNumber,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ResponsiveHelper.isDesktop(context)
                                  ? const FooterView()
                                  : const SizedBox()
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    Dimensions.paddingSizeDefault),
                                child: SingleChildScrollView(
                                  child: Column(children: [
                                    const UserDetailsView(),
                                    OrderAmountView(
                                      itemsPrice: itemsPrice,
                                      discount: discount,
                                      total: total,
                                      subTotal: subTotal,
                                      phoneNumber: widget.phoneNumber,
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                            // ButtonView(phoneNumber: widget.phoneNumber),
                          ],
                        )
                  : const NoDataScreen()
              : Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor)),
                );
        },
      ),
    );
  }
}

class OrderAmountView extends StatefulWidget {
  final double itemsPrice;
  final double subTotal;
  final double discount;
  final double total;
  final String? phoneNumber;

  const OrderAmountView({
    Key? key,
    required this.itemsPrice,
    required this.discount,
    required this.total,
    required this.subTotal,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<OrderAmountView> createState() => _OrderAmountViewState();
}

class _OrderAmountViewState extends State<OrderAmountView> {
  List<OrderPartialPayment> paymentList = [];

  @override
  void initState() {
    final OrderProvider orderProvider =
        Provider.of<OrderProvider>(context, listen: false);
    if (orderProvider.trackModel?.orderPartialPayments != null &&
        orderProvider.trackModel!.orderPartialPayments!.isNotEmpty) {
      paymentList = [];
      paymentList.addAll(orderProvider.trackModel!.orderPartialPayments!);

      if (orderProvider.trackModel!.paymentStatus == 'partial_paid') {
        paymentList.add(OrderPartialPayment(
          paidAmount: 0,
          paidWith: orderProvider.trackModel?.paymentMethod,
          dueAmount:
              orderProvider.trackModel!.orderPartialPayments!.first.dueAmount,
        ));
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final OrderProvider orderProvider =
        Provider.of<OrderProvider>(context, listen: false);

    return Column(
      children: [
        ItemView(
          title: getTranslated('items_price', context)!,
          subTitle: PriceConverter.convertPrice(widget.itemsPrice),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          child: CustomDivider(),
        ),
        ItemView(
          title: getTranslated('subtotal', context)!,
          subTitle: PriceConverter.convertPrice(widget.subTotal),
          style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
        ),
        const SizedBox(height: 10),
        ItemView(
          title: getTranslated('discount', context)!,
          subTitle: '(-) ${PriceConverter.convertPrice(widget.discount)}',
        ),
        const SizedBox(height: 10),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          child: CustomDivider(),
        ),
        ItemView(
          title: getTranslated('total_amount', context)!,
          subTitle: PriceConverter.convertPrice(widget.total),
          style: rubikMedium.copyWith(
              fontSize: Dimensions.fontSizeExtraLarge,
              color: Theme.of(context).primaryColor),
        ),
        orderProvider.trackModel != null &&
                orderProvider.trackModel!.orderPartialPayments != null &&
                orderProvider.trackModel!.orderPartialPayments!.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeSmall),
                child: DottedBorder(
                  dashPattern: const [8, 4],
                  strokeWidth: 1.1,
                  borderType: BorderType.RRect,
                  color: Theme.of(context).colorScheme.primary,
                  radius: const Radius.circular(Dimensions.radiusDefault),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.02),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeSmall, vertical: 1),
                    child: Column(
                        children: paymentList
                            .map((payment) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 1),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${getTranslated(payment.paidAmount! > 0 ? 'paid_amount' : 'due_amount', context)} (${getTranslated('${payment.paidWith}', context)})",
                                        style: rubikRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        PriceConverter.convertPrice(
                                            payment.paidAmount! > 0
                                                ? payment.paidAmount
                                                : payment.dueAmount),
                                        style: rubikRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList()),
                  ),
                ),
              )
            : const SizedBox(),
        if (ResponsiveHelper.isDesktop(context))
          ButtonView(phoneNumber: widget.phoneNumber),
      ],
    );
  }
}
