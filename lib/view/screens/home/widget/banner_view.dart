import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/banner_model.dart';
import 'package:flutter_restaurant/data/model/response/category_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/banner_provider.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BannerView extends StatelessWidget {
  const BannerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 170,
          child: Consumer<BannerProvider>(
            builder: (context, bannerProvider, child) {
              return bannerProvider.bannerList != null
                  ? bannerProvider.bannerList!.isNotEmpty
                      ? ListView.builder(
                          itemCount: 1,
                          padding:
                              const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          itemBuilder: (context, index) {
                            return Center(
                              child: Consumer<CartProvider>(
                                  builder: (context, cartProvider, child) {
                                return InkWell(
                                  onTap: () {
                                    if (bannerProvider
                                            .bannerList![index].supplierId !=
                                        null) {
                                      CategoryModel? category;
                                      for (CategoryModel categoryModel
                                          in Provider.of<CategoryProvider>(
                                                  context,
                                                  listen: false)
                                              .categoryList!) {
                                        if (categoryModel.id ==
                                            bannerProvider.bannerList![index]
                                                .categoryId) {
                                          category = categoryModel;
                                          break;
                                        }
                                      }
                                      if (category != null) {
                                        RouterHelper.getCategoryRoute(category);
                                      }
                                    } else {
                                      null;
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.white,
                                        )
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: AspectRatio(
                                        aspectRatio: 22.5 / 9,
                                        child: CarouselSlider.builder(
                                          itemCount:
                                              bannerProvider.bannerList!.length,
                                          options: CarouselOptions(
                                            autoPlay: true,
                                            autoPlayInterval:
                                                const Duration(seconds: 5),
                                            autoPlayAnimationDuration:
                                                const Duration(
                                                    milliseconds: 800),
                                            enlargeCenterPage: true,
                                            viewportFraction: 1,
                                            aspectRatio: 22.5 / 9,
                                          ),
                                          itemBuilder:
                                              (context, index, realIndex) {
                                            BannerModel banner = bannerProvider
                                                .bannerList![index];
                                            return GestureDetector(
                                              onTap: () => banner.supplierId !=
                                                      null
                                                  ? RouterHelper
                                                      .getOnSaleListRoute(
                                                          isSale: 'false',
                                                          supplierId: banner
                                                              .supplierId
                                                              .toString())
                                                  : RouterHelper
                                                      .getGiftListRoute(),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: FadeInImage.assetNetwork(
                                                  placeholder:
                                                      Images.placeholderBanner,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 150,
                                                  fit: BoxFit.cover,
                                                  image:
                                                      '${AppConstants.baseUrl}public/storage/${banner.image?.replaceAll("public/", "/")}',
                                                  imageErrorBuilder:
                                                      (c, o, s) => Image.asset(
                                                          Images
                                                              .placeholderBanner,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: 150,
                                                          fit: BoxFit.cover),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                              getTranslated('no_banner_available', context)!))
                  : const BannerShimmer();
            },
          ),
        ),
      ],
    );
  }
}

class BannerShimmer extends StatelessWidget {
  const BannerShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Shimmer(
          duration: const Duration(seconds: 2),
          enabled: Provider.of<BannerProvider>(context).bannerList == null,
          child: Container(
            width: 250,
            height: 85,
            margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[
                      Provider.of<ThemeProvider>(context).darkTheme
                          ? 900
                          : 300]!,
                  blurRadius:
                      Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                  spreadRadius:
                      Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
                )
              ],
              color: Theme.of(context).shadowColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }
}
