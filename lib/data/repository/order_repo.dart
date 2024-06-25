import 'package:dio/dio.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/body/place_order_body.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OrderRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  OrderRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getOrderList() async {
    try {
      final response = await dioClient!.get(AppConstants.orderListUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getActiveOrderList() async {
    try {
      final response = await dioClient!.get(AppConstants.activeOrderListUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getZonesList() async {
    try {
      final response = await dioClient!.get(AppConstants.zonesListUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getOrderInvoice(String? id ) async {
  

    try {
      final response =
          await dioClient!.get('${AppConstants.orderInvoiceUri}/$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getHistoryOrderList() async {
    try {
      final response = await dioClient!.get(AppConstants.historyOrderListUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getOrderDetails(String orderID) async {
    try {
      final response =
          await dioClient!.get('${AppConstants.orderDetailsUri}$orderID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> cancelOrder(String orderID, String? guestId) async {
    try {
      Map<String, dynamic> data = <String, dynamic>{};
      data['order_id'] = orderID;
      data['_method'] = 'put';

      if (guestId != null) {
        data.addAll({'guest_id': guestId});
      }

      final response =
          await dioClient!.post(AppConstants.orderCancelUri, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> trackOrder(String? orderID, {String? guestId}) async {
    try {
      final response = await dioClient!.get(
          '${AppConstants.trackUri}$orderID${guestId != null ? '&guest_id=$guestId' : ''}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> orderDetailsWithUserId(
      String? orderID, String userId) async {
    try {
      final response =
          await dioClient!.post(AppConstants.guestOrderDetailsUrl, data: {
        'order_id': orderID,
        'user_id': userId,
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> trackOrderWithPhoneNumber(
      String? orderID, String phoneNumber) async {
    try {
      final response = await dioClient!.post(AppConstants.guestTrackUrl, data: {
        'order_id': orderID,
        'phone': phoneNumber,
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> placeOrder(PlaceOrderBody orderBody) async {
    try {
      Map<String, dynamic> data = orderBody.toJson();
      final response =
          await dioClient!.post(AppConstants.placeOrderUri, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDeliveryManData(String? orderID) async {
    try {
      final response =
          await dioClient!.get('${AppConstants.lastLocationUri}$orderID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDistanceInMeter(
      LatLng originLatLng, LatLng destinationLatLng) async {
    try {
      Response response = await dioClient!.get(
          '${AppConstants.distanceMatrixUri}'
          '?origin_lat=${originLatLng.latitude}&origin_lng=${originLatLng.longitude}'
          '&destination_lat=${destinationLatLng.latitude}&destination_lng=${destinationLatLng.longitude}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<http.StreamedResponse> acceptOrderDelivery(String orderId) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${AppConstants.baseUrl}${AppConstants.acceptOrderDeliveryUri}'));
    request.headers['Authorization'] =
        'Bearer ${Provider.of<AuthProvider>(Get.context!, listen: false).getUserToken()}';
    Map<String, String> fields = {};

    fields.addAll(<String, String>{'orderId': orderId});

    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();

    return response;
  }

  Future<http.StreamedResponse> setOrderNote(
      String orderId, String note) async {
    http.MultipartRequest request = http.MultipartRequest('POST',
        Uri.parse('${AppConstants.baseUrl}${AppConstants.setOrderNoteUri}'));
    request.headers['Authorization'] =
        'Bearer ${Provider.of<AuthProvider>(Get.context!, listen: false).getUserToken()}';
    Map<String, String> fields = {};

    fields.addAll(<String, String>{'orderId': orderId, 'note': note});

    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();

    return response;
  }

  Future<http.StreamedResponse> purchaseGift(String giftId) async {
    http.MultipartRequest request = http.MultipartRequest('POST',
        Uri.parse('${AppConstants.baseUrl}${AppConstants.purchaseGiftUri}'));
    request.headers['Authorization'] =
        'Bearer ${Provider.of<AuthProvider>(Get.context!, listen: false).getUserToken()}';
    Map<String, String> fields = {};

    fields.addAll(<String, String>{'giftId': giftId});

    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();

    return response;
  }

  Future<http.StreamedResponse> rejectOrderDelivery(
      String orderId, String note) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${AppConstants.baseUrl}${AppConstants.rejectOrderDeliveryUri}'));
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

  Future<http.StreamedResponse> deliverOrderDelivery(
      String orderId, String note, String paymentMethod) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${AppConstants.baseUrl}${AppConstants.deliverOrderDeliveryUri}'));
    request.headers['Authorization'] =
        'Bearer ${Provider.of<AuthProvider>(Get.context!, listen: false).getUserToken()}';
    Map<String, String> fields = {};

    fields.addAll(<String, String>{
      'orderId': orderId,
      'note': note,
      'paymentMethod': paymentMethod
    });

    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();

    return response;
  }

  Future<http.StreamedResponse> returnOrderDelivery(String orderId) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${AppConstants.baseUrl}${AppConstants.returnOrderDeliveryUri}'));
    request.headers['Authorization'] =
        'Bearer ${Provider.of<AuthProvider>(Get.context!, listen: false).getUserToken()}';
    Map<String, String> fields = {};

    fields.addAll(<String, String>{'orderId': orderId});

    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();

    return response;
  }
}
