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
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/title_widget.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

// SupplierIdProvider class

class FeatureView extends StatelessWidget {
  const FeatureView({Key? key, this.cart}) : super(key: key);
  final CartModel? cart;

  @override
  Widget build(BuildContext context) {
    

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: TitleWidget(title: getTranslated('Feature Products', context)),
        ),
        SizedBox(
          height: 325,
          child: Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              double? priceAfterDiscount;
              double? price;
              return productProvider.featureProductList != null
                  ? productProvider.featureProductList!.isNotEmpty
                      ? ListView.builder(
                          itemCount: productProvider.featureProductList!.length,
                          padding: const EdgeInsets.only(
                              left: Dimensions.paddingSizeSmall,
                              bottom: Dimensions.paddingSizeSmall,
                              top: Dimensions.paddingSizeSmall),
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            Product product = productProvider.featureProductList![index];
                            // Filter products by supplier ID
                          // var supplierId;
                          //   if (product.supplierId != supplierId) {
                          //     print(' supplier id =  ${product.supplierId}');
                          //     return Container();
                          //   }

                            // Your existing UI code for rendering the product item
                            priceAfterDiscount = ((product.discount ?? 0) <
                                    (product.price ?? 0))
                                ? (product.price ?? 0) - (product.discount ?? 0)
                                : (product.price ?? 0);
                            price = product.price;
                            return Consumer<CartProvider>(
                                builder: (context, cartProvider, child) {
                              return InkWell(
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
                                                  getTranslated(
                                                      'added_to_cart', context),
                                                  isError: false);
                                            },
                                            moreOnTap: () {
                                              RouterHelper.getOnSaleListRoute(
                                                  isSale: 'false',
                                                  supplierId: product.supplierId
                                                      .toString());
                                            },
                                          ),
                                        )
                                      : showDialog(
                                          context: context,
                                          builder: (con) => Dialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: CartBottomSheet(
                                                  product: product,
                                                  callback:
                                                      (CartModel cartModel) {
                                                    showCustomSnackBar(
                                                        getTranslated(
                                                            'added_to_cart',
                                                            context),
                                                        isError: false);
                                                  },
                                                ),
                                              ));
                                },
                                child: Container(
                                  height: 50,
                                  margin: const EdgeInsets.only(
                                      right: Dimensions.paddingSizeSmall),
                                  decoration: BoxDecoration(
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
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(10.0),
                                            topLeft: Radius.circular(10.0)),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: Images.placeholderImage,
                                          width: 215.4,
                                          height: 150,
                                          fit: BoxFit.cover,
                                          image:
                                              '${AppConstants.baseUrl}public/storage/${product.image?.replaceAll("public/", "/")}',
                                          imageErrorBuilder: (c, o, s) =>
                                              Image.asset(
                                                  Images.placeholderImage,
                                                  width: 215.4,
                                                  height: 150,
                                                  fit: BoxFit.cover),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '${product.name![AppLocalization.of(context)!.getCurrentLanguageCode()] ?? ''}',
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.production_quantity_limits,
                                              size: 15,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            const SizedBox(
                                                width:
                                                    10), // Adding some space between the icon and the text
                                            Text(
                                              '${product.information![AppLocalization.of(context)!.getCurrentLanguageCode()] ?? ''}',
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
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

                                            // Adding some space between the icon and the text
                                            // Text(
                                            //   product.origin != null
                                            //       ? CountryCode.fromCountryCode(
                                            //               product.origin!)
                                            //           .name!
                                            //       : '',
                                            //   style:
                                            //       const TextStyle(fontSize: 10),
                                            // ),

                                            Text(
                                              product.origin != null
                                                  ? CountryListPick(
                                                      initialSelection:
                                                          product.origin!,
                                                      theme: CountryTheme(
                                                        showEnglishName: true,
                                                        // isShowTitle: true,
                                                      ),
                                                      onChanged: (code) {
                                                        // Not needed for Text widget
                                                      },
                                                    )
                                                      .initialSelection
                                                      .toString()
                                                  : '',
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
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
                                              '${product.minQty}',
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
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
                                                  DateTime.parse(
                                                          product.expiryDate!)
                                                      .add(const Duration(
                                                          days: 1))),
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, top: 8.0, bottom: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                priceAfterDiscount! != price!
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
                                            const SizedBox(
                                                width:
                                                    95), // Adding some space between the text and the icon
                                            const Icon(
                                              Icons.add,
                                              size: 25,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                          },
                        )
                      : Center(
                          child: Text(
                              getTranslated('no_product_available', context)!))
                  : const BannerShimmer();
            },
          ),
        ),
      ],
    );
  }
}

class BannerShimmer extends StatelessWidget {
  const BannerShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Shimmer(
          duration: const Duration(seconds: 2),
          enabled:
              Provider.of<ProductProvider>(context).featureProductList == null,
          child: Container(
            width: 100,
            height: 200,
            margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
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
              color: Theme.of(context).shadowColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }
}
