import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/screens/home/widget/special_cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

class AllOffersWidget extends StatelessWidget {
  final Product offer;
  const AllOffersWidget({Key? key, required this.offer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cartProvider, child) {
      String offerImage =
          '${AppConstants.baseUrl}public/storage/${offer.image?.replaceAll("public/", "/")}';

      return InkWell(
        onTap: () => ResponsiveHelper.isMobile()
            ? showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (con) => SpecialCartBottomSheet(
                    product: offer,
                    callback: (CartModel cartModel) {
                      showCustomSnackBar(
                          getTranslated('added_to_cart', context),
                          isError: false);
                    },
                    moreOnTap: null),
              )
            : showDialog(
                context: context,
                builder: (con) => Dialog(
                      backgroundColor: Colors.transparent,
                      child: SpecialCartBottomSheet(
                        product: offer,
                        callback: (CartModel cartModel) {
                          showCustomSnackBar(
                              getTranslated('added_to_cart', context),
                              isError: false);
                        },
                      ),
                    )),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey[
                    Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300]!,
                blurRadius:
                    Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                spreadRadius:
                    Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0)),
                  child: FadeInImage.assetNetwork(
                    placeholder: Images.placeholderImage,
                    width: 213,
                    fit: BoxFit.cover,
                    image: offerImage,
                    imageErrorBuilder: (c, o, s) => Image.asset(
                        Images.placeholderImage,
                        width: 213,
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${offer.offerName}',
                        textAlign: TextAlign.start,
                        maxLines: 2, // Adjust the number of lines as needed
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              PriceConverter.convertPrice(offer.price!),
                              style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
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
              ),
            ],
          ),
        ),
      );
    });
  }
}
