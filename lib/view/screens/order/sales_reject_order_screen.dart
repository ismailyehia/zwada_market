import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/data/model/response/response_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/order/widget/reject_details_view.dart';
import 'package:provider/provider.dart';

class SalesRejectOrderScreen extends StatefulWidget {
  final OrderModel? orderModel;
  final int? orderId;
  final String? phoneNumber;
  const SalesRejectOrderScreen(
      {Key? key,
      required this.orderModel,
      required this.orderId,
      this.phoneNumber})
      : super(key: key);

  @override
  State<SalesRejectOrderScreen> createState() => _SalesRejectOrderScreenState();
}

class _SalesRejectOrderScreenState extends State<SalesRejectOrderScreen> {
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
                  title: getTranslated('Reject Order', context)))
          as PreferredSizeWidget?,
      body: Consumer<OrderProvider>(
        builder: (context, order, child) {
          double itemsPrice = 0;
          double discount = 0;
          if (order.orderDetails != null &&
              order.orderDetails!.isNotEmpty &&
              (order.trackModel != null && order.trackModel?.id != -1)) {
            for (OrderDetailsModel orderDetails in order.orderDetails!) {
              itemsPrice =
                  itemsPrice + (orderDetails.price! * orderDetails.quantity!);
              discount = discount +
                  (orderDetails.discountOnProduct! * orderDetails.quantity!);
            }
          }

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
                                              child: RejectDetailsView(),
                                            ),
                                          ),
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
                                  RejectDetailsView(),
                                ]),
                              ),
                            ),
                          ],
                        )
                  : const NoDataScreen()
              : Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                );
        },
      ),
    );
  }
}
