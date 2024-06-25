import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/brand_model.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class AllBrandsWidget extends StatelessWidget {
  final BrandModel brand;
  const AllBrandsWidget({Key? key, required this.brand, this.cart}) : super(key: key);
  final CartModel? cart;

  @override
  Widget build(BuildContext context) {
    bool isAvailable;
    isAvailable = true;


    return Consumer<CartProvider>(builder: (context, cartProvider, child) {
      String brandImage =
          '${Provider.of<SplashProvider>(context, listen: false).baseUrls?.productImageUrl ?? ''}/${brand.image ?? ''}';

      return Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: InkWell(
            onTap: () {
              null;
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
                        image: brandImage,
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
                          brand.name![AppLocalization.of(context)!
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
                              const Text(
                                '120g x 12 Pcs',
                                style: TextStyle(fontSize: 10),
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


                              // const Text(
                              //   'Libya',
                              //   style: TextStyle(fontSize: 10),
                              // ),

                              Text(
                                    cart!.product!.origin != null
                                        ? CountryListPick(
                                            initialSelection: cart!.product!.origin!,
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
                              const Text(
                                '120',
                                style: TextStyle(fontSize: 10),
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
                              const Text(
                                '10/09/2024',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(),
                      ]),
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [],
                        ),
                      ),
                    ),
                    Icon(Icons.add),
                  ],
                ),
              ]),
            ),
          ));
    });
  }
}
