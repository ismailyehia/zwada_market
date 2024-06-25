// import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/stock_tag_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final bool? fromList;
  const ProductWidget({Key? key, required this.product, this.fromList = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? priceAfterDiscount;
    double? price;
    bool isAvailable;

    priceAfterDiscount = ((product.discount ?? 0) < (product.price ?? 0))
        ? (product.price ?? 0) - (product.discount ?? 0)
        : (product.price ?? 0);
    price = product.price;
    isAvailable = true;

    return Consumer<CartProvider>(builder: (context, cartProvider, child) {
      String productImage =
          '${AppConstants.baseUrl}public/storage/${product.image?.replaceAll("public/", "/")}';

      return Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: InkWell(
            onTap: () {
              ResponsiveHelper.isMobile()
                  ? showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (con) => CartBottomSheet(
                        product: product,
                        callback: (CartModel cartModel) {
                          showCustomSnackBar(
                              getTranslated('added_to_cart', context),
                              isError: false);
                        },
                        moreOnTap: fromList == true
                            ? null
                            : () {
                                RouterHelper.getOnSaleListRoute(
                                    isSale: 'false',
                                    supplierId: product.supplierId.toString());
                              },
                      ),
                    )
                  : showDialog(
                      context: context,
                      builder: (con) => Dialog(
                            backgroundColor: Colors.transparent,
                            child: CartBottomSheet(
                              product: product,
                              callback: (CartModel cartModel) {
                                showCustomSnackBar(
                                    getTranslated('added_to_cart', context),
                                    isError: false);
                              },
                            ),
                          ));
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
                    StockTagView(product: product),
                  ],
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          product.name![AppLocalization.of(context)!
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
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.production_quantity_limits,
                                size: 15,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${product.information?[AppLocalization.of(context)!.getCurrentLanguageCode()] ?? ''}',
                                style: const TextStyle(fontSize: 10),
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
                                Icons.language,
                                size: 15,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 10),

                              Text(
                                    product.origin != null
                                        ? CountryListPick(
                                            initialSelection: product.origin!,
                                            theme: CountryTheme(
                                              showEnglishName: true,
                                              // isShowTitle: true,
                                            ),
                                            onChanged: (code) {
                                              // Not needed for Text widget
                                            },
                                          ).initialSelection.toString()
                                        : '',
                                    style: const TextStyle(fontSize: 10),
                                  ),
                              // Text(
                              //   product.origin != null
                              //       ? CountryCode.fromCountryCode(
                              //               product.origin!)
                              //           .name!
                              //       : '',
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
                                Icons.inventory_2_outlined,
                                size: 15,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(
                                  width:
                                      10), // Adding some space between the icon and the text
                              Text(
                                '${product.minQty ?? '1'}',
                                style: const TextStyle(fontSize: 10),
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
                                Icons.update,
                                size: 15,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(
                                  width:
                                      10), // Adding some space between the icon and the text
                              Text(
                                DateFormat('dd/MM/yyyy').format(
                                    DateTime.parse(product.expiryDate!)
                                        .add(const Duration(days: 1))),
                                style: const TextStyle(fontSize: 10),
                              ),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              PriceConverter.convertPrice(priceAfterDiscount),
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            priceAfterDiscount! != price!
                                ? Text(
                                    PriceConverter.convertPrice(price),
                                    style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: Colors.red,
                                      decorationThickness: 3.0,
                                      fontSize: 10,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : const SizedBox(),
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
