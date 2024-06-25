
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/body/place_order_body.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:provider/provider.dart';

class ConfirmButtonView extends StatelessWidget {
  final bool kmWiseCharge;
  final double orderAmount;
  final List<CartModel?> cartList;
  final Function callBack;

  const ConfirmButtonView({Key? key, required this.kmWiseCharge, required this.cartList, required this.orderAmount, required this.callBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Consumer<OrderProvider>(
        builder: (context, orderProvider, _) {
          return Container(
            width: 1170,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: !orderProvider.isLoading
            ? Builder(
              builder: (context) => CustomButton(
                  btnTxt: getTranslated('confirm_order', context),
                  onTap: () {
                    final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;

                      bool isAvailable = true;

                        for (CartModel? cart in cartList) {
                          isAvailable = cart!.product!.isActive! == 1;
                          break;
                        }

                      if(orderAmount < configModel.minimumOrderValue!) {
                        showCustomSnackBar('Minimum order amount is ${configModel.minimumOrderValue}');
                      }
                      else if (!isAvailable) {
                        showCustomSnackBar(getTranslated('one_or_more_products_are_not_available_for_this_selected_time', context));
                      }
                      else {
                        List<Cart> carts = [];
                        for (int index = 0; index < cartList.length; index++) {
                          CartModel cart = cartList[index]!;
                          carts.add(Cart(
                            cart.product!.id.toString(),
                            cart.discountedPrice.toString(),
                            cart.discountAmount,
                            cart.quantity,
                            0.0,
                          ));
                        }

                        PlaceOrderBody placeOrderBody =
                        PlaceOrderBody(
                          cart: carts,
                          orderAmount: double.parse(orderAmount.toStringAsFixed(2)),
                        );

                        orderProvider.placeOrder(placeOrderBody, callBack);
                      }
                  }),
            )
            : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
          );
        }
    );
  }
}