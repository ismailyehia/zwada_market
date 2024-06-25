import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:provider/provider.dart';

class SuccessPageScreen extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const SuccessPageScreen(this.title, this.subtitle, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(getTranslated('Success Page', context)!),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: Theme.of(context).primaryColor,
                  size: 80,
                ),
              ),
              Text(
                title!,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(
                subtitle!,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(40),
                child: CustomButton(
                  isBorder: false,
                  backgroundColor: Theme.of(context).primaryColor,
                  height: 45,
                  btnTxt: getTranslated('Back to Home', context),
                  textStyle: const TextStyle(color: Colors.white),
                  onTap: () {
                    String? userType =
                        Provider.of<ProfileProvider>(context, listen: false)
                            .userInfoModel!
                            .userType;
                    userType == 'store' || userType == 'supplier'
                        ? RouterHelper.getMainRoute(
                            action: RouteAction.pushNamedAndRemoveUntil)
                        : (userType == 'sales')
                            ? RouterHelper.getSalesMainRoute(
                                action: RouteAction.pushNamedAndRemoveUntil)
                            : RouterHelper.getDeliveryMainRoute(
                                action: RouteAction.pushNamedAndRemoveUntil);
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
