
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/gift_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/model/response/response_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/product_button.dart';
import 'package:flutter_restaurant/view/base/read_more_text.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class GiftBottomSheet extends StatefulWidget {
  final GiftModel? gift;
  final bool fromSetMenu;
  final Function? callback;
  final CartModel? cart;
  final int? cartIndex;
  final bool fromCart;

  const GiftBottomSheet(
      {Key? key,
      required this.gift,
      this.fromSetMenu = false,
      this.callback,
      this.cart,
      this.cartIndex,
      this.fromCart = false})
      : super(key: key);

  @override
  State<GiftBottomSheet> createState() => _GiftBottomSheetState();
}

class _GiftBottomSheetState extends State<GiftBottomSheet> {
  @override
  void initState() {
    super.initState();
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

                price = widget.gift!.pointPrice;
                isAvailable = widget.gift!.status == 1;

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
                                  price!,
                                ),
                                const SizedBox(
                                    height: Dimensions.paddingSizeLarge),
                                const SizedBox(height: 0),
                                if (ResponsiveHelper.isMobile())
                                  CartProductDescription(gift: widget.gift!),
                                const SizedBox(
                                    height: Dimensions.paddingSizeLarge),
                              ]),
                        ),
                      ),
                    ),
                    _cartButton(
                        isAvailable, context, widget.gift!.id.toString()),
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


  Widget _cartButton(bool isAvailable, BuildContext context, String? giftId) {
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
              ]),
            ),
      Consumer<ProductProvider>(builder: (context, productProvider, _) {
        return ProductButton(
          btnTxt: getTranslated('Purchase with points', context),
          backgroundColor: Theme.of(context).primaryColor,
          onTap: () async {
            ResponseModel responseModel =
                await Provider.of<OrderProvider>(context, listen: false)
                    .purchaseGift(giftId!);

            if (responseModel.isSuccess) {
              () async {
                await Provider.of<ProfileProvider>(context, listen: false)
                    .getUserInfo(true);
                double? points =
                    // ignore: use_build_context_synchronously
                    Provider.of<ProfileProvider>(context, listen: false)
                        .userInfoModel!
                        .point;

                RouterHelper.getSuccessPageRoute(
                  // ignore: use_build_context_synchronously
                  getTranslated('Gift Purchased successfully', context),
                  // ignore: use_build_context_synchronously
                  '${getTranslated('Your balance points', context)} $points',
                );
              }(); // Invoke the anonymous function to execute its logic
            } else {
              showCustomSnackBar(responseModel.message);
            }
          },
          onTap2: null,
        );
      }),
    ]);
  }

  Widget _productView(
    BuildContext context,
    double price,
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
                    '${AppConstants.baseUrl}public/storage/${widget.gift!.image?.replaceAll("public/", "/")}',
                imageErrorBuilder: (c, o, s) => Image.asset(
                    Images.placeholderImage,
                    height: 70,
                    width: 85,
                    fit: BoxFit.cover),
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
                  widget.gift!.name![AppLocalization.of(context)!
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
          ],
        ),
      ]),
    );
  }
}

class CartProductDescription extends StatelessWidget {
  const CartProductDescription({
    Key? key,
    required this.gift,
  }) : super(key: key);

  final GiftModel gift;

  @override
  Widget build(BuildContext context) {
    return gift.description != null && gift.description!.isNotEmpty
        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(getTranslated('description', context)!,
                style:
                    rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            Align(
              alignment: Alignment.topLeft,
              child: ReadMoreText(
                gift.description!['en'] ?? '',
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
