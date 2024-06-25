import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/response_model.dart';
import 'package:flutter_restaurant/data/model/response/userinfo_model.dart';
import 'package:flutter_restaurant/data/repository/profile_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepo? profileRepo;

  ProfileProvider({required this.profileRepo});

  UserInfoModel? _userInfoModel;
  UserInfoModel? _customerInfoModel;
  List<Map<String, dynamic>>? _dileveryMen;

  UserInfoModel? get userInfoModel => _userInfoModel;
  UserInfoModel? get customerInfoModel => _customerInfoModel;
  List<Map<String, dynamic>>? get dileveryMen => _dileveryMen;
  set setUserInfoModel(UserInfoModel? user) => _userInfoModel = user;

  Future<void> getUserInfo(bool reload, {bool isUpdate = true}) async {
    if (reload || _userInfoModel == null) {
      _userInfoModel = null;
    }

    if (_userInfoModel == null) {
      ApiResponse apiResponse = await profileRepo!.getUserInfo();
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _userInfoModel = UserInfoModel.fromJson(apiResponse.response!.data);
        print(" fetched data is $_userInfoModel");
      } else {
        ApiChecker.checkApi(apiResponse);
      }
    }

    if (isUpdate) {
      notifyListeners();
    }
  }

  Future<void> getCustomerInfo(String? id, bool reload,
      {bool isUpdate = true, bool isSupplier = false}) async {
    if (reload || _customerInfoModel == null) {
      _customerInfoModel = null;
    }

    if (_customerInfoModel == null) {
      ApiResponse apiResponse =
          await profileRepo!.getCustomerInfo(id, isSupplier: isSupplier);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _customerInfoModel = UserInfoModel.fromJson(apiResponse.response!.data);
      } else {
        ApiChecker.checkApi(apiResponse);
      }
    }

    if (isUpdate) {
      notifyListeners();
    }
  }

  Future<void> getDeliveryMenList() async {
    _customerInfoModel = null;

    if (_customerInfoModel == null) {
      ApiResponse apiResponse = await profileRepo!.getDeliveryMenList();
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _dileveryMen = [];
        apiResponse.response!.data.forEach((deliveryMan) {
          _dileveryMen!.add(deliveryMan);
        });
      } else {
        ApiChecker.checkApi(apiResponse);
      }
    }
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Future<ResponseModel> updateUserInfo(UserInfoModel updateUserModel,String password, File? file, XFile? data) async {
  //   _isLoading = true;
  //   notifyListeners();
  //   ResponseModel responseModel;
  //   http.StreamedResponse response =
  //       await profileRepo!.updateProfile(updateUserModel, password, file, data);
  //   _isLoading = false;
  //   if (response.statusCode == 200) {
  //     Map map = jsonDecode(await response.stream.bytesToString());
  //     String? message = map["message"];
  //     _userInfoModel = updateUserModel;
  //     responseModel = ResponseModel(true, message);
  //   } else {
  //     responseModel = ResponseModel(
  //         false, '${response.statusCode} ${response.reasonPhrase}');
  //   }
  //   notifyListeners();
  //   print('Response: $responseModel');
  //   return responseModel;
  // }

    Future<ResponseModel> updateUserInfo(UserInfoModel updateUserModel, String password, File? file, XFile? data , ) async {
  _isLoading = true;
  notifyListeners();
  ResponseModel? responseModel;

  try {
    http.StreamedResponse response = await profileRepo!.updateProfile(updateUserModel, password, file, data);

    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String? message = map["message"];
      _userInfoModel = updateUserModel;
      responseModel = ResponseModel(true, message);
    } else {
      responseModel = ResponseModel(false, '${response.statusCode} ${response.reasonPhrase}');
    }
  } catch (e) {
    // Handle any exceptions and print the error message
    responseModel = ResponseModel(false, 'Error: $e');
    print('Error updating user info: $e');
  }

  _isLoading = false;
  notifyListeners();
  print('Response: $responseModel');
  return responseModel;
}

  // Future<ResponseModel> updateUserInfo(
  //   UserInfoModel updateUserModel,
  //   String password,
  //   File? file,
  //   XFile? data,
  // ) async {
  //   _isLoading = true;
  //   notifyListeners();
  //   ResponseModel? responseModel;

  //   try {
  //     http.StreamedResponse response = await profileRepo!
  //         .updateProfile(updateUserModel, password, file, data);

  //     if (response.statusCode == 302) {
  //       // Check if the 'location' header is present
  //       if (response.headers.containsKey('location')) {
  //         String redirectionUrl = response.headers['location']!;

  //         SharedPreferences? sharedPreferences =
  //             await SharedPreferences.getInstance();

  //         String? token = sharedPreferences.getString(AppConstants.token)!;

  //         if (token != null) {
  //           print("the value of  of token is $token");
  //         }
  //         // Perform a GET request on the redirection URL
  //         http.Response redirectionResponse = await http.get(
  //           Uri.parse(redirectionUrl),
  //           headers: {
  //             'Content-Type': 'application/json; charset=UTF-8',
  //             'branch-id': '${sharedPreferences.getInt(AppConstants.branch)}',
  //             'Authorization': 'Bearer $token'
  //           },
  //         );

  //         // Now you can handle the redirection response as needed
  //         print(
  //             'Redirection response status code: ${redirectionResponse.statusCode}');
  //         print('Redirection response body: ${redirectionResponse.body}');
  //       } else {
  //         // If the 'location' header is not present, handle the absence of redirection URL
  //         print('Redirection URL not found in response headers.');
  //       }
  //     } else if (response.statusCode == 200) {
  //       Map map = jsonDecode(await response.stream.bytesToString());
  //       String? message = map["message"];
  //       _userInfoModel = updateUserModel;
  //       responseModel = ResponseModel(true, message);
  //     } else {
  //       responseModel = ResponseModel(
  //           false, '${response.statusCode} ${response.reasonPhrase}');
  //     }
  //   } catch (e) {
  //     // Handle any exceptions and print the error message
  //     responseModel = ResponseModel(false, 'Error: $e');
  //     print('Error updating user info: $e');
  //   }

  //   _isLoading = false;
  //   notifyListeners();
  //   print('Response: $responseModel');
  //   if (responseModel != null) {
  //     return responseModel;
  //   } else {
  //     // Handle the case when responseModel is null
  //     // For example, you can return a default ResponseModel or throw an error
  //     return ResponseModel(false, 'Response is null');
  //   }
  // }

// Future<void> handleRedirection(http.Response response) async {
//   if (response.statusCode == 302) {
//     // Check if the 'location' header is present
//     if (response.headers.containsKey('location')) {
//       String redirectionUrl = response.headers['location']!;
//       // Perform a GET request on the redirection URL
//       http.Response redirectionResponse = await http.get(Uri.parse(redirectionUrl));
//       // Now you can handle the redirection response as needed
//       print('Redirection response status code: ${redirectionResponse.statusCode}');
//       print('Redirection response body: ${redirectionResponse.body}');
//     } else {
//       // If the 'location' header is not present, handle the absence of redirection URL
//       print('Redirection URL not found in response headers.');
//     }
//   } else {
//     // If the response status code is not 302, handle it accordingly
//     print('Received status code: ${response.statusCode}. No redirection needed.');
//   }
// }

  Future<ResponseModel> setDeliveryMan(String orderId, String id) async {
    _isLoading = true;

    ResponseModel responseModel;
    http.StreamedResponse response =
        await profileRepo!.setDeliveryMan(orderId, id);
    _isLoading = false;
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String? message = map["message"];
      responseModel = ResponseModel(true, message);
    } else {
      responseModel = ResponseModel(
          false, '${response.statusCode} ${response.reasonPhrase}');
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> rejectOrder(String orderId, String note) async {
    _isLoading = true;

    ResponseModel responseModel;
    http.StreamedResponse response =
        await profileRepo!.rejectOrder(orderId, note);
    _isLoading = false;
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String? message = map["message"];
      responseModel = ResponseModel(true, message);
    } else {
      responseModel = ResponseModel(
          false, '${response.statusCode} ${response.reasonPhrase}');
    }
    notifyListeners();
    return responseModel;
  }
}
