import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_directionality.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/product_button.dart';
import 'package:flutter_restaurant/view/base/read_more_text.dart';
import 'package:flutter_restaurant/view/base/stock_tag_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class SpecialCartBottomSheet extends StatefulWidget {
  final Product? product;
  final bool fromSetMenu;
  final Function? callback;
  final CartModel? cart;
  final int? cartIndex;
  final bool fromCart;
  final Function? moreOnTap;

  const SpecialCartBottomSheet(
      {Key? key,
      required this.product,
      this.fromSetMenu = false,
      this.callback,
      this.cart,
      this.cartIndex,
      this.moreOnTap,
      this.fromCart = false})
      : super(key: key);

  @override
  State<SpecialCartBottomSheet> createState() => _SpecialCartBottomSheetState();
}

class _SpecialCartBottomSheetState extends State<SpecialCartBottomSheet> {
  late Timer _timer;
  Duration _difference = Duration.zero;

  @override
  void initState() {
    super.initState();

    Provider.of<ProductProvider>(context, listen: false)
        .initData(widget.product, widget.cart);

    _calculateDifference();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateDifference();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _calculateDifference() {
    // Calculate the difference
    final newDifference = DateTime.parse(widget.product!.disableAfter!)
        .difference(DateTime.now());

    if (_difference != newDifference) {
      setState(() {
        _difference = newDifference;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cartProvider, child) {
      return Stack(
        children: [
          Container(
            width: 600,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: ResponsiveHelper.isMobile()
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))
                  : const BorderRadius.all(Radius.circular(20)),
            ),
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                double? price;
                bool? isAvailable;
                double total;

                price = widget.product!.offerPrice;
                isAvailable = true;
                total = price! * (productProvider.quantity ?? 0);

                CartModel cartModel = CartModel(
                  price,
                  0,
                  0,
                  productProvider.quantity,
                  0,
                  widget.product,
                );
                cartProvider.isExistInCart(widget.product?.id, null);

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(ResponsiveHelper.isMobile()
                              ? 0
                              : Dimensions.paddingSizeExtraLarge),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _productView(
                                  context,
                                  price,
                                ),

                                const SizedBox(
                                    height: Dimensions.paddingSizeLarge),

                                // Quantity
                                ResponsiveHelper.isMobile()
                                    ? Column(
                                        children: [
                                          _quantityView(context),
                                          const SizedBox(
                                              height:
                                                  Dimensions.paddingSizeLarge),
                                        ],
                                      )
                                    : CartProductSubProducts(
                                        product: widget.product!),

                                const SizedBox(height: 0),

                                if (ResponsiveHelper.isMobile())
                                  CartProductSubProducts(
                                      product: widget.product!),

                                // Addons

                                Row(children: [
                                  Text(
                                      '${getTranslated('total_amount', context)}:',
                                      style: rubikMedium.copyWith(
                                          fontSize: Dimensions.fontSizeLarge)),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  CustomDirectionality(
                                    child: Text(
                                        PriceConverter.convertPrice(total),
                                        style: rubikBold.copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: Dimensions.fontSizeLarge,
                                        )),
                                  ),
                                  const SizedBox(
                                    width: Dimensions.paddingSizeSmall,
                                  ),
                                ]),
                                const SizedBox(
                                    height: Dimensions.paddingSizeLarge),
                                //Add to cart Button
                                // if(ResponsiveHelper.isDesktop(context)) _cartButton(isAvailable, context, cartModel, variationList),
                              ]),
                        ),
                      ),
                    ),
                    _cartButton(isAvailable, context, cartModel, []),
                  ],
                );
              },
            ),
          ),
          ResponsiveHelper.isMobile()
              ? const SizedBox()
              : Positioned(
                  right: 10,
                  top: 5,
                  child: InkWell(
                      onTap: () => context.pop(),
                      child: const Icon(Icons.close)),
                ),
        ],
      );
    });
  }

  Widget _quantityView(
    BuildContext context,
  ) {
    return Row(children: [
      Text(getTranslated('quantity', context)!,
          style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
      const Expanded(child: SizedBox()),
      _quantityButton(context),
    ]);
  }

  Widget _cartButton(bool isAvailable, BuildContext context,
      CartModel cartModel, List<Variation>? variationList) {
    return Column(children: [
      isAvailable
          ? const SizedBox()
          : Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              margin:
                  const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              child: Column(children: [
                Text(getTranslated('not_available_now', context)!,
                    style: rubikMedium.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: Dimensions.fontSizeLarge,
                    )),
                Text(
                  '${getTranslated('available_will_be', context)} ${DateConverter.convertTimeToTime(widget.product!.availableTimeStarts!, context)} '
                  '- ${DateConverter.convertTimeToTime(widget.product!.availableTimeEnds!, context)}',
                  style: rubikRegular,
                ),
              ]),
            ),
      Consumer<ProductProvider>(builder: (context, productProvider, _) {
        final CartProvider cartProvider =
            Provider.of<CartProvider>(context, listen: false);
        int quantity =
            cartProvider.getCartProductQuantityCount(widget.product!);
        return ProductButton(
            btnTxt: getTranslated(
                widget.cart != null
                    ? 'update_in_cart'
                    : quantity != 0
                        ? 'Already in cart'
                        : 'add_to_cart',
                context),
            onTap2: widget.product!.displayName != 0 ? widget.moreOnTap : null,
            backgroundColor: Theme.of(context).primaryColor,
            onTap: widget.cart == null &&
                    !productProvider.checkStock(widget.product!,
                        quantity: quantity)
                ? null
                : widget.cart == null && quantity != 0
                    ? null
                    : () {
                        if (variationList != null) {
                          for (int index = 0;
                              index < variationList.length;
                              index++) {
                            if (!variationList[index].isMultiSelect! &&
                                variationList[index].isRequired! &&
                                !productProvider.selectedVariations[index]
                                    .contains(true)) {
                              showCustomSnackBar(
                                  '${getTranslated('choose_a_variation_from', context)} ${variationList[index].name}',
                                  isToast: true,
                                  isError: true);
                              return;
                            } else if (variationList[index].isMultiSelect! &&
                                (variationList[index].isRequired! ||
                                    productProvider.selectedVariations[index]
                                        .contains(true)) &&
                                variationList[index].min! >
                                    productProvider.selectedVariationLength(
                                        productProvider.selectedVariations,
                                        index)) {
                              showCustomSnackBar(
                                  '${getTranslated('you_need_to_select_minimum', context)} ${variationList[index].min} '
                                  '${getTranslated('to_maximum', context)} ${variationList[index].max} ${getTranslated('options_from', context)} ${variationList[index].name} ${getTranslated('variation', context)}',
                                  isError: true,
                                  isToast: true);
                              return;
                            }
                          }
                        }

                        context.pop();
                        Provider.of<CartProvider>(context, listen: false)
                            .addToCart(
                                cartModel,
                                widget.cart != null
                                    ? widget.cartIndex
                                    : productProvider.cartIndex);
                      });
      }),
    ]);
  }

  Widget _productView(
    BuildContext context,
    double price,
  ) {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimeBox(getTranslated('Days', context)!,
                    '${_difference.inDays}', Theme.of(context).primaryColor),
                _buildTimeSeparator(),
                _buildTimeBox(getTranslated('Hours', context)!,
                    '${_difference.inHours % 24}', const Color(0xFFF9BE13)),
                _buildTimeSeparator(),
                _buildTimeBox(getTranslated('Mins', context)!,
                    '${_difference.inMinutes % 60}', const Color(0xFFdc4040)),
                _buildTimeSeparator(),
                _buildTimeBox(getTranslated('Sec', context)!,
                    '${_difference.inSeconds % 60}', const Color(0xFFa72020)),
              ],
            ),
            const Divider(
              height: 1, // Adjust the height of the divider
              color: Colors.grey, // Set the color of the divider
              thickness: 1, // Set the thickness of the divider
            ),
            const SizedBox(height: 10),
            Row(children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage.assetNetwork(
                      placeholder: Images.placeholderImage,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      image:
                          '${AppConstants.baseUrl}public/storage/${widget.product!.image?.replaceAll("public/", "/")}',
                      imageErrorBuilder: (c, o, s) => Image.asset(
                          Images.placeholderImage,
                          height: 70,
                          width: 85,
                          fit: BoxFit.cover),
                    ),
                  ),
                  StockTagView(product: widget.product!),
                ],
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.product!.offerName ?? '',
                        style: rubikMedium.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        PriceConverter.convertPrice(
                            widget.product!.offerPrice!),
                        style: rubikMedium.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ]),
              ),
              SizedBox(
                height: 100,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Container(
                          height: 40,
                          color: const Color(
                              0xFFF9BE13), // Set the background color to yellow
                          padding: const EdgeInsets.all(
                              8.0), // Add padding for better visual appearance
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                getTranslated('Special', context)!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]),
          ],
        ));
  }

  Widget _buildTimeBox(String label, String value, Color thecolor) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4.0),
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: thecolor,
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                value,
                style: const TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTimeSeparator() {
    return Container(
      margin: const EdgeInsets.fromLTRB(9.5, 14.0, 9.0, 0),
      child: const Text(
        ":",
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _quantityButton(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFE5F2FE),
          borderRadius: BorderRadius.circular(5)),
      child: Row(children: [
        InkWell(
          onTap: () => productProvider.quantity! > 1
              ? productProvider.setQuantity(false)
              : null,
          child: const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall,
                vertical: Dimensions.paddingSizeExtraSmall),
            child: Icon(Icons.remove, size: 20),
          ),
        ),
        Text(productProvider.quantity.toString(),
            style:
                rubikMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
        InkWell(
          onTap: () {
            final CartProvider cartProvider =
                Provider.of<CartProvider>(context, listen: false);
            int quantity =
                cartProvider.getCartProductQuantityCount(widget.product!);
            if (productProvider.checkStock(
              widget.cart != null ? widget.cart!.product! : widget.product!,
              quantity: (productProvider.quantity ?? 0) + quantity,
            )) {
              productProvider.setQuantity(true);
            } else {
              showCustomSnackBar(getTranslated('out_of_stock', context));
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
    );
  }
}

class CartProductDescription extends StatelessWidget {
  const CartProductDescription({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return product.description != null && product.description!.isNotEmpty
        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(getTranslated('description', context)!,
                style:
                    rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            Align(
              alignment: Alignment.topLeft,
              child: ReadMoreText(
                product.description!['en'] ?? '',
                trimLines: 2,
                trimCollapsedText: getTranslated('show_more', context),
                trimExpandedText: getTranslated('show_less', context),
                moreStyle: robotoRegular.copyWith(
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                  fontSize: Dimensions.fontSizeExtraSmall,
                ),
                lessStyle: robotoRegular.copyWith(
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                  fontSize: Dimensions.fontSizeExtraSmall,
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
          ])
        : const SizedBox();
  }
}

class CartProductSubProducts extends StatelessWidget {
  const CartProductSubProducts({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;
  final bool isAvailable = true;

  @override
  Widget build(BuildContext context) {
    return product.subProducts != null && product.subProducts!.isNotEmpty
        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(getTranslated('Offer Conditions', context)!,
                style:
                    rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: product.subProducts!.length,
                padding: const EdgeInsets.only(
                    left: Dimensions.paddingSizeSmall,
                    bottom: Dimensions.paddingSizeSmall),
                itemBuilder: (context, index) {
                  return InkWell(
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
                            image:
                                '${AppConstants.baseUrl}public/storage/${product.subProducts![index].image?.replaceAll("public/", "/")}',
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
                              product.subProducts![index].name![
                                      AppLocalization.of(context)!
                                          .getCurrentLanguageCode()] ??
                                  '',
                              style: rubikMedium.copyWith(
                                fontSize: 13.0,
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
                                    '${product.subProducts![index].information![AppLocalization.of(context)!.getCurrentLanguageCode()] ?? ''}',
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
                                          10), // Adding some space between the icon and the text
                                  Text(
                                    product.subProducts![index].origin != null
                                        ? CountryCode.fromCountryCode(product
                                                .subProducts![index].origin!)
                                            .name!
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
                                  Text(
                                    '${product.subProducts![index].minQty ?? '1'}',
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
                                        DateTime.parse(product
                                                .subProducts![index]
                                                .expiryDate!)
                                            .add(const Duration(days: 1))),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(),
                          ]),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              PriceConverter.convertPrice(
                                  product.subProducts![index].price),
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]));
                })
          ])
        : const SizedBox();
  }
}

class VegTagView extends StatelessWidget {
  final Product? product;
  const VegTagView({Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(builder: (context, splashProvider, _) {
      return Visibility(
        visible: splashProvider.configModel!.isVegNonVegActive!,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background.withOpacity(0.2),
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  blurRadius: 5,
                  color: Theme.of(context)
                      .colorScheme
                      .background
                      .withOpacity(0.2)
                      .withOpacity(0.05))
            ],
          ),
          child: SizedBox(
            height: 30,
            child: Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  child: Image.asset(
                    Images.getImageUrl(
                      '${product!.productType}',
                    ),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Text(
                  getTranslated('${product!.productType}', context)!,
                  style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall),
                ),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
              ],
            ),
          ),
        ),
      );
    });
  }
}
