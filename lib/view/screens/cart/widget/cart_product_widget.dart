import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/coupon_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/stock_tag_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:flutter_restaurant/view/screens/home/widget/special_cart_bottom_sheet.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CartProductWidget extends StatelessWidget {
  final CartModel? cart;
  final int cartIndex;
  final bool isAvailable;
  const CartProductWidget(
      {Key? key,
      required this.cart,
      required this.cartIndex,
      required this.isAvailable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? price;
    double? discount;
    double? priceAfterDiscount;
    // String  selectedCountryDetails = cart!.product!.origin!;

    price = cart!.product!.subProducts != null
        ? cart!.product!.offerPrice
        : cart!.product!.price;
    discount = cart!.product!.subProducts != null ? 0 : cart!.product!.discount;
    priceAfterDiscount = ((discount ?? 0) < (price ?? 0))
        ? ((price ?? 0) - (discount ?? 0))
        : price;


    return InkWell(
      onTap: () {
        ResponsiveHelper.isMobile()
            ? showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (con) => cart!.product!.subProducts != null &&
                        cart!.product!.subProducts!.isNotEmpty
                    ? SpecialCartBottomSheet(
                        product: cart!.product,
                        cartIndex: cartIndex,
                        cart: cart,
                        fromCart: true,
                        callback: (CartModel cartModel) {
                          showCustomSnackBar(
                              getTranslated('updated_in_cart', context),
                              isError: false);
                        },
                      )
                    : CartBottomSheet(
                        product: cart!.product,
                        cartIndex: cartIndex,
                        cart: cart,
                        fromCart: true,
                        callback: (CartModel cartModel) {
                          showCustomSnackBar(
                              getTranslated('updated_in_cart', context),
                              isError: false);
                        },
                      ))
            : showDialog(
                context: context,
                builder: (con) => Dialog(
                      backgroundColor: Colors.transparent,
                      child: cart!.product!.subProducts != null &&
                              cart!.product!.subProducts!.isNotEmpty
                          ? SpecialCartBottomSheet(
                              product: cart!.product,
                              cartIndex: cartIndex,
                              cart: cart,
                              fromCart: true,
                              callback: (CartModel cartModel) {
                                showCustomSnackBar(
                                    getTranslated('updated_in_cart', context),
                                    isError: false);
                              },
                            )
                          : CartBottomSheet(
                              product: cart!.product,
                              cartIndex: cartIndex,
                              cart: cart,
                              fromCart: true,
                              callback: (CartModel cartModel) {
                                showCustomSnackBar(
                                    getTranslated('updated_in_cart', context),
                                    isError: false);
                              },
                            ),
                    ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(10)),
        child: Stack(children: [
          const Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            child: Icon(Icons.delete, color: Colors.white, size: 50),
          ),
          Dismissible(
            key: UniqueKey(),
            onDismissed: (DismissDirection direction) {
              Provider.of<CouponProvider>(context, listen: false)
                  .removeCouponData(true);
              Provider.of<CartProvider>(context, listen: false)
                  .removeFromCart(cartIndex);
            },
            child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeExtraSmall,
                    horizontal: Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor,
                      blurRadius: 5,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Column(children: [
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
                                '${AppConstants.baseUrl}public/storage/${cart!.product!.image?.replaceAll("public/", "/")}',
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
                        StockTagView(product: cart!.product!),
                      ],
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              cart!.product!.subProducts != null
                                  ? cart!.product!.offerName
                                  : cart!.product!.name![
                                          AppLocalization.of(context)!
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
                                  const SizedBox(
                                      width:
                                          10), // Adding some space between the icon and the text
                                  Text(
                                    '${cart!.product!.information?[AppLocalization.of(context)!.getCurrentLanguageCode()] ?? ''}',
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

                                  const SizedBox(
                                      width:
                                          10),
                                           // Adding some space between the icon and the text

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

                                  // Text(
                                  //   cart!.product!.origin != null
                                  //       ? CountryCode.fromCountryCode(cart!.product!.origin!).name!
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
                                    '${cart!.product!.minQty ?? '1'}',
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
                                        DateTime.parse(
                                                cart!.product!.expiryDate!)
                                            .add(const Duration(days: 1))),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              PriceConverter.convertPrice(priceAfterDiscount),
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            priceAfterDiscount != price
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
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFFE5F2FE),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(children: [
                            InkWell(
                              onTap: () {
                                Provider.of<CouponProvider>(context,
                                        listen: false)
                                    .removeCouponData(true);
                                if (cart!.quantity! > 1) {
                                  if (cart!.quantity! >
                                      cart!.product!.minQty!) {
                                    Provider.of<CartProvider>(context,
                                            listen: false)
                                        .setQuantity(
                                            isIncrement: false,
                                            fromProductView: false,
                                            cart: cart,
                                            productIndex: null);
                                  } else {
                                    null;
                                  }
                                } else {
                                  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .removeFromCart(cartIndex);
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeSmall,
                                    vertical: Dimensions.paddingSizeExtraSmall),
                                child: Icon(Icons.remove, size: 20),
                              ),
                            ),
                            Text(cart!.quantity.toString(),
                                style: rubikMedium.copyWith(
                                    fontSize: Dimensions.fontSizeExtraLarge)),
                            InkWell(
                              onTap: () {
                                final CartProvider cartProvider =
                                    Provider.of<CartProvider>(context,
                                        listen: false);
                                int quantity = cart != null &&
                                        cart!.product != null
                                    ? cartProvider.getCartProductQuantityCount(
                                        cart!.product!)
                                    : 0;
                                Provider.of<CouponProvider>(context,
                                        listen: false)
                                    .removeCouponData(true);
                                if (Provider.of<ProductProvider>(context,
                                            listen: false)
                                        .checkStock(cart!.product!,
                                            quantity: quantity) &&
                                    quantity < cart!.product!.maxQty!) {
                                  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .setQuantity(
                                          isIncrement: true,
                                          fromProductView: false,
                                          cart: cart,
                                          productIndex: null);
                                } else {
                                  showCustomSnackBar(
                                      getTranslated('out_of_stock', context));
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeSmall,
                                    vertical: Dimensions.paddingSizeExtraSmall),
                                child: Icon(Icons.add, size: 20),
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                    !ResponsiveHelper.isMobile()
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeSmall),
                            child: IconButton(
                              onPressed: () {
                                Provider.of<CouponProvider>(context,
                                        listen: false)
                                    .removeCouponData(true);
                                Provider.of<CartProvider>(context,
                                        listen: false)
                                    .removeFromCart(cartIndex);
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          )
                        : const SizedBox(),
                  ]),
                ])),
          ),
        ]),
      ),
    );
  }
}


