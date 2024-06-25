
import 'package:country_list_pick/country_list_pick.dart';
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

class CartBottomSheet extends StatefulWidget {
  final Product? product;
  final bool fromSetMenu;
  final Function? callback;
  final Function? moreOnTap;
  final CartModel? cart;
  final int? cartIndex;
  final bool fromCart;

  const CartBottomSheet(
      {Key? key,
      required this.product,
      this.fromSetMenu = false,
      this.callback,
      this.moreOnTap,
      this.cart,
      this.cartIndex,
      this.fromCart = false})
      : super(key: key);

  @override
  State<CartBottomSheet> createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends State<CartBottomSheet> {
  @override
  void initState() {
    super.initState();

    if (widget.product != null && widget.cart != null) {
      Provider.of<ProductProvider>(context, listen: false)
          .initData(widget.product!, widget.cart!);
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
                double? discount;
                double? priceAfterDiscount;
                bool? isAvailable;
                double total;
                (productProvider.quantity! < widget.product!.minQty!) ||
                        (productProvider.quantity! > widget.product!.maxQty!)
                    ? productProvider.setQuantityInt(widget.product!.minQty!)
                    : null;

                price = widget.product!.price;
                discount = widget.product!.discount;
                priceAfterDiscount = ((discount ?? 0) < (price ?? 0))
                    ? ((price ?? 0) - (discount ?? 0))
                    : price;
                isAvailable = true;
                total = priceAfterDiscount! * (productProvider.quantity ?? 0);

                CartModel cartModel = CartModel(
                  price,
                  priceAfterDiscount,
                  discount! < price! ? discount : 0,
                  productProvider.quantity,
                  0,
                  widget.product,
                );

                cartProvider.isExistInCart(widget.product!.id, null);

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
                                  priceAfterDiscount,
                                ),
                                const SizedBox(
                                    height: Dimensions.paddingSizeLarge),
                                ResponsiveHelper.isMobile()
                                    ? Column(
                                        children: [
                                          _quantityView(context),
                                          const SizedBox(
                                              height:
                                                  Dimensions.paddingSizeLarge),
                                        ],
                                      )
                                    : CartProductDescription(
                                        product: widget.product!),
                                const SizedBox(height: 0),
                                if (ResponsiveHelper.isMobile())
                                  CartProductDescription(
                                      product: widget.product!),
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
                                  (priceAfterDiscount != price)
                                      ? CustomDirectionality(
                                          child: Text(
                                          '(${PriceConverter.convertPrice(price * productProvider.quantity!)})',
                                          style: rubikMedium.copyWith(
                                            color:
                                                Theme.of(context).disabledColor,
                                            fontSize: Dimensions.fontSizeSmall,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ))
                                      : const SizedBox(),
                                ]),
                                const SizedBox(
                                    height: Dimensions.paddingSizeLarge),
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
                    },
          onTap2: widget.product!.displayName != 0 ? widget.moreOnTap : null,
        );
      }),
    ]);
  }

  Widget _productView(
    BuildContext context,
    double price,
    double priceAfterDiscount,
  ) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
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
                  widget.product!.name![AppLocalization.of(context)!
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
                        '${widget.product!.information![AppLocalization.of(context)!.getCurrentLanguageCode()] ?? ''}',
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

                              //
                              Text(
                                    widget.product!.origin != null
                                        ? CountryListPick(
                                            initialSelection: widget.product!.origin!,
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
                                  ), // Adding some space between the icon and the text


                      // Text(
                      //   widget.product!.origin != null
                      //       ? CountryCode.fromCountryCode(
                      //               widget.product!.origin!)
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
                        '${widget.product!.minQty ?? '1'}',
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
                            DateTime.parse(widget.product!.expiryDate!)
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
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Widget _quantityButton(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    (productProvider.quantity! < widget.product!.minQty!) ||
            (productProvider.quantity! > widget.product!.maxQty!)
        ? productProvider.setQuantityInt(widget.product!.minQty!)
        : null;
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFE5F2FE),
          borderRadius: BorderRadius.circular(5)),
      child: Row(children: [
        InkWell(
          onTap: () => productProvider.quantity! > widget.product!.minQty!
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
              productProvider.quantity! != widget.product!.maxQty!
                  ? productProvider.setQuantity(true)
                  : null;
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
