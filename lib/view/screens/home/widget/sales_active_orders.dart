import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/userinfo_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/view/base/active_order_widget.dart';
import 'package:flutter_restaurant/view/base/product_shimmer.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_web_card_shimmer.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SalesActiveOrders extends StatelessWidget {
  final ScrollController? scrollController;
  late UserInfoModel userInfoModel;

  SalesActiveOrders({Key? key, this.scrollController}) : super(key: key);

  void loadData(BuildContext context) async {
    await Provider.of<ProfileProvider>(
      context,
      listen: false,
    ).getUserInfo(true);
    // ignore: use_build_context_synchronously
    await Provider.of<OrderProvider>(context, listen: false)
        .getActiveOrderList(context);
  }

  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    userInfoModel = profileProvider.userInfoModel!;

    final OrderProvider orderProvider =
        Provider.of<OrderProvider>(context, listen: false);
    orderProvider.getActiveOrderList(context);

    return Consumer<OrderProvider>(
      builder: (context, order, child) {
        if (order.activeOrderList == null) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: ResponsiveHelper.isDesktop(context)
                ? const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 195, mainAxisExtent: 250)
                : SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 4,
                    crossAxisCount: ResponsiveHelper.isDesktop(context)
                        ? 3
                        : ResponsiveHelper.isTab(context)
                            ? 2
                            : 1,
                  ),
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              return ResponsiveHelper.isDesktop(context)
                  ? const ProductWidgetWebShimmer()
                  : const ProductShimmer(isEnabled: true);
            },
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall),
          );
        }
        if (order.activeOrderList!.isEmpty) {
          return SizedBox(
            child: Center(
              child: Text(
                getTranslated('No Orders Yet', context)!,
              ),
            ),
          );
        }

        return RefreshIndicator(
            onRefresh: () async {
              await Provider.of<OrderProvider>(context, listen: false)
                  .getActiveOrderList(context);
            },
            backgroundColor: Theme.of(context).primaryColor,
            color: Colors.white,
            child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(children: [
                  GridView.builder(
                    gridDelegate: ResponsiveHelper.isDesktop(context)
                        ? const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 195, mainAxisExtent: 250)
                        : SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 10,
                            childAspectRatio: 2.2,
                            crossAxisCount:
                                ResponsiveHelper.isTab(context) ? 2 : 1,
                          ),
                    itemCount: order.activeOrderList!.length,
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeExtraSmall),
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return ActiveOrderWidget(
                          order: order.activeOrderList![index]);
                    },
                  ),
                  const SizedBox(height: 30),
                  order.activeOrderList!.isNotEmpty
                      ? Padding(
                          padding: ResponsiveHelper.isDesktop(context)
                              ? const EdgeInsets.only(top: 40, bottom: 70)
                              : const EdgeInsets.all(0),
                          child:
                              // ResponsiveHelper.isDesktop(context) ?
                              // prodProvider.isLoading ? Center(
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              //     child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                              //   ),
                              // ) : (orderProvider.latestOffset == (Provider.of<ProductProvider>(context, listen: false).latestPageSize! / 10).ceil())
                              //     ? const SizedBox() :
                              // SizedBox(
                              //   width: 300,
                              //   child: ElevatedButton(
                              //     style : ElevatedButton.styleFrom(
                              //       backgroundColor: Theme.of(context).primaryColor,
                              //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              //     ),
                              //     onPressed: (){
                              //       orderProvider.moreProduct(context);
                              //       },
                              //     child: Padding(
                              //       padding: const EdgeInsets.symmetric(vertical: 10),
                              //       child: Text(getTranslated('see_more', context)!, style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                              //     ),
                              //   ),
                              // ):
                              order.isLoading
                                  ? Center(
                                      child: Padding(
                                      padding: const EdgeInsets.all(
                                          Dimensions.paddingSizeSmall),
                                      child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor,
                                      )),
                                    ))
                                  : const SizedBox.shrink(),
                        )
                      : const SizedBox.shrink(),
                ])));
      },
    );
  }
}


