import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/signup_model.dart';
import 'package:flutter_restaurant/helper/email_checker.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
  
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _numberFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _userType = '';

  @override
  void initState() {
    super.initState();
  }

Map<MarkerId, Marker> _markers = {};

  void _addMarker(LatLng latLng) {
  final MarkerId markerId = MarkerId('selected_location');
  final Marker marker = Marker(
    markerId: markerId,
    position: latLng,
    infoWindow: InfoWindow(
      title: 'Selected Location',
      snippet: 'Lat: ${latLng.latitude}, Lng: ${latLng.longitude}',
    ),
    icon: BitmapDescriptor.defaultMarker,
  );

  

  setState(() {
    _markers[markerId] = marker; // Add the marker to the map
  });
}


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final config =
        Provider.of<SplashProvider>(context, listen: false).configModel;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(100), child: WebAppBar())
          : null,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => SafeArea(
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
                                  spreadRadius: 1,
                                )
                              ],
                            )
                          : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              getTranslated('create_account', context)!,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    fontSize: 24,
                                    color: ColorResources.getGreyBunkerColor(
                                      context,
                                    ),
                                  ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            getTranslated('first_name', context)!,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  color: ColorResources.getHintColor(context),
                                ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          CustomTextField(
                            hintText: 'John',
                            isShowBorder: true,
                            controller: _firstNameController,
                            focusNode: _firstNameFocus,
                            nextFocus: _lastNameFocus,
                            inputType: TextInputType.name,
                            capitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          // for last name section
                          Text(
                            getTranslated('last_name', context)!,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color:
                                        ColorResources.getHintColor(context)),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          CustomTextField(
                            hintText: 'Doe',
                            isShowBorder: true,
                            controller: _lastNameController,
                            focusNode: _lastNameFocus,
                            nextFocus: _nameFocus,
                            inputType: TextInputType.name,
                            capitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          Row(
                            children: [
                              Radio(
                                value:
                                    'store', // Provide a unique value for the 'Store' option
                                groupValue: _userType,
                                onChanged: (value) {
                                  setState(() {
                                    _userType = value as String;
                                  });
                                },
                              ),
                              Text(
                                getTranslated('Store', context)!,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 16),
                              Radio(
                                value:
                                    'supplier', // Provide a unique value for the 'Supplier' option
                                groupValue: _userType,
                                onChanged: (value) {
                                  setState(() {
                                    _userType = value as String;
                                  });
                                },
                              ),
                              Text(
                                getTranslated('Supplier', context)!,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          Text(
                            getTranslated('Store or Supplier name', context)!,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color:
                                        ColorResources.getHintColor(context)),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          CustomTextField(
                            hintText: getTranslated('Enter Name', context)!,
                            isShowBorder: true,
                            controller: _nameController,
                            focusNode: _nameFocus,
                            nextFocus: _numberFocus,
                            inputType: TextInputType.name,
                            capitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          Text(
                            getTranslated('mobile_number', context)!,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color:
                                        ColorResources.getHintColor(context)),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Row(children: [
                            Expanded(
                                child: CustomTextField(
                              hintText: getTranslated('number_hint', context),
                              isShowBorder: true,
                              controller: _numberController,
                              focusNode: _numberFocus,
                              nextFocus: _emailFocus,
                              inputType: TextInputType.phone,
                            )),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Text(
                            getTranslated('email', context)!,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color:
                                        ColorResources.getHintColor(context)),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          CustomTextField(
                            hintText: getTranslated('demo_gmail', context),
                            isShowBorder: true,
                            controller: _emailController,
                            focusNode: _emailFocus,
                            nextFocus: _passwordFocus,
                            inputType: TextInputType.emailAddress,
                          ),
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
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            nextFocus: _confirmPasswordFocus,
                            isShowSuffixIcon: true,
                          ),

                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          Text(
                            getTranslated('confirm_password', context)!,
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
                            controller: _confirmPasswordController,
                            focusNode: _confirmPasswordFocus,
                            isShowSuffixIcon: true,
                            inputAction: TextInputAction.done,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          Text(
                            getTranslated(
                                'Please enter your address', context)!,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color:
                                        ColorResources.getHintColor(context)),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          SizedBox(
                            height: 200,
                            // Replace this with your Google Map widget
                            child: GoogleMap(
                              initialCameraPosition: const CameraPosition(
                                target: LatLng(41.0082, 28.9784), // Default location (istanbul)
                                zoom: 12.0,
                              ),
                                onTap: (LatLng latLng) {
    _addMarker(latLng); // Call a function to add a marker at the tapped location
  },
  markers: Set<Marker>.of(_markers.values),
                              
                            ),


                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          Text(
                            getTranslated('address_line_01', context)!,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color:
                                        ColorResources.getHintColor(context)),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          CustomTextField(
                            hintText: getTranslated('address_line_02', context),
                            isShowBorder: true,
                            inputType: TextInputType.streetAddress,
                            inputAction: TextInputAction.next,
                            focusNode: _addressFocus,
                            controller: _addressController,
                          ),

                          const SizedBox(height: 22),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              authProvider.registrationErrorMessage!.isNotEmpty
                                  ? CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      radius: 5)
                                  : const SizedBox.shrink(),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  authProvider.registrationErrorMessage ?? "",
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

                          // for signup button
                          const SizedBox(height: 10),
                          !authProvider.isLoading
                              ? CustomButton(
                                  btnTxt: getTranslated('signup', context),
                                  onTap: () async {
                                    String firstName =
                                        _firstNameController.text.trim();
                                    String lastName =
                                        _lastNameController.text.trim();
                                    String userType = _userType.toString();
                                    String name = _nameController.text.trim();
                                    String number =
                                        _numberController.text.trim();
                                    String email = _emailController.text.trim();
                                    String password =
                                        _passwordController.text.trim();
                                    String confirmPassword =
                                        _confirmPasswordController.text.trim();
                                    String address =
                                        _addressController.text.trim();

                                    if (firstName.isEmpty) {
                                      showCustomSnackBar(getTranslated(
                                          'enter_first_name', context));
                                    } else if (lastName.isEmpty) {
                                      showCustomSnackBar(getTranslated(
                                          'enter_last_name', context));
                                    } else if (userType.isEmpty) {
                                      showCustomSnackBar(getTranslated(
                                          'select_user_type', context));
                                    } else if (name.isEmpty) {
                                      showCustomSnackBar(getTranslated(
                                          'enter_store_or_supplier_name',
                                          context));
                                    } else if (number.isEmpty) {
                                      showCustomSnackBar(getTranslated(
                                          'enter_phone_number', context));
                                    } else if (password.isEmpty) {
                                      showCustomSnackBar(getTranslated(
                                          'enter_password', context));
                                    } else if (password.length < 6) {
                                      showCustomSnackBar(getTranslated(
                                          'password_should_be', context));
                                    } else if (confirmPassword.isEmpty) {
                                      showCustomSnackBar(getTranslated(
                                          'enter_confirm_password', context));
                                    } else if (address.isEmpty) {
                                      showCustomSnackBar(getTranslated(
                                          'enter_address', context));
                                    } else if (password != confirmPassword) {
                                      showCustomSnackBar(getTranslated(
                                          'password_did_not_match', context));
                                    } else if (email.isEmpty) {
                                      showCustomSnackBar(getTranslated(
                                          'enter_email_address', context));
                                    } else if (EmailChecker.isNotValid(email)) {
                                      showCustomSnackBar(getTranslated(
                                          'enter_valid_email', context));
                                    } else {
                                      SignUpModel signUpModel = SignUpModel(
                                        fName: firstName,
                                        lName: lastName,
                                        userType: userType,
                                        name: name,
                                        email: email,
                                        password: password,
                                        phone: number,
                                        address: address,
                                      );
                                      await authProvider
                                          .registration(signUpModel, config!)
                                          .then((status) async {
                                        if (status.isSuccess) {
                                          context.pop();
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

                          // for already an account
                          const SizedBox(height: 11),
                          InkWell(
                            onTap: () => RouterHelper.getLoginRoute(
                                action: RouteAction.pushReplacement),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    getTranslated(
                                        'already_have_account', context)!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: Theme.of(context)
                                                .hintColor
                                                .withOpacity(0.7)),
                                  ),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeSmall),
                                  Text(
                                    getTranslated('login', context)!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: ColorResources
                                                .getGreyBunkerColor(context)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (ResponsiveHelper.isDesktop(context)) const FooterView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

