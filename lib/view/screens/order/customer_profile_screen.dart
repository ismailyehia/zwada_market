import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/data/model/response/userinfo_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/order/widget/customer_details_view.dart';
import 'package:provider/provider.dart';

class CustomerProfileScreen extends StatefulWidget {
  final UserInfoModel? customerModel;
  final int? customerId;
  const CustomerProfileScreen({
    Key? key,
    required this.customerModel,
    required this.customerId,
  }) : super(key: key);

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffold = GlobalKey();

  void _loadData(BuildContext context) async {
    final ProfileProvider profileProvider = context.read<ProfileProvider>();

    await profileProvider.getCustomerInfo(
      widget.customerId.toString(),
      true
    );
  }

  @override
  void initState() {
    super.initState();

    _loadData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: (ResponsiveHelper.isDesktop(context)
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(100), child: WebAppBar())
              : CustomAppBar(
                  context: context,
                  title: getTranslated('Customer Details', context)))
          as PreferredSizeWidget?,
      body: Consumer<ProfileProvider>(
        builder: (context, profile, child) {

          return !profile.isLoading &&
                  profile.customerInfoModel != null 
              ?  const Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(children: [
                                  CustomerDetailsView(),
                                ]),
                              ),
                            ),
                          ],
                        )
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

  const OrderAmountView({
    Key? key,
    required this.itemsPrice,
    required this.discount,
    required this.total,
    required this.subTotal,
    required this.phoneNumber,
    required this.createdAt,
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

    return const SizedBox();
  }
}
