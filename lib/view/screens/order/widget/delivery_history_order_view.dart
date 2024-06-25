import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/view/base/delivery_history_order_widget.dart';
import 'package:flutter_restaurant/view/base/product_shimmer.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_web_card_shimmer.dart';
import 'package:provider/provider.dart';

class DeliveryHistoryOrderView extends StatelessWidget {
  final bool isRunning;
  const DeliveryHistoryOrderView({Key? key, required this.isRunning}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.getHistoryOrderList(context);

    return Consumer<OrderProvider>(
      builder: (context, prodProvider, child) {
        List<OrderModel>? orderList;
          orderList = orderProvider.salesHistoryOrderList;
        if(orderList == null ) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:ResponsiveHelper.isDesktop(context) ? const SliverGridDelegateWithMaxCrossAxisExtent( maxCrossAxisExtent: 195, mainAxisExtent: 250) :
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 4,
              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
            ),
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              return ResponsiveHelper.isDesktop(context) ? const ProductWidgetWebShimmer() : ProductShimmer(isEnabled: orderList == null);
              },
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          );
        }
        if(orderList.isEmpty) {
          return const SizedBox(
            child: Center(
              child:Text('No Orders Yet'),
            ),
          );
        }
        
          return RefreshIndicator(
            onRefresh: () async {
              await Provider.of<OrderProvider>(context, listen: false).getHistoryOrderList(context);
            },
            backgroundColor: Theme.of(context).primaryColor,
            color: Colors.white,
            child:SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child:  Column(children: [

            GridView.builder(
              gridDelegate: ResponsiveHelper.isDesktop(context)
                  ? const SliverGridDelegateWithMaxCrossAxisExtent( maxCrossAxisExtent: 195, mainAxisExtent: 250) :
              SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 5,
                mainAxisSpacing: 10,
                childAspectRatio: 3,
                crossAxisCount: ResponsiveHelper.isTab(context) ? 2 : 1,
              ),
              itemCount: orderList.length,
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall,vertical: Dimensions.paddingSizeSmall),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return DeliveryHistoryOrderWidget(order: orderList![index]);
              },
            ),
            const SizedBox(height: 30),

            orderList.isNotEmpty ? Padding(
              padding: ResponsiveHelper.isDesktop(context)? const EdgeInsets.only(top: 40,bottom: 70) :  const EdgeInsets.all(0),
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
              prodProvider.isLoading
                  ? Center(child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall), child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor,)),
              )) : const SizedBox.shrink(),
            ) : const SizedBox.shrink(),
          ])));
      },
    );
  }
}
