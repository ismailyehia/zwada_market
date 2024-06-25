import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/notification_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/menu/web/menu_screen_web.dart';
import 'package:flutter_restaurant/view/screens/menu/widget/Sales_options_view.dart';
import 'package:flutter_restaurant/view/screens/menu/widget/delivery_options_view.dart';
import 'package:flutter_restaurant/view/screens/menu/widget/options_view.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  final Function? onTap;
  final String? role;
  const MenuScreen({Key? key, this.onTap, this.role}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();

  static Future<void> loadData(BuildContext context) async {
    await Provider.of<ProfileProvider>(
      context,
      listen: false,
    ).getUserInfo(true);
    // ignore: use_build_context_synchronously
    await Provider.of<NotificationProvider>(context, listen: false)
        .initNotificationList(context);
    // ignore: use_build_context_synchronously
    await Provider.of<ProductProvider>(context, listen: false)
        .getGiftList(true);
  }
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(100), child: WebAppBar())
          : null,
      body: ResponsiveHelper.isDesktop(context)
          ? const MenuScreenWeb()
          : Consumer<AuthProvider>(builder: (context, authProvider, _) {
              return Column(children: [
                Consumer<ProfileProvider>(
                  builder: (context, profileProvider, child) => Center(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0)),
                      child: Container(
                        width: 1170,
                        padding: const EdgeInsets.only(top: 30),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: MediaQuery.of(context).padding.top),
                              Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2)),
                                child: ClipOval(
                                  child: authProvider.isLoggedIn()
                                      ? FadeInImage.assetNetwork(
                                          placeholder: Images.placeholderUser,
                                          height: 80,
                                          width: 80,
                                          fit: BoxFit.cover,
                                          image:
                                              '${AppConstants.baseUrl}public/storage/${profileProvider.userInfoModel!.image?.replaceAll("public/", "/")}',
                                          imageErrorBuilder: (c, o, s) =>
                                              Image.asset(
                                                  Images.placeholderUser,
                                                  height: 80,
                                                  width: 80,
                                                  fit: BoxFit.cover),
                                        )
                                      : Image.asset(Images.placeholderUser,
                                          height: 80,
                                          width: 80,
                                          fit: BoxFit.cover),
                                ),
                              ),
                              Column(children: [
                                const SizedBox(height: 20),
                                authProvider.isLoggedIn()
                                    ? profileProvider.userInfoModel != null
                                        ? Text(
                                            '${profileProvider.userInfoModel!.fName ?? ''} ${profileProvider.userInfoModel!.lName ?? ''}',
                                            style: rubikRegular.copyWith(
                                                fontSize: Dimensions
                                                    .fontSizeExtraLarge,
                                                color: Colors.white),
                                          )
                                        : Container(
                                            height: 15,
                                            width: 150,
                                            color: Colors.white)
                                    : Text(
                                        getTranslated('guest', context)!,
                                        style: rubikRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeExtraLarge,
                                            color: Colors.white),
                                      ),
                                const SizedBox(height: 10),
                                if (authProvider.isLoggedIn() &&
                                    profileProvider.userInfoModel != null)
                                  Text(
                                    profileProvider.userInfoModel!.email ?? '',
                                    style: rubikRegular.copyWith(
                                        color: Colors.white),
                                  ),
                                const SizedBox(height: 10),
                              ]),
                            ]),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: widget.role != null && widget.role == 'sales'
                        ? SalesOptionsView(onTap: widget.onTap)
                        : widget.role != null && widget.role! == 'delivery'
                            ? DeliveryOptionsView(onTap: widget.onTap)
                            : OptionsView(onTap: widget.onTap)),
              ]);
            }),
    );
  }
}
