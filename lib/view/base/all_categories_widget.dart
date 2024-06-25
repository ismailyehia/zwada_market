import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/brand_model.dart';
import 'package:flutter_restaurant/data/model/response/category_model.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:provider/provider.dart';

class AllCategoriesWidget extends StatelessWidget {
  final CategoryModel? category;
  final BrandModel? brand;
  final String type;

  const AllCategoriesWidget(
      {Key? key,
      required this.category,
      required this.brand,
      required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cartProvider, child) {
      String categoryImage = type == 'Categories'
          ? '${AppConstants.baseUrl}public/storage/${category?.image?.replaceAll("public/", "/")}'
          : '${AppConstants.baseUrl}public/storage/${brand?.image?.replaceAll("public/", "/")}';

      return InkWell(
        onTap: () => type == 'Categories'
            ? RouterHelper.getCategoryRoute(category!)
            : RouterHelper.getBrandRoute(brand!),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey[
                    Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300]!,
                blurRadius:
                    Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                spreadRadius:
                    Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
              )
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    topLeft: Radius.circular(10.0)),
                child: FadeInImage.assetNetwork(
                  placeholder: Images.placeholderImage,
                  width: 213,
                  fit: BoxFit.cover,
                  image: categoryImage,
                  imageErrorBuilder: (c, o, s) => Image.asset(
                      Images.placeholderImage,
                      width: 213,
                      fit: BoxFit.cover),
                ),
              )),
              SizedBox(
                  height: 70,
                  child: SizedBox(
                    width: 213,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            type == 'Categories'
                                ? '${category!.name![AppLocalization.of(context)!.getCurrentLanguageCode()] ?? ''}'
                                : '${brand!.name![AppLocalization.of(context)!.getCurrentLanguageCode()] ?? ''}',
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
      );
    });
  }
}
