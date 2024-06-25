import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/provider/brand_provider.dart';
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

class BrandScreen extends StatefulWidget {
  final String brandId;
  final String? brandName;
  final String? brandBannerImage;
  const BrandScreen({Key? key, required this.brandId, this.brandName, this.brandBannerImage}) : super(key: key);

  @override
  State<BrandScreen> createState() => BrandScreenState();
}

class BrandScreenState extends State<BrandScreen> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  void _loadData() async {
    Provider.of<BrandProvider>(context, listen: false).getBrandsList(false);
    Provider.of<BrandProvider>(context, listen: false).getBrandProductList(widget.brandId);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double realSpaceNeeded = (size.width - Dimensions.webScreenWidth) / 2;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar()) : null,
      body: Consumer<BrandProvider>(
        builder: (context, brand, child) {
          return brand.isLoading || brand.brandList == null ?
          categoryShimmer(context, size.height, brand) :
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: Theme.of(context).cardColor,
                expandedHeight: 200,
                toolbarHeight: 50 ,
                pinned: true,
                floating: false,
                leading: ResponsiveHelper.isDesktop(context)?const SizedBox():SizedBox(width:ResponsiveHelper.isDesktop(context) ? 1170: MediaQuery.of(context).size.width,
                    child: IconButton(icon: const Icon(Icons.chevron_left, color: Colors.white), onPressed: () => context.pop())),
                flexibleSpace: Container(color:Theme.of(context).canvasColor,
                  margin: ResponsiveHelper.isDesktop(context)
                  ? EdgeInsets.symmetric(horizontal: realSpaceNeeded)
                  : const EdgeInsets.symmetric(horizontal: 0),width
                  : ResponsiveHelper.isDesktop(context)
                  ? 1170
                  : MediaQuery.of(context).size.width,
                  child: FlexibleSpaceBar(
                    title: Text(brand.brandList!.firstWhere((brand) => '${brand.id}' == widget.brandId).name![AppLocalization.of(context)!.getCurrentLanguageCode()],
                    style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),
                    titlePadding: const EdgeInsets.only(
                      bottom: 54 ,
                      left: 50,
                      right: 50,
                    ),
                    background: Container(height: 50,width : ResponsiveHelper.isDesktop(context) ? 1170: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(bottom: 0),
                      child: FadeInImage.assetNetwork(
                        placeholder: Images.categoryBanner, fit: BoxFit.cover,
                        image: '${AppConstants.baseUrl}public/storage/${widget.brandBannerImage!.replaceAll("public/", "/")}',
                        imageErrorBuilder: (c, o, s) => Image.asset(Images.categoryBanner, fit: BoxFit.fill),
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: size.height < 600 ?  size.height : size.height - 600,
                      ),
                      child: SizedBox(
                        width: 1170,
                        child: brand.brandProductList != null 
                          ? brand.brandProductList!.isNotEmpty 
                            ? GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 13,
                                  mainAxisSpacing: 13,
                                  childAspectRatio: ResponsiveHelper.isDesktop(context) ? 0.7 : 3,
                                  crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 2 : 1),
                              itemCount: brand.brandProductList!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              itemBuilder: (context, index) {
                                return ResponsiveHelper.isDesktop(context) ? ProductWidgetWeb(product: brand.brandProductList![index]): ProductWidget(product: brand.brandProductList![index]);
                              },
                            )
                            : const NoDataScreen(isFooter: false)
                          : GridView.builder(
                            shrinkWrap: true,
                            itemCount: 10,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              childAspectRatio: ResponsiveHelper.isDesktop(context) ? 0.7: 4,
                              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 2 : 1,
                            ),
                            itemBuilder: (context, index) {
                              return ResponsiveHelper.isDesktop(context)
                              ? const ProductWidgetWebShimmer ()
                              :ProductShimmer(isEnabled: brand.brandProductList == null);
                            },
                          ),
                      ),
                    ),
                    if(ResponsiveHelper.isDesktop(context)) const FooterView(),
                  ],
                ),
              ),

            ],
          );
        },
      ),
    );
  }

  SingleChildScrollView categoryShimmer(BuildContext context, double height, BrandProvider brand) {
    return SingleChildScrollView(
          child: Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && height < 600 ? height : height - 400),
                child: Center(
                  child: SizedBox(
                    width: 1170,
                    child: Column(
                      children: [
                        Shimmer(
                            duration: const Duration(seconds: 2),
                            enabled: true,
                            child: Container(height: 200,width: double.infinity,color: Theme.of(context).shadowColor)),
                        GridView.builder(
                          shrinkWrap: true,
                          itemCount: 10,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            childAspectRatio: ResponsiveHelper.isDesktop(context) ? 0.7: 4,
                            crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 2 : 1,
                          ),
                          itemBuilder: (context, index) {
                            return ResponsiveHelper.isDesktop(context)? const ProductWidgetWebShimmer ():ProductShimmer(isEnabled: brand.brandProductList == null);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if(ResponsiveHelper.isDesktop(context)) const FooterView(),
            ],
          ),
        );
  }

}
