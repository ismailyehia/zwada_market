import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_directionality.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/screens/home/widget/special_bottom_sheet.dart';
import 'package:provider/provider.dart';

class UserDetailsView extends StatelessWidget {
  const UserDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // CartModel? cart;
    // double? pricee;
    // pricee = cart!.product!.subProducts != null
    //     ? cart!.product!.offerPrice
    //     : cart!.product!.price;
    //           double? discount;

    //               discount = cart!.product!.subProducts != null ? 0 : cart!.product!.discount;
    //           double? priceAfterDiscount;
    //           priceAfterDiscount = ((discount ?? 0) < (pricee ?? 0))
    //     ? ((pricee ?? 0) - (discount ?? 0))
    //     : pricee;

    return Consumer<OrderProvider>(builder: (context, order, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${getTranslated('order_id', context)}:',
                    style: rubikRegular),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(order.trackModel!.id.toString(), style: rubikMedium),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                const Expanded(child: SizedBox()),
                const Icon(Icons.watch_later, size: 17),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                order.trackModel!.deliveryTime != null
                    ? Text(
                        DateConverter.deliveryDateAndTimeToDate(
                            order.trackModel!.deliveryDate!,
                            order.trackModel!.deliveryTime!,
                            context),
                        style: rubikRegular,
                      )
                    : Text(
                        DateConverter.isoStringToLocalDateOnly(
                            order.trackModel!.createdAt!),
                        style: rubikRegular,
                      ),
              ]),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Row(children: [
            Text('${getTranslated('item', context)}:', style: rubikRegular),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Text(order.orderDetails!.length.toString(),
                style: rubikMedium.copyWith(
                    color: Theme.of(context).primaryColor)),
            const Expanded(child: SizedBox()),
          ]),
          const Divider(height: 20),

          // Payment info
          Align(
            alignment: Alignment.center,
            child: Text(
              getTranslated('payment_info', context)!,
              style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
          ),
          const SizedBox(height: 10),

          Row(children: [
            Expanded(
                flex: 2,
                child: Text(getTranslated('status', context)!,
                    style: rubikRegular)),
            Expanded(
                flex: 8,
                child: Text(
                  getTranslated(order.trackModel!.paymentStatus, context)!,
                  style: rubikMedium.copyWith(
                      color: Theme.of(context).primaryColor),
                )),
          ]),
          const SizedBox(height: 5),

          Row(children: [
            Expanded(
                flex: 2,
                child: Text(getTranslated('Order Status', context)!,
                    style: rubikRegular)),
            Expanded(
                flex: 8,
                child: Row(children: [
                  Text(
                    getTranslated(order.trackModel!.orderStatus, context)!,
                    style: poppinsRegular.copyWith(
                        color: Theme.of(context).primaryColor),
                  ),
                ])),
          ]),
          order.trackModel!.orderStatus == 'failed'
              ? Row(children: [
                  Expanded(
                      flex: 2,
                      child: Text(getTranslated('reject_reason', context)!,
                          style: rubikRegular)),
                  Expanded(
                      flex: 8,
                      child: Row(children: [
                        Text(
                          getTranslated(
                              order.trackModel!.rejectReason, context)!,
                          style: poppinsRegular.copyWith(
                              color: Theme.of(context).primaryColor),
                        ),
                      ])),
                ])
              : const SizedBox(),
          const Divider(height: 40),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.orderDetails!.length,
            itemBuilder: (context, index) {
              OrderDetailsModel orderDetails = order.orderDetails![index];
              double? price = orderDetails.productDetails!.subProducts != null
                  ? orderDetails.productDetails!.offerPrice
                  : orderDetails.productDetails!.price;
              double? discount;
              discount = orderDetails.productDetails!.subProducts != null
                  ? 0
                  : orderDetails.productDetails!.discount;
                  double? priceAfterDiscount;
              priceAfterDiscount = ((discount ?? 0) < (price ?? 0))
                  ? ((price ?? 0) - (discount ?? 0))
                  : price;

              return orderDetails.productDetails != null
                  ? GestureDetector(
                      onTap: () {
                        orderDetails.productDetails!.subProducts != null &&
                                orderDetails
                                    .productDetails!.subProducts!.isNotEmpty
                            ? showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (con) => SpecialBottomSheet(
                                  product: orderDetails.productDetails,
                                  callback: (CartModel cartModel) {
                                    showCustomSnackBar(
                                        getTranslated('added_to_cart', context),
                                        isError: false);
                                  },
                                ),
                              )
                            : const SizedBox();
                      },
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FadeInImage.assetNetwork(
                                  placeholder: Images.placeholderImage,
                                  height: 70,
                                  width: 80,
                                  fit: BoxFit.cover,
                                  image:
                                      '${AppConstants.baseUrl}public/storage/${orderDetails.productDetails!.image?.replaceAll("public/", "/")}',
                                  imageErrorBuilder: (c, o, s) => Image.asset(
                                      Images.placeholderImage,
                                      height: 70,
                                      width: 80,
                                      fit: BoxFit.cover),
                                ),
                              ),
                              const SizedBox(
                                  width: Dimensions.paddingSizeSmall),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              orderDetails.productDetails!
                                                          .subProducts !=
                                                      null
                                                  ? orderDetails
                                                      .productDetails!.offerName
                                                  : orderDetails.productDetails!
                                                          .name![AppLocalization
                                                              .of(context)!
                                                          .getCurrentLanguageCode()] ??
                                                      '',
                                              style: rubikMedium.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeSmall),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(
                                              '${getTranslated('quantity', context)}:',
                                              style: rubikRegular),
                                          Text(
                                              order
                                                  .orderDetails![index].quantity
                                                  .toString(),
                                              style: rubikMedium.copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColor)),
                                        ],
                                      ),
                                      const SizedBox(
                                          height:
                                              Dimensions.paddingSizeExtraSmall),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                              child: Row(children: [
                                            CustomDirectionality(
                                                child: Text(
                                              PriceConverter.convertPrice(priceAfterDiscount),
                                              style: rubikBold,
                                            )),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: orderDetails
                                                          .discountOnProduct! >
                                                      0
                                                  ? CustomDirectionality(
                                                      child:
                                                          priceAfterDiscount !=
                                                                  price
                                                              ? Text(
                                                                  PriceConverter
                                                                      .convertPrice(
                                                                          price),
                                                                  style: rubikBold
                                                                      .copyWith(
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough,
                                                                    fontSize:
                                                                        Dimensions
                                                                            .fontSizeSmall,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .hintColor
                                                                        .withOpacity(
                                                                            0.7),
                                                                  ),
                                                                )
                                                              : const SizedBox())
                                                  : const SizedBox(),
                                            ),
                                          ])),
                                        ],
                                      ),
                                      const SizedBox(
                                          height: Dimensions.paddingSizeSmall),
                                    ]),
                              ),
                            ]),
                            const Divider(height: 40),
                          ]),
                    )
                  : const SizedBox.shrink();
            },
          ),

          (order.trackModel!.orderNote != null &&
                  order.trackModel!.orderNote!.isNotEmpty)
              ? Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  margin: const EdgeInsets.only(
                      bottom: Dimensions.paddingSizeLarge),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 1,
                        color: Theme.of(context).hintColor.withOpacity(0.7)),
                  ),
                  child: Text(order.trackModel!.orderNote!,
                      style: rubikRegular.copyWith(
                          color: Theme.of(context).hintColor.withOpacity(0.7))),
                )
              : const SizedBox(),
        ],
      );
    });
  }
}
