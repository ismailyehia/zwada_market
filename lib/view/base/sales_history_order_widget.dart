import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/screens/home/widget/build_square.dart';
import 'package:provider/provider.dart';

class SalesHistoryOrderWidget extends StatelessWidget {
  final OrderModel order;
  const SalesHistoryOrderWidget({Key? key, required this.order})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isAvailable;

    double? amount = order.orderAmount;
    isAvailable = true;

    return Consumer<CartProvider>(builder: (context, cartProvider, child) {
      return Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: InkWell(
            child: Container(
              height: 400,
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeExtraSmall,
                  horizontal: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[
                        Provider.of<ThemeProvider>(context).darkTheme
                            ? 900
                            : 300]!,
                    blurRadius:
                        Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                    spreadRadius:
                        Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
                  )
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Text on the left
                        RichText(
                          text: TextSpan(
                            text: getTranslated('order_id', context)!,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black),
                            children: [
                              TextSpan(
                                text: '#${order.id.toString()}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),

                        // Text on the right
                        Text(
                          getTranslated('amount', context)!,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                      height: 10.0, // Adjust the height as needed
                    ),
                  ),
                  Row(
                    children: [
                      if (!isAvailable)
                        Positioned(
                          top: 0,
                          left: 0,
                          bottom: 0,
                          right: 0,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black.withOpacity(0.6),
                            ),
                            child: Text(
                              getTranslated(
                                  'not_available_now_break', context)!,
                              textAlign: TextAlign.center,
                              style: rubikRegular.copyWith(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 10),
                                  RichText(
                                    text: TextSpan(
                                      text:
                                          '${getTranslated('status', context)!} ',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors
                                              .black), // Change color as needed
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: getTranslated(
                                              order.orderStatus, context)!,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(
                                                  0xFFF9BE13)), // Change color as needed
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 10),
                                RichText(
                                  text: TextSpan(
                                    text:
                                        '${getTranslated('Delivery Name :', context)!} ',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors
                                            .black), // Change color as needed
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: order.deliveryMan != null
                                            ? '${order.deliveryMan!.fName!} ${order.deliveryMan!.lName!}'
                                            : '', // Change color as needed
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 10),
                                Text(
                                  '${order.customer!.name!} | ${order.customer!.code!}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 10),
                                RichText(
                                  text: TextSpan(
                                    text:
                                        '${getTranslated('Order at', context)!} ',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors
                                            .black), // Change color as needed
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: DateConverter
                                            .isoStringToLocalDateOnly(
                                                order.createdAt!),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$amount LYD',
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFFF9BE13),
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: SizedBox(
                                width: double
                                    .infinity, // Ensure the container takes the full width of its parent
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      buildSquare(
                                        icon: Icons.share_outlined,
                                        text: getTranslated('Share', context)!,
                                        color: const Color(0xFFF9BE13),
                                        onTap: () {
                                          Provider.of<OrderProvider>(
                                                  Get.context!,
                                                  listen: false)
                                              .shareOrderInvoice(
                                                  context, order.id.toString());
                                        },
                                      ),
                                      const SizedBox(width: 16),
                                      buildSquare(
                                        icon: Icons.picture_as_pdf,
                                        text: getTranslated('Print', context)!,
                                        color: Theme.of(context).primaryColor,
                                        onTap: () {
                                          Provider.of<OrderProvider>(
                                                  Get.context!,
                                                  listen: false)
                                              .getOrderInvoice(
                                                  context, order.id.toString());
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));
    });
  }
}
