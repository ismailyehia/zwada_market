import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class OrderItem extends StatelessWidget {
  final OrderModel orderItem;
  final bool isRunning;
  final OrderProvider orderProvider;
  const OrderItem(
      {Key? key,
      required this.orderProvider,
      required this.isRunning,
      required this.orderItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key('${orderItem.id}'),
      startActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 0.4,
        children: [
          Builder(
            builder: (cont) {
              return ElevatedButton(
                  onPressed: () {
                    Provider.of<OrderProvider>(Get.context!, listen: false)
                        .shareOrderInvoice(context, orderItem.id.toString());
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: const Color(0xFFF9BE13),
                    padding: const EdgeInsets.all(5),
                  ),
                  child: SizedBox(
                    width: 50,
                    height:
                        50, // Adjust the height as needed to accommodate both Icon and Text
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 25,
                        ),
                        const SizedBox(
                            height:
                                5), // Add some space between the Icon and Text
                        Text(
                          getTranslated('Share', context)!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12, // Adjust the font size as needed
                          ),
                        ),
                      ],
                    ),
                  ));
            },
          ),
          const SizedBox(width: 10),
          Builder(
            builder: (cont) {
              return ElevatedButton(
                  onPressed: () {
                    Provider.of<OrderProvider>(Get.context!, listen: false)
                        .getOrderInvoice(context, orderItem.id.toString());
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.all(5),
                  ),
                  child: SizedBox(
                    width: 50,
                    height:
                        50, // Adjust the height as needed to accommodate both Icon and Text
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.picture_as_pdf,
                          color: Colors.white,
                          size: 25,
                        ),
                        const SizedBox(
                            height:
                                5), // Add some space between the Icon and Text
                        Text(
                          getTranslated('Print', context)!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ));
            },
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 0.2,
        children: [
          Builder(
            builder: (cont) {
              return Container(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                    onPressed: () {
                      isRunning
                          ? RouterHelper.getOrderTrackingRoute(orderItem.id)
                          : null;
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      backgroundColor: const Color(0xFFF9BE13),
                      padding: const EdgeInsets.all(5),
                    ),
                    child: const SizedBox(
                      width: 63,
                      height:
                          95, // Adjust the height as needed to accommodate both Icon and Text
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 15,
                          ),
                          SizedBox(
                              height:
                                  5), // Add some space between the Icon and Text
                        ],
                      ),
                    )),
              );
            },
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          RouterHelper.getOrderDetailsRoute(orderItem.id.toString());
        },
        child: Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor,
                spreadRadius: 1,
                blurRadius: 5,
              )
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(children: [
            Row(children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      width: 135,
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeExtraLarge,
                            vertical: Dimensions.paddingSizeExtraSmall),
                        child: Text(
                          orderItem.id.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(children: [
                    Container(
                      height: 50,
                      width: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF9BE13),
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Icon(
                          orderItem.orderStatus == 'pending'
                              ? Icons.add_shopping_cart
                              : (orderItem.orderStatus == 'confirmed')
                                  ? Icons.check
                                  : (orderItem.orderStatus == 'processing')
                                      ? Icons.autorenew
                                      : (orderItem.orderStatus ==
                                              'out_for_delivery')
                                          ? Icons.delivery_dining_outlined
                                          : (orderItem.orderStatus ==
                                                  'delivered')
                                              ? Icons.done_all
                                              : (orderItem.orderStatus ==
                                                      'returned')
                                                  ? Icons.replay
                                                  : (orderItem.orderStatus ==
                                                          'failed')
                                                      ? Icons.highlight_remove
                                                      : (orderItem.orderStatus ==
                                                              'canceled')
                                                          ? Icons
                                                              .remove_circle_outline
                                                          : Icons.remove_done,
                          color: Colors.white,
                          size: 20, 
                        ),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),
                    SizedBox(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateConverter.isoStringToLocalDateOnly(orderItem.updatedAt!),
                              style: rubikRegular.copyWith(
                                color: const Color.fromARGB(255, 35, 35, 35),
                              ),
                            ),
                            Text(
                              DateConverter.isoStringToLocalTimeOnly(orderItem.updatedAt!),
                              style: rubikRegular.copyWith(
                                color: const Color.fromARGB(255, 35, 35, 35),
                                fontSize: 12,
                                
                              ),
                            ),
                          ]),
                    ),
                  ]),
                ],
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateConverter.isoStringToLocalDateOnly(
                                orderItem.updatedAt!),
                            style: rubikRegular.copyWith(
                              color: const Color.fromARGB(255, 35, 35, 35),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            PriceConverter.convertPrice(orderItem.orderAmount),
                            style: rubikRegular.copyWith(
                                color: const Color.fromARGB(255, 35, 35, 35),
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ]),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}


