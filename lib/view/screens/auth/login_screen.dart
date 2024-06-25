import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/address_model.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/data/model/response/user_log_data.dart';
import 'package:flutter_restaurant/data/model/response/userinfo_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _emailNumberFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? _formKeyLogin;
  String? countryCode;

  void savePhoneToSharedPreferences(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone', phone);
  }

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    final ConfigModel configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel!;
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    authProvider.setIsLoading = false;
    authProvider.setIsPhoneVerificationButttonLoading = false;
    UserLogData? userData = authProvider.getUserData();

    if (userData != null) {
      if (configModel.emailVerification!) {
        _emailController!.text = userData.email ?? '';
      } else if (userData.phoneNumber != null) {
        _emailController!.text = userData.phoneNumber!;
      }
      if (countryCode != null) {
        countryCode = userData.countryCode;
      }
      _passwordController!.text = userData.password ?? '';
    }

    countryCode ??= CountryCode.fromCountryCode('LY').dialCode;
  }

  @override
  void dispose() {
    _emailController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;
    final configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel!;
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(100), child: WebAppBar())
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Center(
                  child: Container(
                    width: width > 700 ? 700 : width,
                    padding: width > 700
                        ? const EdgeInsets.all(Dimensions.paddingSizeDefault)
                        : null,
                    decoration: width > 700
                        ? BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 5,
                                  spreadRadius: 1)
                            ],
                          )
                        : null,
                    child: Consumer<AuthProvider>(
                      builder: (context, authProvider, child) => Form(
                        key: _formKeyLogin,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  Images.logo,
                                  height:
                                      MediaQuery.of(context).size.height / 4.5,
                                  fit: BoxFit.scaleDown,
                                  matchTextDirection: true,
                                ),
                              ),
                            ),
                            Center(
                                child: Text(
                              getTranslated('login', context)!,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                      fontSize: 24,
                                      color: ColorResources.getGreyBunkerColor(
                                          context)),
                            )),
                            const SizedBox(height: 35),
                            Provider.of<SplashProvider>(context, listen: false)
                                    .configModel!
                                    .emailVerification!
                                ? Text(
                                    getTranslated('email', context)!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                            color: ColorResources.getHintColor(
                                                context)),
                                  )
                                : Text(
                                    getTranslated('mobile_number', context)!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                            color: ColorResources.getHintColor(
                                                context)),
                                  ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Provider.of<SplashProvider>(context, listen: false)
                                    .configModel!
                                    .emailVerification!
                                ? CustomTextField(
                                    hintText:
                                        getTranslated('demo_gmail', context),
                                    isShowBorder: true,
                                    focusNode: _emailNumberFocus,
                                    nextFocus: _passwordFocus,
                                    controller: _emailController,
                                    inputType: TextInputType.emailAddress,
                                  )
                                : Row(children: [
                                    Expanded(
                                        child: CustomTextField(
                                      hintText:
                                          getTranslated('09********', context),
                                      isShowBorder: true,
                                      focusNode: _emailNumberFocus,
                                      nextFocus: _passwordFocus,
                                      controller: _emailController,
                                      inputType: TextInputType.phone,
                                    )),
                                  ]),
                            const SizedBox(height: Dimensions.paddingSizeLarge),
                            Text(
                              getTranslated('password', context)!,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                      color:
                                          ColorResources.getHintColor(context)),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            CustomTextField(
                              hintText: getTranslated('password_hint', context),
                              isShowBorder: true,
                              isPassword: true,
                              isShowSuffixIcon: true,
                              focusNode: _passwordFocus,
                              controller: _passwordController,
                              inputAction: TextInputAction.done,
                            ),
                            const SizedBox(height: 22),

                            // for remember me section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () => authProvider.toggleRememberMe(),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                            color: authProvider
                                                    .isActiveRememberMe
                                                ? Theme.of(context).primaryColor
                                                : Colors.white,
                                            border: Border.all(
                                                color: authProvider
                                                        .isActiveRememberMe
                                                    ? Colors.transparent
                                                    : Theme.of(context)
                                                        .primaryColor),
                                            borderRadius:
                                                BorderRadius.circular(3)),
                                        child: authProvider.isActiveRememberMe
                                            ? const Icon(Icons.done,
                                                color: Colors.white, size: 17)
                                            : const SizedBox.shrink(),
                                      ),
                                      const SizedBox(
                                          width: Dimensions.paddingSizeSmall),
                                      Text(
                                        getTranslated('remember_me', context)!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                                fontSize: Dimensions
                                                    .fontSizeExtraSmall,
                                                color:
                                                    ColorResources.getHintColor(
                                                        context)),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    RouterHelper.getForgetPassRoute();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      getTranslated(
                                          'forgot_password', context)!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              color:
                                                  ColorResources.getHintColor(
                                                      context)),
                                    ),
                                  ),
                                )
                              ],
                            ),

                            const SizedBox(height: 22),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                authProvider.loginErrorMessage!.isNotEmpty
                                    ? CircleAvatar(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        radius: 5)
                                    : const SizedBox.shrink(),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    authProvider.loginErrorMessage ?? "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                  ),
                                )
                              ],
                            ),

                            // for login button
                            const SizedBox(height: 10),
                            !authProvider.isLoading &&
                                    !authProvider
                                        .isPhoneNumberVerificationButtonLoading
                                ? CustomButton(
                                    btnTxt: getTranslated('login', context),
                                    onTap: () async {
                                      // Call addGuest to create a new guest ID
                                      // await authProvider.addGuest(context);

                                      // AddressModel? addressModel;

                                      //   // Extract the userId from the AddressModel
                                      //   int? userId = addressModel!.userId;
                                      //   // Save the userId using authProvider.saveUserId(userId)
                                      //   await authProvider.saveUserId(userId as String);
                                      //   print('user id = ${addressModel.userId}');

                                      String phone =
                                          _emailController!.text.trim();
                                      savePhoneToSharedPreferences(phone);

                                      if (!phone.startsWith('0') ||
                                          phone.length != 10) {
                                        showCustomSnackBar(getTranslated(
                                            'invalid_phone_number', context));
                                        return;
                                      }

                                      if (!Provider.of<SplashProvider>(context,
                                              listen: false)
                                          .configModel!
                                          .emailVerification!) {
                                        phone = _emailController!.text.trim();
                                      }

                                      String password =
                                          _passwordController!.text.trim();
                                      if (_emailController!.text.isEmpty) {
                                        if (Provider.of<SplashProvider>(context,
                                                listen: false)
                                            .configModel!
                                            .emailVerification!) {
                                          showCustomSnackBar(getTranslated(
                                              'enter_email_address', context));
                                        } else {
                                          showCustomSnackBar(getTranslated(
                                              'enter_phone_number', context));
                                        }
                                      } else if (password.isEmpty) {
                                        showCustomSnackBar(getTranslated(
                                            'enter_password', context));
                                      } else if (password.length < 6) {
                                        showCustomSnackBar(getTranslated(
                                            'password_should_be', context));
                                      } else {
                                        await authProvider
                                            .login(phone, password)
                                            .then((status) async {
                                          if (status.isSuccess) {

                                            if (authProvider
                                                .isActiveRememberMe) {
                                              authProvider
                                                  .saveUserNumberAndPassword(
                                                      UserLogData(
                                                countryCode: countryCode,
                                                phoneNumber: configModel
                                                        .emailVerification!
                                                    ? null
                                                    : _emailController!.text,
                                                email: configModel
                                                        .emailVerification!
                                                    ? _emailController!.text
                                                    : null,
                                                password: password,
                                              ));
                                            } else {
                                              authProvider.clearUserLogData();
                                            }
                                            await Provider.of<ProfileProvider>(
                                                    context,
                                                    listen: false)
                                                .getUserInfo(true);

                                            final UserInfoModel? userInfoModel =
                                                // ignore: use_build_context_synchronously
                                                Provider.of<ProfileProvider>(
                                                        // ignore: use_build_context_synchronously
                                                        context,
                                                        listen: false)
                                                    .userInfoModel;

                                            if (userInfoModel != null) {
                                              if (userInfoModel.userType ==
                                                      'store' ||
                                                  userInfoModel.userType ==
                                                      'supplier') {
                                                RouterHelper.getMainRoute(
                                                    action: RouteAction
                                                        .pushNamedAndRemoveUntil);
                                              } else if (userInfoModel
                                                      .userType ==
                                                  'sales') {
                                                RouterHelper.getSalesMainRoute(
                                                    action: RouteAction
                                                        .pushNamedAndRemoveUntil);
                                              } else if (userInfoModel
                                                      .userType ==
                                                  'delivery') {
                                                RouterHelper.getDeliveryMainRoute(
                                                    action: RouteAction
                                                        .pushNamedAndRemoveUntil);
                                              }
                                            } else {
                                              RouterHelper.getWelcomeRoute();
                                            }
                                          }
                                        });
                                      }
                                    },
                                  )
                                : Center(
                                    child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor),
                                  )),
                            const SizedBox(height: 20),

                            InkWell(
                              onTap: () => RouterHelper.getCreateAccountRoute(),
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    Dimensions.paddingSizeSmall),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      getTranslated(
                                          'create_an_account', context)!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              color: Theme.of(context)
                                                  .hintColor
                                                  .withOpacity(0.7)),
                                    ),
                                    const SizedBox(
                                        width: Dimensions.paddingSizeSmall),
                                    Text(
                                      getTranslated('signup', context)!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              color: ColorResources
                                                  .getGreyBunkerColor(context)),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // if (socialStatus!.isFacebook! || socialStatus.isGoogle!)
                            //   const Center(child: SocialLoginWidget()),

                            // Center(
                            //     child: Text(getTranslated('OR', context)!,
                            //         style:
                            //             poppinsRegular.copyWith(fontSize: 12))),

                            // Center(
                            //   child: InkWell(
                            //     onTap: () {
                            //       RouterHelper.getDashboardRoute(
                            //         'home',
                            //       );
                            //     },
                            //     child: RichText(
                            //         text: TextSpan(children: [
                            //       TextSpan(
                            //           text:
                            //               '${getTranslated('continue_as_a', context)} ',
                            //           style: poppinsRegular.copyWith(
                            //               fontSize: Dimensions.fontSizeSmall,
                            //               color: ColorResources.getHintColor(
                            //                   context))),
                            //       TextSpan(
                            //           text: getTranslated('guest', context),
                            //           style: poppinsRegular.copyWith(
                            //               color: Theme.of(context)
                            //                   .textTheme
                            //                   .bodyLarge!
                            //                   .color)),
                            //     ])),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (ResponsiveHelper.isDesktop(context)) const FooterView(),
            ],
          ),
        ),
      ),
    );
  }
}
