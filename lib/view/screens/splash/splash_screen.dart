import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/userinfo_model.dart';
import 'package:flutter_restaurant/helper/check_version.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/onboarding_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  final String? routeTo;
  const SplashScreen({Key? key, this.routeTo}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();
    bool firstTime = true;
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile;
        isNotConnected
            ? const SizedBox()
            : _globalKey.currentState?.hideCurrentSnackBar();
        _globalKey.currentState?.showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected
                ? getTranslated(
                    'no_internet_connection', _globalKey.currentContext!)!
                : getTranslated('connected', _globalKey.currentContext!)!,
            textAlign: TextAlign.center,
          ),
        ));
        if (!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });

    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    Provider.of<CartProvider>(context, listen: false).getCartData();

    _route();
  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  void _route() {
    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);
    splashProvider.initConfig(context).then((bool isSuccess) {
      if (isSuccess) {
        Timer(const Duration(seconds: 1), () async {
          final config = splashProvider.configModel!;
          double? minimumVersion;

          //
          if (defaultTargetPlatform == TargetPlatform.android &&
              config.playStoreConfig != null) {
            minimumVersion = config.playStoreConfig!.minVersion;
          } else if (defaultTargetPlatform == TargetPlatform.iOS &&
              config.appStoreConfig != null) {
            minimumVersion = config.appStoreConfig!.minVersion;
          }

          if (config.maintenanceMode!) {
            RouterHelper.getMaintainRoute(
                action: RouteAction.pushNamedAndRemoveUntil);
          } else if (Version.parse('$minimumVersion') >
              Version.parse(AppConstants.appVersion)) {
            RouterHelper.getUpdateRoute(
                action: RouteAction.pushNamedAndRemoveUntil);
          } else if (Provider.of<AuthProvider>(Get.context!, listen: false)
              .isLoggedIn()) {
            Provider.of<AuthProvider>(Get.context!, listen: false)
                .updateToken();

            await Provider.of<ProfileProvider>(context, listen: false)
                .getUserInfo(true);

            final UserInfoModel? userInfoModel =
                // ignore: use_build_context_synchronously
                Provider.of<ProfileProvider>(context, listen: false)
                    .userInfoModel;

            if (userInfoModel != null) {
              if (userInfoModel.userType == 'store' ||
                  userInfoModel.userType == 'supplier') {
                RouterHelper.getMainRoute(
                    action: RouteAction.pushNamedAndRemoveUntil);
              } else if (userInfoModel.userType == 'sales') {
                RouterHelper.getSalesMainRoute(
                    action: RouteAction.pushNamedAndRemoveUntil);
              } else if (userInfoModel.userType == 'delivery') {
                RouterHelper.getDeliveryMainRoute(
                    action: RouteAction.pushNamedAndRemoveUntil);
              }
            } else {
              RouterHelper.getWelcomeRoute();
            }
          } else {
            if (widget.routeTo != null) {
              context.pushReplacement(widget.routeTo!);
            } else {
              ResponsiveHelper.isMobile() &&
                      Provider.of<OnBoardingProvider>(Get.context!,
                              listen: false)
                          .showOnBoardingStatus
                  ? RouterHelper.getLanguageRoute(false,
                      action: RouteAction.pushNamedAndRemoveUntil)
                  : RouterHelper.getWelcomeRoute();
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Colors.white,
      body: Center(
        child: Consumer<SplashProvider>(builder: (context, splash, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ResponsiveHelper.isWeb()
                  ? FadeInImage.assetNetwork(
                      placeholder: Images.placeholderRectangle,
                      height: 165,
                      image: splash.baseUrls != null
                          ? '${splash.baseUrls!.restaurantImageUrl}/${splash.configModel!.restaurantLogo}'
                          : '',
                      imageErrorBuilder: (c, o, s) =>
                          Image.asset(Images.placeholderRectangle, height: 165),
                    )
                  : Image.asset(Images.logo, height: 150),
              const SizedBox(height: 30),
              Text(
                ResponsiveHelper.isWeb()
                    ? splash.configModel!.restaurantName!
                    : AppConstants.appName,
                style: rubikBold.copyWith(
                    color: Theme.of(context).primaryColor, fontSize: 30),
              ),
            ],
          );
        }),
      ),
    );
  }
}
