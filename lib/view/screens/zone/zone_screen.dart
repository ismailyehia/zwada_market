import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/zone_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:provider/provider.dart';

class ZoneScreen extends StatefulWidget {
  const ZoneScreen({Key? key}) : super(key: key);

  @override
  State<ZoneScreen> createState() => _ZoneScreenState();
}

class _ZoneScreenState extends State<ZoneScreen> {
  Future<void> _loadData() async {
    await Provider.of<OrderProvider>(context, listen: false)
        .getZonesList(context);
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (context, orderProvider, child) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Zone Screen'),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await _loadData();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: orderProvider.zoneList!.length,
                    itemBuilder: (context, index) {
                      ZoneModel zoneItem = orderProvider.zoneList![index];
                      return Padding(
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        child: Container(
                          height: 250, // Adjust the height as needed
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusDefault),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusDefault),
                                child: FadeInImage.assetNetwork(
                                  placeholder: Images.branchBanner,
                                  image:
                                      '${AppConstants.baseUrl}public/storage/${zoneItem.image?.replaceAll("public/", "/")}',
                                  fit: BoxFit.cover,
                                  width: 213,
                                  height: 250,
                                  imageErrorBuilder: (c, o, s) => Image.asset(
                                      Images.placeholderImage,
                                      width: 213,
                                      height: 250,
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${getTranslated('name', context)} : ${zoneItem.name}'),
                                    Text(
                                        '${getTranslated('code', context)} : ${zoneItem.code}'),
                                    Text(
                                        '${getTranslated('description', context)} : ${zoneItem.description}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ));
    });
  }
}

class Item {
  final String image;
  final String name;
  final String code;

  Item({required this.image, required this.name, required this.code});
}
