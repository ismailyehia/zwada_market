import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/response_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/screens/order/widget/ActionIconsRow.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RejectDetailsView extends StatelessWidget {
  RejectDetailsView({Key? key}) : super(key: key);
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                                    '${(order.trackModel?.customer?.name ?? '').length > 5 ? '${(order.trackModel?.customer?.name ?? '').substring(0, 5)}...' : (order.trackModel?.customer?.name ?? '')} | ${order.trackModel!.customer!.code}',
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
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 15),
              child: Row(
                children: [
                  Text(
                    getTranslated('Write The Reason of Rejected', context)!,
                    style: rubikBold,
                  ),
                ],
              ),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: Dimensions.fontSizeSmall),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Theme.of(context).disabledColor.withOpacity(0.2),
                      width: 1),
                ),
                child: CustomTextField(
                  controller: _noteController,
                  hintText: getTranslated('Enter The reason', context),
                  maxLines: 5,
                  inputType: TextInputType.multiline,
                  inputAction: TextInputAction.newline,
                  capitalization: TextCapitalization.sentences,
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        CustomButton(
                          isBorder: false,
                          backgroundColor: Theme.of(context).primaryColor,
                          height: 45,
                          btnTxt: getTranslated('Confirm', context),
                          textStyle: const TextStyle(color: Colors.white),
                          onTap: () async {
                            String note = _noteController.text.trim();

                            if (note.isEmpty) {
                              showCustomSnackBar(
                                  getTranslated('Enter Reason', context));
                            } else {
                              await Provider.of<ProfileProvider>(
                                                    context,
                                                    listen: false)
                                                .getUserInfo(true);
                              late ResponseModel responseModel;
                              Provider.of<ProfileProvider>(Get.context!,
                                              listen: false)
                                          .userInfoModel!
                                          .userType ==
                                      'sales'
                                  ? responseModel =
                                      // ignore: use_build_context_synchronously
                                      await Provider.of<ProfileProvider>(
                                              context,
                                              listen: false)
                                          .rejectOrder(
                                              order.trackModel!.id.toString(),
                                              note)
                                  : responseModel =
                                      // ignore: use_build_context_synchronously
                                      await Provider.of<OrderProvider>(context,
                                              listen: false)
                                          .rejectOrderDelivery(
                                              order.trackModel!.id.toString(),
                                              note);

                              if (responseModel.isSuccess) {
                                RouterHelper.getSuccessPageRoute(
                                  // ignore: use_build_context_synchronously
                                  getTranslated(
                                      'Order Rejected Successfully', context),
                                  ' ',
                                );
                              } else {
                                showCustomSnackBar(responseModel.message);
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
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
