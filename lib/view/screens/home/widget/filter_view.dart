import 'package:flutter/material.dart';
import 'package:flutter_restaurant/view/screens/search/widget/filter_widget.dart';


class FilterView extends StatelessWidget {
  const FilterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight, // You can adjust this based on your needs
        child: GestureDetector(
          onTap: () {
             showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    List<double?> prices = [];
                                    // ignore: prefer_typing_uninitialized_variables
                                    var searchProvider;
                                    for (var product in searchProvider.filterProductList!) {
                                      prices.add(product.price);
                                    }
                                    prices.sort();
                                    double? maxValue = prices.isNotEmpty ? prices[prices.length-1] : 1000;
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.0)),
                                      child: SizedBox(
                                          width: 550,
                                          child: FilterWidget(maxValue: maxValue)),
                                    );
                                  });
          },
          child: Icon(
            Icons.tune,
            size: 20,
            color: Theme.of(context).primaryColor,
          ),
        )
      ),
    );
  }
}

