import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/brand_provider.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/all_categories_widget.dart';
import 'package:flutter_restaurant/view/base/filter_button_widget.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/product_shimmer.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_web_card_shimmer.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_widget_web.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:go_router/go_router.dart';

class CategoryListScreen extends StatefulWidget {
  final String? type;
  const CategoryListScreen({Key? key, required this.type}) : super(key: key);

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen>
    with TickerProviderStateMixin {
  String _type = 'Categories';
  List types = ['Categories', 'Brands'];

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  void _loadData() async {
    Provider.of<CategoryProvider>(context, listen: false).getCategoryList(false);
    Provider.of<BrandProvider>(context, listen: false).getBrandsList(false);
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
      body: Consumer2<CategoryProvider, BrandProvider>(
        builder: (context, category, brand, child) {
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
                            color:
                                Theme.of(context).textTheme.bodyLarge?.color)),
                    background: Container(
                      height: 50,
                      width: ResponsiveHelper.isDesktop(context)
                          ? 1170
                          : MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(bottom: 50),
                      // child: FadeInImage.assetNetwork(
                      //   placeholder: Images.categoryBanner, fit: BoxFit.cover,
                      //   image: '${splashProvider.baseUrls?.categoryBannerImageUrl}/${widget.categoryBannerImage}',
                      //   imageErrorBuilder: (c, o, s) => Image.asset(Images.categoryBanner, fit: BoxFit.fill),
                      // ),
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
                    FilterButtonWidget(
                      type: _type,
                      items: types,
                      onSelected: (selected) {
                        _type = selected;
                        _type == 'Categories'
                            ? category.getCategoryList(true)
                            : brand.getBrandsList(true);
                      },
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15,8.0,0,8.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              _type == 'Categories'
                              ? '${category.categoryList?.length ?? 0} ${getTranslated(_type, context)}'
                              : '${brand.brandList?.length ?? 0} ${getTranslated(_type, context)}',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 15
                              ),
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
                            child: (category.categoryList != null &&  _type == 'Categories') || (brand.brandList != null &&  _type == 'Brands')
                                ? (category.categoryList!.isNotEmpty &&  _type == 'Categories') || (brand.brandList!.isNotEmpty &&  _type == 'Brands') 
                                    ? GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisSpacing: 30,
                                                mainAxisSpacing: 10,
                                                childAspectRatio:
                                                    ResponsiveHelper.isDesktop(
                                                            context)
                                                        ? 0.7
                                                        : 0.7,
                                                crossAxisCount: ResponsiveHelper
                                                        .isDesktop(context)
                                                    ? 6
                                                    : ResponsiveHelper.isTab(
                                                            context)
                                                        ? 2
                                                        : 2),
                                        itemCount: _type == 'Categories'
                                            ? category.categoryList!.length
                                            : brand.brandList!.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.all(
                                            Dimensions.paddingSizeSmall),
                                        itemBuilder: (context, index) {
                                          return ResponsiveHelper.isDesktop(
                                                  context)
                                              ? ProductWidgetWeb(
                                                  product: category
                                                          .categoryProductList![
                                                      index])
                                              : _type == 'Categories'
                                                  ? AllCategoriesWidget(
                                                      category: category.categoryList![index],
                                                      brand: null,
                                                      type: _type,
                                                    )
                                                  : AllCategoriesWidget(
                                                      brand: brand.brandList![index],
                                                      category: null,
                                                      type: _type,
                                                    );
                                        },
                                      )
                                    : const NoDataScreen(isFooter: false)
                                : GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisSpacing: 30,
                                                mainAxisSpacing: 10,
                                                childAspectRatio:
                                                    ResponsiveHelper.isDesktop(
                                                            context)
                                                        ? 0.7
                                                        : 0.7,
                                                crossAxisCount: ResponsiveHelper
                                                        .isDesktop(context)
                                                    ? 6
                                                    : ResponsiveHelper.isTab(
                                                            context)
                                                        ? 2
                                                        : 2),
                                        itemCount: 10,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.all(
                                            Dimensions.paddingSizeSmall),
                                        itemBuilder: (context, index) {
                                          return ResponsiveHelper.isDesktop(
                                                  context)
                                              ?const ProductWidgetWebShimmer()
                                          : ProductShimmer(
                                              isEnabled: category
                                                      .categoryProductList ==
                                                  null);
                                        },
                                      )
                          ),
                        ),
                      ],
                    ),
                    if (ResponsiveHelper.isDesktop(context)) const FooterView(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  SingleChildScrollView categoryShimmer(
      BuildContext context, double height, CategoryProvider category) {
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
                                isEnabled:
                                    category.categoryProductList == null);
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
