import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter_restaurant/data/model/response/response_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/order_status.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/stock_tag_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/special_bottom_sheet.dart';
import 'package:flutter_restaurant/view/screens/order/widget/ActionIconsRow.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AcceptDetailsView extends StatelessWidget {
  const AcceptDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController noteTextController = TextEditingController();
    return Consumer<OrderProvider>(builder: (context, order, _) {
      return Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(
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
              ],
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, // This aligns the child to the center horizontally within the Row.
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0),
                    ),
                    child: FadeInImage.assetNetwork(
                      placeholder: Images.placeholderImage,
                      width: MediaQuery.of(context).size.width - 30,
                      height: 150,
                      fit: BoxFit.cover,
                      image:
                          '${AppConstants.baseUrl}public/storage/${order.trackModel!.customer!.banner?.replaceAll("public/", "/")}',
                      imageErrorBuilder: (c, o, s) => Image.asset(
                        Images.placeholderImage,
                        width: MediaQuery.of(context).size.width - 30,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeSmall),
              child: CustomTextField(
                fillColor: Theme.of(context).cardColor,
                isShowBorder: true,
                controller: noteTextController,
                hintText: getTranslated('enter_note', context),
                maxLines: 5,
                inputType: TextInputType.multiline,
                inputAction: TextInputAction.newline,
                capitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  String note = noteTextController.text.trim();
                  Provider.of<OrderProvider>(context, listen: false)
                      .setOrderNote(order.trackModel!.id.toString(), note);
                },
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Column(
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
                            getTranslated('Customer', context)!,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: FadeInImage.assetNetwork(
                                  placeholder: Images.placeholderImage,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  image:
                                      '${AppConstants.baseUrl}public/storage/${order.trackModel!.customer!.image?.replaceAll("public/", "/")}',
                                  imageErrorBuilder: (c, o, s) => Image.asset(
                                    Images.placeholderImage,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Loyalty Point
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.store_outlined,
                                    size: 15,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(
                                      width:
                                          10), // Adding some space between the icon and the text
                                  Text(
                                    '${(order.trackModel?.customer?.name ?? '').length > 5 ? '${(order.trackModel?.customer?.name ?? '').substring(0, 11)}...' : (order.trackModel?.customer?.name ?? '')} | ${order.trackModel!.customer!.code}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.fmd_good_outlined,
                                    size: 15,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(
                                      width:
                                          10), // Adding some space between the icon and the text
                                  Text(
                                    order.trackModel!.customer!.zoneName!,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          Expanded(
                            child: ActionIconsRow(
                              gmLink: order.trackModel!.customer!.gmLink!,
                              wpNumber: order.trackModel!.customer!.wpNumber!,
                              phoneNumber: order.trackModel!.customer!.phone!,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                CustomButton(
                                  isBorder: false,
                                  backgroundColor: const Color(0xFFf9be13),
                                  height: 45,
                                  btnTxt:
                                      getTranslated('Select Delivery', context),
                                  textStyle:
                                      const TextStyle(color: Colors.white),
                                  onTap: () {
                                    _showOptionsModal(context,
                                        order.trackModel!.id.toString());
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getTranslated('Order Details', context)!,
                    style: rubikBold,
                  ),
                  Row(
                    children: [
                      Text(
                        getTranslated('status', context)!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        getTranslated(' : ', context)!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        getTranslated(order.trackModel!.orderStatus!, context)!,
                        style: TextStyle(
                            color: order.trackModel!.orderStatus! ==
                                        OrderStatus.canceled ||
                                    order.trackModel!.orderStatus! ==
                                        OrderStatus.failed ||
                                    order.trackModel!.orderStatus! ==
                                        OrderStatus.returned ||
                                    order.trackModel!.orderStatus! ==
                                        OrderStatus.deliveryRejected
                                ? const Color(0xFFdc4040)
                                : order.trackModel!.orderStatus! ==
                                            OrderStatus.confirmed ||
                                        order.trackModel!.orderStatus! ==
                                            OrderStatus.outForDelivery ||
                                        order.trackModel!.orderStatus! ==
                                            OrderStatus.delivered
                                    ? const Color(0xFF43d97a)
                                    : const Color(0xFFF9BE13),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.orderDetails!.length,
              itemBuilder: (context, index) {
                OrderDetailsModel orderDetails = order.orderDetails![index];

                double? price = orderDetails.productDetails!.subProducts != null
                    ? orderDetails.productDetails!.offerPrice
                    : orderDetails.productDetails!.price;

                double priceAfterDiscount =
                    price! - order.orderDetails![index].discountOnProduct!;
                return orderDetails.productDetails != null
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: GestureDetector(
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
                                            getTranslated(
                                                'added_to_cart', context),
                                            isError: false);
                                      },
                                    ),
                                  )
                                : const SizedBox();
                          },
                          child: Container(
                            height: 125,
                            padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeExtraSmall,
                                horizontal: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[
                                      Provider.of<ThemeProvider>(context)
                                              .darkTheme
                                          ? 900
                                          : 300]!,
                                  blurRadius:
                                      Provider.of<ThemeProvider>(context)
                                              .darkTheme
                                          ? 2
                                          : 5,
                                  spreadRadius:
                                      Provider.of<ThemeProvider>(context)
                                              .darkTheme
                                          ? 0
                                          : 1,
                                )
                              ],
                            ),
                            child: Stack(
                              children: [
                                orderDetails.productDetails!.subProducts != null
                                    ? Positioned(
                                        top: 0,
                                        right: 0,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10)),
                                          child: Container(
                                            color: const Color(0xFFF9BE13),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                getTranslated(
                                                    'Special', context)!,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                Row(children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: Images.placeholderImage,
                                          height: 70,
                                          width: 85,
                                          fit: BoxFit.cover,
                                          image:
                                              '${AppConstants.baseUrl}public/storage/${orderDetails.productDetails!.image?.replaceAll("public/", "/")}',
                                          imageErrorBuilder: (c, o, s) =>
                                              Image.asset(
                                                  Images.placeholderImage,
                                                  height: 70,
                                                  width: 85,
                                                  fit: BoxFit.cover),
                                        ),
                                      ),
                                      orderDetails.productDetails!.isActive == 1
                                          ? const SizedBox()
                                          : Positioned(
                                              top: 0,
                                              left: 0,
                                              bottom: 0,
                                              right: 0,
                                              child: Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.black
                                                        .withOpacity(0.6)),
                                                child: Text(
                                                    getTranslated(
                                                        'not_available_now_break',
                                                        context)!,
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        rubikRegular.copyWith(
                                                      color: Colors.white,
                                                      fontSize: 8,
                                                    )),
                                              ),
                                            ),
                                      StockTagView(
                                          product:
                                              orderDetails.productDetails!),
                                    ],
                                  ),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeSmall),
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
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
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons
                                                      .production_quantity_limits,
                                                  size: 15,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  '${orderDetails.productDetails!.information![AppLocalization.of(context)!.getCurrentLanguageCode()] ?? ''}',
                                                  style: const TextStyle(
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.language,
                                                  size: 15,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  order
                                                              .orderDetails![
                                                                  index]
                                                              .productDetails!
                                                              .origin !=
                                                          null
                                                      ? CountryCode.fromCountryCode(
                                                              order
                                                                  .orderDetails![
                                                                      index]
                                                                  .productDetails!
                                                                  .origin!)
                                                          .name!
                                                      : '',
                                                  style: const TextStyle(
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.inventory_2_outlined,
                                                  size: 15,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                const SizedBox(
                                                    width:
                                                        10), // Adding some space between the icon and the text
                                                Text(
                                                  '${orderDetails.productDetails!.minQty ?? '1'}',
                                                  style: const TextStyle(
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.update,
                                                  size: 15,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                const SizedBox(
                                                    width:
                                                        10), // Adding some space between the icon and the text
                                                Text(
                                                  DateFormat('dd/MM/yyyy').format(
                                                      DateTime.parse(order
                                                              .orderDetails![
                                                                  index]
                                                              .productDetails!
                                                              .expiryDate!)
                                                          .add(const Duration(
                                                              days: 1))),
                                                  style: const TextStyle(
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  PriceConverter.convertPrice(
                                                      priceAfterDiscount),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                priceAfterDiscount != price
                                                    ? Text(
                                                        PriceConverter
                                                            .convertPrice(
                                                                price),
                                                        style: const TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          decorationColor:
                                                              Colors.red,
                                                          decorationThickness:
                                                              3.0,
                                                          fontSize: 10,
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            ),
                                          ),
                                        ]),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${orderDetails.quantity!}x',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        ),
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
                            color:
                                Theme.of(context).hintColor.withOpacity(0.7))),
                  )
                : const SizedBox(),
          ],
        ),
      );
    });
  }
}

void makePhoneCall(String phoneNumber) async {
  String url = 'tel:$phoneNumber';

  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    // Handle error, e.g., display an error message.
  }
}

void _showOptionsModal(BuildContext context, String orderId) async {
  ProfileProvider profileProvider =
      Provider.of<ProfileProvider>(context, listen: false);

  // Make sure to wait for the data to be fetched before proceeding
  await profileProvider.getDeliveryMenList();

  // ignore: use_build_context_synchronously
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      List<Map<String, dynamic>>? deliveryMen = profileProvider.dileveryMen;

      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: deliveryMen?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              final option = deliveryMen![index];

              return ListTile(
                title: Text(option['name']),
                onTap: () async {
                  ResponseModel responseModel =
                      await Provider.of<ProfileProvider>(context, listen: false)
                          .setDeliveryMan(orderId, option['id'].toString());

                  if (responseModel.isSuccess) {
                    RouterHelper.getSuccessPageRoute(
                      // ignore: use_build_context_synchronously
                      getTranslated('Dilevery assigned To', context),
                      option['name'].toString(),
                    );
                  } else {
                    showCustomSnackBar(responseModel.message);
                  }
                },
              );
            },
          ),
        ),
      );
    },
  );
}
