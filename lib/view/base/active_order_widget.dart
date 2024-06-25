import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ActiveOrderWidget extends StatelessWidget {
  final OrderModel order;
  const ActiveOrderWidget({Key? key, required this.order}) : super(key: key);

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
                    padding: const EdgeInsets.all(5.0),
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholderImage,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                          image: order.customer != null && order.customer!.image != null
        ? '${AppConstants.baseUrl}public/storage/${order.customer!.image!.replaceAll("public/", "/")}'
        : Images.placeholderImage,
//                           image:
// '${AppConstants.baseUrl}public/storage/${order.customer!.image!.replaceAll("public/", "/")}',
                          imageErrorBuilder: (c, o, s) => Image.asset(
                            Images.placeholderImage,
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.update,
                                  size: 15,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  order.createdAt != null
                                      ? DateFormat('dd/MM/yyyy').format(
                                          DateTime.parse(order.createdAt!))
                                      : '',
                                  style: const TextStyle(fontSize: 10),
                                ),
                                // Text(
                                //   DateFormat('dd/MM/yyyy')
                                //       .format(DateTime.parse(order.createdAt!)),
                                //   style: const TextStyle(fontSize: 10),
                                // ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.store_outlined,
                                  size: 15,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  order.customer!.name!,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.place_outlined,
                                  size: 15,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  order.customer!.zoneName!,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              PriceConverter.convertPrice(amount),
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFFF9BE13),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomButton(
                          isBorder: true,
                          backgroundColor: Colors.white,
                          height: 45,
                          width: 160,
                          btnTxt: getTranslated('View Details', context),
                          textStyle: const TextStyle(color: Colors.black),
                          onTap: () {
                            RouterHelper.getSalesOrderDetailsRoute(
                              order.id.toString(),
                            );
                          },
                        ),
                        CustomButton(
                          backgroundColor: Theme.of(context).primaryColor,
                          height: 45,
                          width: 160,
                          btnTxt: getTranslated('Customer Profile', context),
                          onTap: () {
                            RouterHelper.getCustomerProfileRoute(
                              order.customer!.id.toString(),
                            );
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ));
    });
  }
}
