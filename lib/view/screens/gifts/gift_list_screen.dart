import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/gift_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/gift_widget.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/product_shimmer.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_web_card_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:go_router/go_router.dart';

class GiftListScreen extends StatefulWidget {
  const GiftListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<GiftListScreen> createState() => _GiftListScreenState();
}

class _GiftListScreenState extends State<GiftListScreen>
    with TickerProviderStateMixin {
  Future<void> _loadData() async {
    try {
      await Provider.of<ProductProvider>(context, listen: false)
          .getGiftList(true);
    } catch (error) {
      // Handle error, show a Snackbar, etc.
      // ignore: avoid_print
      print('Error loading data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double realSpaceNeeded = (size.width - Dimensions.webScreenWidth) / 2;

    return Scaffold(
        appBar: ResponsiveHelper.isDesktop(context)
            ? const PreferredSize(
                preferredSize: Size.fromHeight(100),
                child: WebAppBar(),
              )
            : null,
        body: RefreshIndicator(
          onRefresh: () async {
            await _loadData();
          },
          child: Consumer<ProductProvider>(
            builder: (context, productprovider, child) {
              List<GiftModel>? giftList = productprovider.giftList!;
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    backgroundColor: Theme.of(context).cardColor,
                    expandedHeight: 20,
                    toolbarHeight: 50,
                    pinned: true,
                    floating: false,
                    leading: ResponsiveHelper.isDesktop(context)
                        ? const SizedBox()
                        : SizedBox(
                            width: ResponsiveHelper.isDesktop(context)
                                ? 1170
                                : MediaQuery.of(context).size.width,
                            child: IconButton(
                                icon: Icon(Icons.chevron_left,
                                    color: Theme.of(context).primaryColor),
                                onPressed: () => context.pop())),
                    flexibleSpace: Container(
                      color: Theme.of(context).canvasColor,
                      margin: ResponsiveHelper.isDesktop(context)
                          ? EdgeInsets.symmetric(horizontal: realSpaceNeeded)
                          : const EdgeInsets.symmetric(horizontal: 0),
                      width: ResponsiveHelper.isDesktop(context)
                          ? 1170
                          : MediaQuery.of(context).size.width,
                      child: FlexibleSpaceBar(
                        title: Text('',
                            style: rubikMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color)),
                        background: Container(
                          height: 50,
                          width: ResponsiveHelper.isDesktop(context)
                              ? 1170
                              : MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(bottom: 50),
                        ),
                      ),
                    ),
                    bottom: const PreferredSize(
                      preferredSize: Size.fromHeight(30.0),
                      child: SizedBox(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(15, 8.0, 0, 8.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  '${giftList.length} ${getTranslated('Gifts', context)}',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: size.height < 600
                                    ? size.height
                                    : size.height - 600,
                              ),
                              child: SizedBox(
                                width: 1170,
                                // ignore: unnecessary_null_comparison
                                child: (giftList != null
                                    ? giftList.isNotEmpty
                                        ? GridView.builder(
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisSpacing: 13,
                                                    mainAxisSpacing: 13,
                                                    childAspectRatio:
                                                        ResponsiveHelper
                                                                .isDesktop(
                                                                    context)
                                                            ? 0.7
                                                            : 3.5,
                                                    crossAxisCount:
                                                        ResponsiveHelper
                                                                .isDesktop(
                                                                    context)
                                                            ? 6
                                                            : ResponsiveHelper
                                                                    .isTab(
                                                                        context)
                                                                ? 2
                                                                : 1),
                                            itemCount: giftList.length,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            padding: const EdgeInsets.all(
                                                Dimensions.paddingSizeSmall),
                                            itemBuilder: (context, index) {
                                              return ResponsiveHelper.isDesktop(
                                                      context)
                                                  ? const SizedBox()
                                                  : GiftWidget(
                                                      gift: giftList[index],
                                                      fromList: true);
                                            },
                                          )
                                        : const NoDataScreen(isFooter: false)
                                    : GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisSpacing: 13,
                                                mainAxisSpacing: 13,
                                                childAspectRatio:
                                                    ResponsiveHelper.isDesktop(
                                                            context)
                                                        ? 0.7
                                                        : 3.5,
                                                crossAxisCount: ResponsiveHelper
                                                        .isDesktop(context)
                                                    ? 6
                                                    : ResponsiveHelper.isTab(
                                                            context)
                                                        ? 2
                                                        : 1),
                                        itemCount: 10,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.all(
                                            Dimensions.paddingSizeSmall),
                                        itemBuilder: (context, index) {
                                          return ResponsiveHelper.isDesktop(
                                                  context)
                                              ? const ProductWidgetWebShimmer()
                                              : ProductShimmer(
                                                  // ignore: unnecessary_null_comparison
                                                  isEnabled: giftList == null);
                                        },
                                      )),
                              ),
                            ),
                          ],
                        ),
                        if (ResponsiveHelper.isDesktop(context))
                          const FooterView(),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }

  SingleChildScrollView categoryShimmer(
      BuildContext context, double height, ProductProvider product) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: !ResponsiveHelper.isDesktop(context) && height < 600
                    ? height
                    : height - 400),
            child: Center(
              child: SizedBox(
                width: 1170,
                child: Column(
                  children: [
                    Shimmer(
                        duration: const Duration(seconds: 2),
                        enabled: true,
                        child: Container(
                            height: 200,
                            width: double.infinity,
                            color: Theme.of(context).shadowColor)),
                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: 10,
                      physics: const NeverScrollableScrollPhysics(),
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio:
                            ResponsiveHelper.isDesktop(context) ? 0.7 : 4,
                        crossAxisCount: ResponsiveHelper.isDesktop(context)
                            ? 6
                            : ResponsiveHelper.isTab(context)
                                ? 2
                                : 1,
                      ),
                      itemBuilder: (context, index) {
                        return ResponsiveHelper.isDesktop(context)
                            ? const ProductWidgetWebShimmer()
                            : ProductShimmer(
                                isEnabled: product.giftList == null);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (ResponsiveHelper.isDesktop(context)) const FooterView(),
        ],
      ),
    );
  }
}
