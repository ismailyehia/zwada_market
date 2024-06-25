import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/gift_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/screens/home/widget/gift_bottom_sheet.dart';
import 'package:provider/provider.dart';

class GiftWidget extends StatelessWidget {
  final GiftModel gift;
  final bool? fromList;
  const GiftWidget({Key? key, required this.gift, this.fromList = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? price;
    bool isAvailable;

    price = gift.pointPrice;
    isAvailable = true;

    return Consumer<CartProvider>(builder: (context, cartProvider, child) {
      String productImage =
          '${AppConstants.baseUrl}public/storage/${gift.image?.replaceAll("public/", "/")}';

      return Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: InkWell(
            onTap: () {
              ResponsiveHelper.isMobile()
                  ? showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (con) => GiftBottomSheet(gift: gift),
                    )
                  : const SizedBox();
            },
            child: Container(
              height: 200,
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
              child: Row(children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage.assetNetwork(
                        placeholder: Images.placeholderImage,
                        height: 70,
                        width: 85,
                        fit: BoxFit.cover,
                        image: productImage,
                        imageErrorBuilder: (c, o, s) => Image.asset(
                            Images.placeholderImage,
                            height: 70,
                            width: 85,
                            fit: BoxFit.cover),
                      ),
                    ),
                    isAvailable
                        ? const SizedBox()
                        : Positioned(
                            top: 0,
                            left: 0,
                            bottom: 0,
                            right: 0,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black.withOpacity(0.6)),
                              child: Text(
                                  getTranslated(
                                      'not_available_now_break', context)!,
                                  textAlign: TextAlign.center,
                                  style: rubikRegular.copyWith(
                                    color: Colors.white,
                                    fontSize: 8,
                                  )),
                            ),
                          ),
                  ],
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          gift.name![AppLocalization.of(context)!
                                  .getCurrentLanguageCode()] ??
                              '',
                          style: rubikMedium.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$price ${getTranslated('point', context)!}',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Icon(Icons.add),
                  ],
                ),
              ]),
            ),
          ));
    });
  }
}
