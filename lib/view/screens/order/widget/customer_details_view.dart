import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/screens/order/widget/ActionIconsRow.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CustomerDetailsView extends StatelessWidget {
  const CustomerDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, profile, _) {
      return Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, // This aligns the child to the center horizontally within the Row.
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0),
                    ),
                    child: FadeInImage.assetNetwork(
                      placeholder: Images.placeholderImage,
                      width: MediaQuery.of(context).size.width - 30,
                      height: 150,
                      fit: BoxFit.cover,
                      image:
                          '${AppConstants.baseUrl}public/storage/${profile.customerInfoModel!.banner?.replaceAll("public/", "/")}',
                      imageErrorBuilder: (c, o, s) => Image.asset(
                        Images.placeholderImage,
                        width: MediaQuery.of(context).size.width - 30,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            getTranslated('Customer', context)!,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: FadeInImage.assetNetwork(
                                  placeholder: Images.placeholderImage,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  image:
                                      '${AppConstants.baseUrl}public/storage/${profile.customerInfoModel!.image?.replaceAll("public/", "/")}',
                                  imageErrorBuilder: (c, o, s) => Image.asset(
                                    Images.placeholderImage,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Loyalty Point
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.store_outlined,
                                    size: 15,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(
                                      width:
                                          10), // Adding some space between the icon and the text
                                  Text(
                                    '${(profile.customerInfoModel!.name ?? '').length > 5 ? '${(profile.customerInfoModel!.name ?? '').substring(0, 5)}...' : (profile.customerInfoModel!.name ?? '')} | ${profile.customerInfoModel!.code}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.fmd_good_outlined,
                                    size: 15,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(
                                      width:
                                          10), // Adding some space between the icon and the text
                                  Text(
                                    profile.customerInfoModel!.zoneName!,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          Expanded(
                            child: ActionIconsRow(
                              gmLink: profile.customerInfoModel!.gmLink!,
                              wpNumber: profile.customerInfoModel!.wpNumber!,
                              phoneNumber: profile.customerInfoModel!.phone!,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                CustomButton(
                                  isBorder: false,
                                  backgroundColor: const Color(0xFFf9be13),
                                  height: 45,
                                  btnTxt: getTranslated('Direction', context),
                                  textStyle:
                                      const TextStyle(color: Colors.white),
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // First Column
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                getTranslated('Success Orders', context)!,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                profile.customerInfoModel!.successOrderCount
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),

                          Container(
                            color: Colors.grey,
                            width: 1,
                            height: 40,
                          ),

                          // Loyalty Point
                          Column(
                            children: [
                              Text(
                                getTranslated('Purchase Amount', context)!,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                PriceConverter.convertPrice(
                                    profile.customerInfoModel!.purchaseAmount),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Border between columns
                      const Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                      ),

                      // Second Column
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            // Store Ranking
                            Text(
                              getTranslated('Store Ranking', context)!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const SizedBox(height: 8),
                            // 'Stars!'
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = 0;
                                    i < 3;
                                    i++) // Adjust the number based on the rating scale
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber, // Star color
                                    size: 24, // Star size
                                  ),
                                for (int i = 0;
                                    i < 2;
                                    i++) // Adjust the number based on the rating scale
                                  const Icon(
                                    Icons.star_outline,
                                    color: Colors.amber, // Star color
                                    size: 24, // Star size
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}


void makePhoneCall(String phoneNumber) async {
  String url = 'tel:$phoneNumber';

  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    // Handle error, e.g., display an error message.
  }
}
