import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/view/base/title_widget.dart';
import 'package:flutter_restaurant/view/screens/home/widget/category_pop_up.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:shimmer/shimmer.dart' as my_shimmer;

class CategoryView extends StatelessWidget {
  const CategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, category, child) {
        return Column(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleWidget(title: getTranslated('Categories', context)),
                    InkWell(
                      onTap: () =>
                          RouterHelper.getCategoryListRoute('Categories'),
                      child: Text(
                        getTranslated('View All', context)!,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  ],
                )),
            Container(
              height: 225,
              margin: const EdgeInsets.only(
                  left: Dimensions.paddingSizeSmall, bottom: 20),
              child: category.categoryList != null
                  ? category.categoryList!.isNotEmpty
                      ? ListView.builder(
                          itemCount: category.categoryList!.length,
                          padding: const EdgeInsets.only(
                              left: Dimensions.paddingSizeSmall,
                              bottom: Dimensions.paddingSizeSmall,
                              top: Dimensions.paddingSizeSmall),
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            Object? name = category
                                        .categoryList![index]
                                        .name![AppLocalization.of(context)!
                                            .getCurrentLanguageCode()]
                                        .length >
                                    15
                                ? '${category.categoryList![index].name![AppLocalization.of(context)!.getCurrentLanguageCode()].substring(0, 15)} ...'
                                : '${category.categoryList![index].name![AppLocalization.of(context)!.getCurrentLanguageCode()] ?? ''}';
                            return SizedBox(
                              child: InkWell(
                                onTap: () => RouterHelper.getCategoryRoute(
                                    category.categoryList![index]),
                                child: Container(
                                  height: 250,
                                  margin: const EdgeInsets.only(
                                      right: Dimensions.paddingSizeSmall),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[
                                            Provider.of<ThemeProvider>(context)
                                                    .darkTheme
                                                ? 900
                                                : 300]!,
                                        blurRadius:
                                            Provider.of<ThemeProvider>(context)
                                                    .darkTheme
                                                ? 2
                                                : 5,
                                        spreadRadius:
                                            Provider.of<ThemeProvider>(context)
                                                    .darkTheme
                                                ? 0
                                                : 1,
                                      )
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(10.0),
                                            topLeft: Radius.circular(10.0)),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: Images.placeholderBanner,
                                          width: 215.4,
                                          height: 150,
                                          fit: BoxFit.cover,
                                          image:
                                              '${AppConstants.baseUrl}public/storage/${category.categoryList![index].image?.replaceAll("public/", "/")}',
                                          imageErrorBuilder: (c, o, s) =>
                                              Image.asset(
                                                  Images.placeholderImage,
                                                  width: 215.4,
                                                  height: 150,
                                                  fit: BoxFit.cover),
                                        ),
                                      ),
                                      Expanded(
                                          child: SizedBox(
                                        width: 213,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '$name',
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                              getTranslated('no_category_available', context)!))
                  : const CategoryRowSkeleton(),
            ),
            ResponsiveHelper.isMobile()
                ? const SizedBox()
                : category.categoryList != null
                    ? Column(
                        children: [
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (con) => const Dialog(
                                      child: SizedBox(
                                          height: 550,
                                          width: 600,
                                          child: CategoryPopUp())));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: Dimensions.paddingSizeSmall),
                              child: CircleAvatar(
                                radius: 35,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(getTranslated('view_all', context)!,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.white)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      )
                    : const CategoryAllShimmer(),
          ],
        );
      },
    );
  }
}

class CategoryRowSkeleton extends StatelessWidget {
  const CategoryRowSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        2, // Assuming 2 items in the row for simplicity
        (index) {
          return SizedBox(
            width: MediaQuery.of(context).size.width / 2.1,
            child: const ShimmerCategoryCard(),
          );
        },
      ),
    );
  }
}

class ShimmerCategoryCard extends StatelessWidget {
  const ShimmerCategoryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return my_shimmer.Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 250,
        margin: const EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.grey, // Placeholder color
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  topLeft: Radius.circular(10.0),
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
                    Container(
                      width: 100, // Adjust the width as needed
                      height: 16,
                      color: Colors.grey, // Placeholder color
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerDropdownShimmer extends StatelessWidget {
  const ShimmerDropdownShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      child: DropdownButton<int>(
        isExpanded: true,
        onChanged: null,
        items: List.generate(3, (index) {
          return DropdownMenuItem<int>(
            value: index,
            child: const Text(
              'Loading...',
              style: TextStyle(color: Colors.transparent),
            ),
          );
        }),
      ),
    );
  }
}

class CategoryAllShimmer extends StatelessWidget {
  const CategoryAllShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
        child: Shimmer(
          duration: const Duration(seconds: 2),
          enabled: Provider.of<CategoryProvider>(context).categoryList == null,
          child: Column(children: [
            Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                color: Theme.of(context).shadowColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 5),
            Container(
                height: 10, width: 50, color: Theme.of(context).shadowColor),
          ]),
        ),
      ),
    );
  }
}
