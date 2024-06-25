import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/data/model/response/response_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_divider.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/cart/cart_screen.dart';
import 'package:flutter_restaurant/view/screens/home/widget/build_square.dart';
import 'package:provider/provider.dart';
import 'widget/button_view.dart';
import 'widget/details_view.dart';

class SalesOrderDetailsScreen extends StatefulWidget {
  final OrderModel? orderModel;
  final int? orderId;
  final String? phoneNumber;
  const SalesOrderDetailsScreen(
      {Key? key,
      required this.orderModel,
      required this.orderId,
      this.phoneNumber})
      : super(key: key);

  @override
  State<SalesOrderDetailsScreen> createState() =>
      _SalesOrderDetailsScreenState();
}

class _SalesOrderDetailsScreenState extends State<SalesOrderDetailsScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffold = GlobalKey();

  void _loadData(BuildContext context) async {
    final OrderProvider orderProvider =
        Provider.of<OrderProvider>(context, listen: false);

    ResponseModel? response = await orderProvider.trackOrder(
        widget.orderId.toString(),
        orderModel: null,
        fromTracking: false);
    await orderProvider.getOrderDetails(widget.orderId.toString(),
        isApiCheck: response != null && response.isSuccess);
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
                                              child: const DetailsView(),
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
                                                createdAt:
                                                    order.trackModel!.createdAt,
                                                orderId: order.trackModel!.id
                                                    .toString(),
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
                              child: SingleChildScrollView(
                                child: Column(children: [
                                  const DetailsView(),
                                  OrderAmountView(
                                    itemsPrice: itemsPrice,
                                    discount: discount,
                                    total: total,
                                    subTotal: subTotal,
                                    phoneNumber: widget.phoneNumber,
                                    createdAt: order.trackModel!.createdAt,
                                    orderId: order.trackModel!.id.toString(),
                                  ),
                                ]),
                              ),
                            ),
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
  final String? createdAt;
  final String? orderId;
  

  const OrderAmountView({
    Key? key,
    required this.itemsPrice,
    required this.discount,
    required this.total,
    required this.subTotal,
    required this.phoneNumber,
    required this.createdAt,
    this.orderId,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 15),
          child: Title(
            color: Colors.black,
            child: Text(
              getTranslated('Billing Details', context)!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 15),
          child: ItemView(
            title: getTranslated('Bill Date', context)!,
            subTitle: DateConverter.isoStringToLocalDateOnly(widget.createdAt!),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 15),
          child: ItemView(
            title: getTranslated('items_price', context)!,
            subTitle: PriceConverter.convertPrice(widget.itemsPrice),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 15),
          child: ItemView(
            title: getTranslated('discount', context)!,
            subTitle: '(-) ${PriceConverter.convertPrice(widget.discount)}',
          ),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.only(left: 15.0, right: 15),
          child: CustomDivider(),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 15.0, top: 15, bottom: 15, right: 15),
          child: ItemView(
            title: getTranslated('subtotal', context)!,
            subTitle: PriceConverter.convertPrice(widget.total),
            style: rubikMedium.copyWith(
                fontSize: Dimensions.fontSizeExtraLarge,
                color: Theme.of(context).primaryColor),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 15.0, bottom: 15, right: 15),
          child: CustomDivider(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          getTranslated('Bill Amount', context)!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Loyalty Point
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  PriceConverter.convertPrice(widget.total),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                buildSquare(
                                  icon: Icons.share_outlined,
                                  text: getTranslated('Share', context)!,
                                  color: const Color(0xFFF9BE13),
                                  onTap: () {
                                    Provider.of<OrderProvider>(Get.context!,listen: false)
                                        .shareOrderInvoice(context, widget.orderId);
                                  },
                                ),
                                const SizedBox(width: 16),
                                buildSquare(
                                  icon: Icons.picture_as_pdf,
                                  text: getTranslated('Print', context)!,
                                  color: Theme.of(context).primaryColor,
                                  onTap: () {
                                    Provider.of<OrderProvider>(Get.context!,
                                            listen: false)
                                        .getOrderInvoice(
                                            context, widget.orderId);
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (ResponsiveHelper.isDesktop(context))
          ButtonView(phoneNumber: widget.phoneNumber),
      ],
    );
  }
}



