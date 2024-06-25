import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/banner_provider.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/title_widget.dart';
import 'package:flutter_restaurant/view/screens/home/widget/special_cart_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class OfferView extends StatelessWidget {
  const OfferView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<ProductProvider>(builder: (context, product, child) {
          return product.offerProductList != null
              ? product.offerProductList!.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TitleWidget(
                              title: getTranslated('Special Offers', context)),
                          InkWell(
                            onTap: () => RouterHelper.getOfferListRoute(),
                            child: Text(
                              getTranslated('View All', context)!,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          )
                        ],
                      ))
                  : const SizedBox()
              : const SizedBox();
        }),
        Consumer<ProductProvider>(
          builder: (context, product, child) {
            return product.offerProductList != null
                ? product.offerProductList!.isNotEmpty
                    ? SizedBox(
                        height: 300,
                        child: ListView.builder(
                          itemCount: product.offerProductList!.length,
                          padding: const EdgeInsets.only(
                              left: Dimensions.paddingSizeSmall,
                              bottom: Dimensions.paddingSizeSmall),
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Consumer<CartProvider>(
                                builder: (context, cartProvider, child) {
                              return InkWell(
                                onTap: () {
                                  ResponsiveHelper.isMobile()
                                      ? showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (con) =>
                                              SpecialCartBottomSheet(
                                                  product: product
                                                      .offerProductList![index],
                                                  callback:
                                                      (CartModel cartModel) {
                                                    showCustomSnackBar(
                                                        getTranslated(
                                                            'added_to_cart',
                                                            context),
                                                        isError: false);
                                                  },
                                                  moreOnTap: () {
                                                    RouterHelper
                                                        .getOfferListRoute();
                                                  }),
                                        )
                                      : showDialog(
                                          context: context,
                                          builder: (con) => Dialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: SpecialCartBottomSheet(
                                                  product: product
                                                      .offerProductList![index],
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
                                              '${AppConstants.baseUrl}public/storage/${product.offerProductList![index].image?.replaceAll("public/", "/")}',
                                          imageErrorBuilder: (c, o, s) =>
                                              Image.asset(
                                                  Images.placeholderBanner,
                                                  width: 215.4,
                                                  height: 150,
                                                  fit: BoxFit.cover),
                                        ),
                                      ),
                                      Expanded(
                                          child: SizedBox(
                                        width: 213,
                                        height: 90,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                product.offerProductList![index]
                                                    .offerName!,
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    PriceConverter.convertPrice(
                                                        product
                                                            .offerProductList![
                                                                index]
                                                            .price!),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                      width:
                                                          8.0), // Adding some space between the text and the icon
                                                  const Icon(
                                                    Icons.add,
                                                    size: 30,
                                                    color: Colors.black,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              );
                            });
                          },
                        ))
                    : const SizedBox()
                : const SizedBox();
          },
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
          enabled: Provider.of<BannerProvider>(context).bannerList == null,
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
