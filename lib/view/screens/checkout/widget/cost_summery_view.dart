import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/screens/cart/cart_screen.dart';

class CostSummeryView extends StatelessWidget {
  final bool kmWiseCharge;
  final double? subtotal;
  const CostSummeryView({
    Key? key,
    required this.kmWiseCharge,
    this.subtotal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        child: Column(children: [
          if (ResponsiveHelper.isDesktop(context))
            Text(
              getTranslated('cost_summery', context)!,
              style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
          const SizedBox(
            height: 100,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(100),
                child: Icon(
                  Icons.add_shopping_cart,
                  color: Color.fromARGB(83, 158, 158, 158),
                  size: 200, // Adjust the size of the icon
                ),
              ),
            ),
          ),

          //   ItemView(
          //     title: getTranslated('subtotal', context)!,
          //     subTitle: PriceConverter.convertPrice(subtotal),
          //     style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
          //   ),
          //   const SizedBox(height: 10),

          //  if(!takeAway) ItemView(
          //     title: getTranslated('delivery_fee', context)!,
          //     subTitle: (!takeAway || orderProvider.distance != -1) ?
          //     '(+) ${PriceConverter.convertPrice( takeAway ? 0 : deliveryCharge)}'
          //         : getTranslated('not_found', context)!,
          //   ),

          //   const Padding(
          //     padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          //     child: CustomDivider(),
          //   ),

          if (ResponsiveHelper.isDesktop(context))
            ItemView(
              title: getTranslated('total_amount', context)!,
              subTitle: PriceConverter.convertPrice(subtotal!),
              style: rubikMedium.copyWith(
                  fontSize: Dimensions.fontSizeExtraLarge,
                  color: Theme.of(context).primaryColor),
            ),
        ]),
      ),
    ]);
  }
}
