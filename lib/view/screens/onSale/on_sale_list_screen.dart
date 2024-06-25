import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/product_shimmer.dart';
import 'package:flutter_restaurant/view/base/product_widget.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_web_card_shimmer.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_widget_web.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:go_router/go_router.dart';

class OnSaleListScreen extends StatefulWidget {
  final bool isSale;
  final String? supplierId;

  const OnSaleListScreen({
    Key? key,
    required this.isSale,
    this.supplierId,
  }) : super(key: key);

  @override
  State<OnSaleListScreen> createState() => _OnSaleListScreenState();
}

class _OnSaleListScreenState extends State<OnSaleListScreen>
    with TickerProviderStateMixin {
  Future<void> _loadData() async {
    try {
      if (widget.isSale) {
        await Provider.of<ProductProvider>(context, listen: false)
            .getOnSaleProductList(false, '1', '500');
      } else {
        if (widget.supplierId != null) {
          await Provider.of<ProfileProvider>(context, listen: false)
              .getCustomerInfo(widget.supplierId, true, isSupplier: true);

          await Provider.of<ProductProvider>(context, listen: false)
              .getSupplierProductList(true, widget.supplierId);
        } else {
          await Provider.of<ProductProvider>(context, listen: false)
              .getFeatureProductList(true);
        }
      }
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
              return Consumer<ProfileProvider>(
                builder: (context, profile, child) {
                  List<Product>? productList = widget.isSale
                      ? productprovider.onSaleProductList!
                      : widget.supplierId != null
                          ? productprovider.supplierProductList!
                          : productprovider.featureProductList!;
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
                              ? EdgeInsets.symmetric(
                                  horizontal: realSpaceNeeded)
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 8.0, 0, 8.0),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              '${productList.length} ${widget.isSale == true ? getTranslated('On Sale Products', context) : widget.supplierId != null ? getTranslated('Supplier Products', context) : getTranslated('Feature Products', context)}',
                                              textAlign: TextAlign.start,
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    widget.supplierId != null
                                        ? Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    profile.customerInfoModel !=
                                                            null
                                                        ? profile.customerInfoModel!
                                                                    .name!.length >
                                                                30
                                                            ? profile
                                                                .customerInfoModel!
                                                                .name!
                                                                .substring(
                                                                    0, 30)
                                                            : profile
                                                                .customerInfoModel!
                                                                .name!
                                                        : '',
                                                    style: const TextStyle(
                                                        fontSize: 10),
                                                  ),
                                                  profile.customerInfoModel !=
                                                          null
                                                      ? ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50.0),
                                                          child: FadeInImage
                                                              .assetNetwork(
                                                            placeholder: Images
                                                                .placeholderImage,
                                                            width: 50,
                                                            height: 50,
                                                            fit: BoxFit.cover,
                                                            image:
                                                                '${AppConstants.baseUrl}public/storage/${profile.customerInfoModel!.image!.replaceAll("public/", "/")}',
                                                            imageErrorBuilder:
                                                                (c, o, s) =>
                                                                    Image.asset(
                                                              Images
                                                                  .placeholderImage,
                                                              width: 50,
                                                              height: 50,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                ],
                                              )
                                            ],
                                          )
                                        : const SizedBox()
                                  ],
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
                                    child: (productList != null
                                        ? productList.isNotEmpty
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
                                                itemCount: productList.length,
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                padding: const EdgeInsets.all(
                                                    Dimensions
                                                        .paddingSizeSmall),
                                                itemBuilder: (context, index) {
                                                  return ResponsiveHelper
                                                          .isDesktop(context)
                                                      ? ProductWidgetWeb(
                                                          product: productList[
                                                              index],
                                                        )
                                                      : ProductWidget(
                                                          product: productList[
                                                              index],
                                                          fromList: true);
                                                },
                                              )
                                            : const NoDataScreen(
                                                isFooter: false)
                                        : GridView.builder(
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
                                                      isEnabled:
                                                          // ignore: unnecessary_null_comparison
                                                          productList == null);
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
                                isEnabled: product.onSaleProductList == null);
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






