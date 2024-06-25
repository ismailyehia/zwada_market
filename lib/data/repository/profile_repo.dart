import 'dart:io';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/userinfo_model.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  ProfileRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getAddressTypeList() async {
    try {
      List<String> addressTypeList = [
        'Select Address type',
        'Home',
        'Office',
        'Other',
      ];
      Response response = Response(
          requestOptions: RequestOptions(path: ''),
          data: addressTypeList,
          statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getUserInfo() async {
    try {
      final response = await dioClient!.get(AppConstants.customerInfoUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCustomerInfo(id, {bool isSupplier = false}) async {
    try {
      final response = await dioClient!.get(
          '${AppConstants.customerInfoUri}?id=$id&&isSupplier=$isSupplier');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDeliveryMenList() async {
    try {
      final response = await dioClient!.get(AppConstants.deliveryMenListUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

//   Future<http.StreamedResponse> updateProfile(UserInfoModel userInfoModel,String password, File? file, XFile? data) async {
//     http.MultipartRequest request = http.MultipartRequest('POST',Uri.parse('${AppConstants.baseUrl}${AppConstants.updateProfileUri}'));
//     if (file != null) {
//       request.files.add(http.MultipartFile('image', file.readAsBytes().asStream(), file.lengthSync(),filename: file.path.split('/').last));
//     } else if (data != null) {
//       Uint8List list = await data.readAsBytes();
//       request.files.add(http.MultipartFile(
// 'image', data.readAsBytes().asStream(), list.length,
//           filename: data.path));
//     }
//     Map<String, String> fields = {};
//     if (password.isEmpty) {
//       fields.addAll(<String, String>{
//         '_method': 'put',
//         'f_name': userInfoModel.fName!,
//         'l_name': userInfoModel.lName!,
//         'phone': userInfoModel.phone!,
//         'email': userInfoModel.email!,
//         'id': userInfoModel.id!.toString()
//       });
//     } else {
//       fields.addAll(<String, String>{
//         '_method': 'put',
//         'f_name': userInfoModel.fName!,
//         'l_name': userInfoModel.lName!,
//         'phone': userInfoModel.phone!,
//         'email': userInfoModel.email!,
//         'id': userInfoModel.id!.toString(),
//         'password': password
//       });
//     }
//     request.fields.addAll(fields);
//     http.StreamedResponse response = await request.send();

//     return response;
//   }




Future<http.StreamedResponse> updateProfile(UserInfoModel userInfoModel, String password, File? file, XFile? data) async {
  // Construct the URL
  Uri url = Uri.parse('${AppConstants.baseUrl}${AppConstants.updateProfileUri}');

  // Create the multipart request
  http.MultipartRequest request = http.MultipartRequest('POST', url);

  // Add file if it exists
  if (file != null) {
    request.files.add(http.MultipartFile(
      'image',
      file.readAsBytes().asStream(),
      file.lengthSync(),
      filename: file.path.split('/').last, // Extract filename without using path package
    ));
  } else if (data != null) {
    Uint8List bytes = await data.readAsBytes();
    request.files.add(http.MultipartFile(
      'image',
      data.readAsBytes().asStream(),
      bytes.length,
      filename: data.path.split('/').last, // Extract filename without using path package
    ));
  }

  // Prepare fields
  Map<String, String> fields = {
    'f_name': userInfoModel.fName!,
    'l_name': userInfoModel.lName!,
    'phone': userInfoModel.phone!,
    'email': userInfoModel.email!,
    'id': userInfoModel.id!.toString(),
  };

  if (password.isNotEmpty) {
    fields['password'] = password;
  } else {
    fields['_method'] = 'put';
  }

  request.fields.addAll(fields);

  // Add headers
  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${sharedPreferences?.getString(AppConstants.token)}',
    'branch-id': '${sharedPreferences?.getInt(AppConstants.branch)}',
  };

  // Set headers in the request
  request.headers.addAll(headers);

  try {
    // Send the request
    http.StreamedResponse response = await request.send();

    // Print response details
    print('Response status: ${response.statusCode}');
    print('Response headers: ${response.headers}');

    // If status code is 302, handle the redirect
    if (response.statusCode == 302) {
      String location = response.headers['location']!;
      print('Redirect location: $location');

      Uri redirectUrl = Uri.parse(location);

      // Create a new request for the redirect URL
      http.MultipartRequest redirectRequest = http.MultipartRequest('PUT', redirectUrl);

      // Add files and fields to the redirected request
      redirectRequest.files.addAll(request.files);
      redirectRequest.fields.addAll(request.fields);

      // Set headers in the redirected request
      redirectRequest.headers.addAll(headers);

      // Send the redirected request
      response = await redirectRequest.send();

      // Print response details of the redirected request
      print('Redirected response status: ${response.statusCode}');
      print('Redirected response headers: ${response.headers}');
    }

    // Return the final response
    return response;
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}







  Future<http.StreamedResponse> setDeliveryMan(
      String orderId, String id) async {
    http.MultipartRequest request = http.MultipartRequest('POST',
        Uri.parse('${AppConstants.baseUrl}${AppConstants.setDeliveryManUri}'));
    request.headers['Authorization'] =
        'Bearer ${Provider.of<AuthProvider>(Get.context!, listen: false).getUserToken()}';
    Map<String, String> fields = {};

    fields.addAll(<String, String>{'orderId': orderId, 'id': id});

    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();

    return response;
  }

  Future<http.StreamedResponse> rejectOrder(String orderId, String note) async {
    http.MultipartRequest request = http.MultipartRequest('POST',
        Uri.parse('${AppConstants.baseUrl}${AppConstants.rejectOrderUri}'));
    request.headers['Authorization'] =
        'Bearer ${Provider.of<AuthProvider>(Get.context!, listen: false).getUserToken()}';
    Map<String, String> fields = {};

    fields.addAll(<String, String>{
      'orderId': orderId,
      'note': note,
    });

    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();

    return response;
  }
}
