import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/signup_model.dart';
import 'package:flutter_restaurant/data/model/response/social_login_model.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  AuthRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> registration(SignUpModel signUpModel) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.registerUri,
        data: signUpModel.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> login({String? phone, String? password}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.loginUri,
        data: {"phone": phone, "password": password},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateToken() async {
    try {
      String? deviceToken = '@';

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
        NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
          alert: true, announcement: false, badge: true, carPlay: false,
          criticalAlert: false, provisional: false, sound: true,
        );
        if(settings.authorizationStatus == AuthorizationStatus.authorized) {
          deviceToken = (await getDeviceToken())!;
        }
      }else {

        deviceToken = (await getDeviceToken())!;
      }

      if(!kIsWeb){
        FirebaseMessaging.instance.subscribeToTopic(AppConstants.topic);
      }

      Map<String, dynamic> data = {"_method": "put", "cm_firebase_token": deviceToken};
      if(getGuestId() != null) {
        data.addAll({'guest_id' : getGuestId()});
      }

      Response response = await dioClient!.post(
        AppConstants.tokenUri,
        data: data,
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<String?> getDeviceToken() async {
    String? deviceToken = '@';
    try{
      deviceToken = (await FirebaseMessaging.instance.getToken())!;

    }catch(error){
      debugPrint('eroor ====> $error');
    }
    if (deviceToken != null) {
      debugPrint('--------Device Token---------- $deviceToken');
    }

    return deviceToken;
  }

  // for forgot password
  Future<ApiResponse> forgetPassword(String email) async {
    try {
      Response response = await dioClient!.post(AppConstants.forgetPasswordUri, data: {"email_or_phone": email, "email": email});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> verifyToken(String email, String token) async {
    try {
      Response response = await dioClient!.post(AppConstants.verifyTokenUri, data: {"email_or_phone": email, "email": email, "reset_token": token});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> resetPassword(String? mail, String? resetToken, String password, String confirmPassword) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.resetPasswordUri,
        data: {"_method": "put", "reset_token": resetToken, "password": password, "confirm_password": confirmPassword, "email_or_phone": mail, "email": mail},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for verify email number
  Future<ApiResponse> checkEmail(String email) async {
    try {
      Response response = await dioClient!.post(AppConstants.checkEmailUri, data: {"email": email});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> verifyEmail(String email, String token) async {
    try {
      Response response = await dioClient!.post(AppConstants.verifyEmailUri, data: {"email": email, "token": token});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }



  //verify phone number

  Future<ApiResponse> checkPhone(String phone) async {
    try {
      Response response = await dioClient!.post(AppConstants.baseUrl + AppConstants.checkPhoneUri + phone, data: {"phone" : phone});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> verifyPhone(String phone, String token) async {
    try {
      Response response = await dioClient!.post(
          AppConstants.verifyPhoneUri, data: {"phone": phone.trim(), "token": token});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }




  // for  user token
  Future<void> saveUserToken(String token) async {
    dioClient!.updateHeader(getToken: token);

    try {

      await sharedPreferences!.setString(AppConstants.token, token);
    } catch (e) {
      rethrow;
    }
  }

  String getUserToken() {
    return sharedPreferences!.getString(AppConstants.token) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences!.containsKey(AppConstants.token);
  }

  Future<bool> clearSharedData() async {
    if(!kIsWeb) {
      Future.delayed(const Duration(milliseconds: 100)).then((value) async =>
      await FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic));
    }

   try{
     await dioClient!.post(
       AppConstants.tokenUri,
       data: {"_method": "put", "cm_firebase_token": '@'},
     );
   }catch(error){
      debugPrint('error $error');
   }
    await sharedPreferences!.remove(AppConstants.token);
    await sharedPreferences!.remove(AppConstants.cartList);
    await sharedPreferences!.remove(AppConstants.userAddress);
    await sharedPreferences!.remove(AppConstants.searchAddress);
    return true;
  }

  Future<void> saveUserNumberAndPassword(String userData) async {
    try {
      await sharedPreferences!.setString(AppConstants.userLogData, userData);
    } catch (e) {
      rethrow;
    }
  }

  String getUserLogData() {
    return sharedPreferences!.getString(AppConstants.userLogData) ?? "";
  }

  Future<bool> clearUserLog() async {
    return await sharedPreferences!.remove(AppConstants.userLogData);
  }

  Future<ApiResponse> deleteUser() async {
    try{
      Response response = await dioClient!.delete(AppConstants.customerRemove);
      return ApiResponse.withSuccess(response);
    }catch(e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }

  }

  Future<ApiResponse> socialLogin(SocialLoginModel socialLogin) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.socialLogin,
        data: socialLogin.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  // Future<ApiResponse> addGuest(String? fcmToken) async {
  //   try{
  //     Response response = await dioClient!.post(AppConstants.addGuest, data: {'fcm_token': fcmToken});
  //     return ApiResponse.withSuccess(response);
  //   }catch(e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }

  // }
  
  Future<ApiResponse> addGuest(String? fcmToken ,  String? guestId ) async {
  try{
    // Get the guestId from the local variable
    
    Response response = await dioClient!.post(
      AppConstants.addGuest,
      data: {'fcm_token': fcmToken},
      // Set the guestId in the request headers
      options: Options(headers: {'guest-id': guestId}), 
    );
    // sharedPreferences!.setString(AppConstants.guestId , guestId!);
    return ApiResponse.withSuccess(response);
  } catch(e) {
    return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  }
}


  Future<void> saveGuestId(String id) async {
    try {
      await sharedPreferences!.setString(AppConstants.guestId, id);
    } catch (e) {
      rethrow;
    }
  }

  // String? getGuestId()=> sharedPreferences?.getString(AppConstants.guestId);

  String? getGuestId()=> sharedPreferences?.getString(AppConstants.guestId) ?? '';


  Future<ApiResponse> firebaseAuthVerify({required String phoneNumber, required String session, required String otp, required bool isForgetPassword}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.firebaseAuthVerify,
        data: {
          'sessionInfo' : session,
          'phoneNumber' : phoneNumber,
          'code' : otp,
          'is_reset_token' : isForgetPassword ? 1 : 0,
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }




}
