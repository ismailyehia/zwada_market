import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/brand_provider.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/search_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/screens/home/widget/category_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FilterWidget extends StatelessWidget {
  final double? maxValue;
  const FilterWidget({Key? key, required this.maxValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Consumer<SearchProvider>(
        builder: (context, searchProvider, child) => SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(Icons.close,
                        size: 18,
                        color: ColorResources.getGreyBunkerColor(context)),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      getTranslated('filter', context)!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: ColorResources.getGreyBunkerColor(context),
                          ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      searchProvider.setRating(-1);
                      Provider.of<CategoryProvider>(context, listen: false)
                          .updateSelectCategory(-1);
                      Provider.of<BrandProvider>(context, listen: false)
                          .updateSelectBrand(-1);
                      searchProvider.setLowerAndUpperValue(0, 0);
                    },
                    child: Text(
                      getTranslated('reset', context)!,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(color: Theme.of(context).primaryColor),
                    ),
                  )
                ],
              ),

              Text(
                getTranslated('price', context)!,
                style: Theme.of(context).textTheme.displaySmall,
              ),

              // price range
              RangeSlider(
                values: RangeValues(
                    searchProvider.lowerValue, searchProvider.upperValue),
                max: maxValue!,
                min: 0,
                activeColor: Theme.of(context).primaryColor,
                labels: RangeLabels(searchProvider.lowerValue.toString(),
                    searchProvider.upperValue.toString()),
                onChanged: (RangeValues rangeValues) {
                  searchProvider.setLowerAndUpperValue(
                      rangeValues.start, rangeValues.end);
                },
              ),
              Center(
                child: Text(
                  getTranslated(
                    '${searchProvider.lowerValue.toInt()} LYD - ${searchProvider.upperValue.toInt()} LYD',
                    context,
                  )!,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                getTranslated('category', context)!,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 13),

              Center(
                child: Consumer<CategoryProvider>(
                  builder: (context, category, child) {
                    return category.categoryList != null
                        ? DropdownButton<int>(
                            isExpanded: true,
                            value: category.selectCategory,
                            onChanged: (value) {
                              category.updateSelectCategory(value!);
                            },
                            items: [
                                DropdownMenuItem<int>(
                                  value: -1,
                                  child: Text(
                                    'Select a Category',
                                    style: TextStyle(
                                        color: category.selectCategory == -1
                                            ? Colors.black
                                            : ColorResources.getHintColor(
                                                context)),
                                  ),
                                ),
                                ...List.generate(category.categoryList!.length,
                                    (index) {
                                  return DropdownMenuItem<int>(
                                    value: index,
                                    child: Text(
                                      category.categoryList![index].name![
                                              AppLocalization.of(context)!
                                                  .getCurrentLanguageCode()] ??
                                          '',
                                      style: TextStyle(
                                        color: category.selectCategory == index
                                            ? Colors.black
                                            : ColorResources.getHintColor(
                                                context),
                                      ),
                                    ),
                                  );
                                }),
                              ])
                        : const ShimmerDropdownShimmer();
                  },
                ),
              ),

              const SizedBox(height: 15),
              Text(
                getTranslated('Brand', context)!,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 13),

              Center(
                child: Consumer<BrandProvider>(
                  builder: (context, brand, child) {
                    return brand.brandList != null
                        ? DropdownButton<int>(
                            isExpanded: true,
                            value: brand.selectBrand,
                            onChanged: (value) {
                              brand.updateSelectBrand(value!);
                            },
                            items: [
                                DropdownMenuItem<int>(
                                  value: -1,
                                  child: Text(
                                    'Select a Brand',
                                    style: TextStyle(
                                        color: brand.selectBrand == -1
                                            ? Colors.black
                                            : ColorResources.getHintColor(
                                                context)),
                                  ),
                                ),
                                ...List.generate(brand.brandList!.length,
                                    (index) {
                                  return DropdownMenuItem<int>(
                                    value: index,
                                    child: Text(
                                      brand.brandList![index].name![
                                          AppLocalization.of(context)!
                                              .getCurrentLanguageCode()],
                                      style: TextStyle(
                                        color: brand.selectBrand == index
                                            ? Colors.black
                                            : ColorResources.getHintColor(
                                                context),
                                      ),
                                    ),
                                  );
                                }),
                              ])
                        : const ShimmerDropdownShimmer();
                  },
                ),
              ),

              const SizedBox(height: 30),

              CustomButton(
                btnTxt: getTranslated('apply', context),
                onTap: () {
                  searchProvider.sortSearchList(
                    Provider.of<CategoryProvider>(context, listen: false)
                        .selectCategory,
                    Provider.of<CategoryProvider>(context, listen: false)
                        .categoryList,
                    Provider.of<BrandProvider>(context, listen: false)
                        .selectBrand,
                    Provider.of<BrandProvider>(context, listen: false)
                        .brandList,
                  );

                  context.pop();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
