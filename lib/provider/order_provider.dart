import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/body/place_order_body.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/data/model/response/delivery_man_model.dart';
import 'package:flutter_restaurant/data/model/response/distance_model.dart';
import 'package:flutter_restaurant/data/model/response/offline_payment_model.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/data/model/response/response_model.dart';
import 'package:flutter_restaurant/data/model/response/timeslote_model.dart';
import 'package:flutter_restaurant/data/model/response/zone_model.dart';
import 'package:flutter_restaurant/data/repository/order_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher_string.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepo? orderRepo;
  final SharedPreferences? sharedPreferences;
  OrderProvider({required this.sharedPreferences, required this.orderRepo});

  List<OrderModel>? _runningOrderList;
  List<OrderModel>? _activeOrderList;
  List<ZoneModel>? _zoneList;
  List<OrderModel>? _salesHistoryOrderList;
  List<OrderModel>? _historyOrderList;
  List<OrderDetailsModel>? _orderDetails;
  int? _paymentMethodIndex;
  OrderModel? _trackModel;
  ResponseModel? _responseModel;
  int _addressIndex = -1;
  bool _isLoading = false;
  bool _showCancelled = false;
  DeliveryManModel? _deliveryManModel;
  String? _orderType = 'delivery';
  int _branchIndex = 0;
  List<TimeSlotModel>? _timeSlots;
  List<TimeSlotModel>? _allTimeSlots;
  int _selectDateSlot = 0;
  int _selectTimeSlot = 0;
  double _distance = -1;
  bool _isRestaurantCloseShow = true;
  PaymentMethod? _paymentMethod;
  PaymentMethod? _selectedPaymentMethod;
  double? _partialAmount;
  OfflinePaymentModel? _selectedOfflineMethod;
  List<Map<String, String>>? _selectedOfflineValue;
  bool _isOfflineSelected = false;

  Map<String, TextEditingController> field = {};
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<OrderModel>? get runningOrderList => _runningOrderList;
  List<OrderModel>? get activeOrderList => _activeOrderList;
  List<ZoneModel>? get zoneList => _zoneList;
  List<OrderModel>? get historyOrderList => _historyOrderList;
  List<OrderModel>? get salesHistoryOrderList => _salesHistoryOrderList;
  List<OrderDetailsModel>? get orderDetails => _orderDetails;
  int? get paymentMethodIndex => _paymentMethodIndex;
  OrderModel? get trackModel => _trackModel;
  ResponseModel? get responseModel => _responseModel;
  int get addressIndex => _addressIndex;
  bool get isLoading => _isLoading;
  bool get showCancelled => _showCancelled;
  DeliveryManModel? get deliveryManModel => _deliveryManModel;
  String? get orderType => _orderType;
  int get branchIndex => _branchIndex;
  List<TimeSlotModel>? get timeSlots => _timeSlots;
  List<TimeSlotModel>? get allTimeSlots => _allTimeSlots;
  int get selectDateSlot => _selectDateSlot;
  int get selectTimeSlot => _selectTimeSlot;
  double get distance => _distance;
  bool get isRestaurantCloseShow => _isRestaurantCloseShow;
  PaymentMethod? get paymentMethod => _paymentMethod;
  PaymentMethod? get selectedPaymentMethod => _selectedPaymentMethod;
  double? get partialAmount => _partialAmount;
  OfflinePaymentModel? get selectedOfflineMethod => _selectedOfflineMethod;
  List<Map<String, String>>? get selectedOfflineValue => _selectedOfflineValue;
  bool get isOfflineSelected => _isOfflineSelected;

  set setPartialAmount(double? value) => _partialAmount = value;

  void changeStatus(bool status, {bool notify = false}) {
    _isRestaurantCloseShow = status;
    if (notify) {
      notifyListeners();
    }
  }

  int getRunningOrderCount() {
    return runningOrderList?.length ?? 0;
  }

  int getHistoryOrderCount() {
    return historyOrderList?.length ?? 0;
  }

  double getTotalRunningPartialAmount() {
    double totalPartialAmount = 0.0;

    if (runningOrderList != null) {
      for (OrderModel order in runningOrderList!) {
        totalPartialAmount += order.orderAmount ?? 0.0;
      }
    }

    if (historyOrderList != null) {
      for (OrderModel order in historyOrderList!) {
        if (order.orderStatus != 'canceled') {
          totalPartialAmount += order.orderAmount ?? 0.0;
        }
      }
    }

    return totalPartialAmount;
  }

  int getTotalorders() {
    int totalOrders = 0;

    if (historyOrderList != null) {
      // ignore: unused_local_variable
      for (OrderModel order in historyOrderList!) {
        if (order.orderStatus != 'canceled') {
          totalOrders += 1;
        }
      }
    }

    return totalOrders;
  }

  Future<void> getOrderList() async {
    ApiResponse apiResponse = await orderRepo!.getOrderList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _runningOrderList = [];
      _historyOrderList = [];
      apiResponse.response!.data.forEach((order) {
        OrderModel orderModel = OrderModel.fromJson(order);
        if (orderModel.orderStatus == 'pending' ||
            orderModel.orderStatus == 'processing' ||
            orderModel.orderStatus == 'out_for_delivery' ||
            orderModel.orderStatus == 'delivery_rejected' ||
            orderModel.orderStatus == 'confirmed') {
          _runningOrderList!.add(orderModel);
        } else if (orderModel.orderStatus == 'delivered' ||
            orderModel.orderStatus == 'returned' ||
            orderModel.orderStatus == 'failed' ||
            orderModel.orderStatus == 'canceled') {
          _historyOrderList!.add(orderModel);
        }
      });
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> getActiveOrderList(BuildContext context) async {
    ApiResponse apiResponse = await orderRepo!.getActiveOrderList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _activeOrderList = [];
      apiResponse.response!.data.forEach((order) {
        OrderModel orderModel = OrderModel.fromJson(order);
        _activeOrderList!.add(orderModel);
      });
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> getZonesList(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await orderRepo!.getZonesList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _zoneList = [];
      apiResponse.response!.data.forEach((zone) {
        ZoneModel zoneModel = ZoneModel.fromJson(zone);
        _zoneList!.add(zoneModel);
      });
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }




  Future<void> getOrderInvoice(BuildContext context, String? id) async {
  if (id == null) {
    print('Error: Parameters are null');
    return;
  }

  print('Fetching order invoice for ID: $id');

  try {
    ApiResponse apiResponse = await orderRepo!.getOrderInvoice(id);

    
    
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final urlString = '${AppConstants.baseUrl}${apiResponse.response!.data}';
      if (await canLaunchUrlString(urlString)) {
        await launchUrlString(urlString);
      } else {
        showCustomSnackBar(getTranslated('couldnt Open the file', context)!);
      }
    } else {
      print('API call failed: ${apiResponse.response}');
      ApiChecker.checkApi(apiResponse);
    }
  } catch (e) {
    // Handle exceptions here
    print('Error fetching order invoice: $e');
    // Return ApiResponse indicating error
    // return ApiResponse.withError('Error fetching order invoice: $e');
  }
  
  notifyListeners();
}

  // Future<void> getOrderInvoice(BuildContext context, String? id) async {
  //   if (id == null) {
  //   print('Error: Parameters are null');
  //   return;
  // }
  //   ApiResponse apiResponse = await orderRepo!.getOrderInvoice(id);
  //   print(apiResponse.response!.data);
  //   if (apiResponse.response != null &&
  //       apiResponse.response!.statusCode == 200) {
  //     final urlString = '${AppConstants.baseUrl}${apiResponse.response!.data}';
  //     if (await canLaunchUrlString(urlString)) {
  //       await launchUrlString(urlString);
  //     } else {
  //       // ignore: use_build_context_synchronously
  //       showCustomSnackBar(getTranslated('couldnt Open the file', context)!);
  //     }
  //   } else {
  //     ApiChecker.checkApi(apiResponse);
  //   }
  //   notifyListeners();
  // }


  Future<void> shareOrderInvoice(BuildContext context, String? id) async {
  try {
    _isLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await orderRepo!.getOrderInvoice(id);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final urlString = '${AppConstants.baseUrl}${apiResponse.response!.data}';
      if (await canLaunchUrlString(urlString)) {
        await Share.share('Check out this order invoice: $urlString');
      } else {
        // If launching the URL fails
        print('Failed to launch URL: $urlString');
        showCustomSnackBar(getTranslated('couldnt Open the file', context)!);
      }
    } else {
      // If API response is not successful
      print('API call failed: ${apiResponse.response}');
      ApiChecker.checkApi(apiResponse);
    }
  } catch (e) {
    // If any other error occurs
    print('Error sharing order invoice: $e');
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  // Future<void> shareOrderInvoice(BuildContext context, String? id) async {
  //   _isLoading = true;
  //   notifyListeners();

  //   ApiResponse apiResponse = await orderRepo!.getOrderInvoice(id);

  //   if (apiResponse.response != null &&
  //       apiResponse.response!.statusCode == 200) {
  //     final urlString = '${AppConstants.baseUrl}${apiResponse.response!.data}';
  //     if (await canLaunchUrlString(urlString)) {
  //       // Share.share(urlString);
  //       Share.share('Check out this order invoice: $urlString');
  //     } else {
  //       // ignore: use_build_context_synchronously
  //       showCustomSnackBar(getTranslated('couldnt Open the file', context)!);
  //     }
  //   } else {
  //     ApiChecker.checkApi(apiResponse);
  //   }
  //   _isLoading = false;

  //   notifyListeners();
  // }

  Future<void> getHistoryOrderList(BuildContext context) async {
    ApiResponse apiResponse = await orderRepo!.getHistoryOrderList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _salesHistoryOrderList = [];
      apiResponse.response!.data.forEach((order) {
        OrderModel orderModel = OrderModel.fromJson(order);
        _salesHistoryOrderList!.add(orderModel);
      });
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<List<OrderDetailsModel>?> getOrderDetails(String orderID,
      {String? userId, bool isApiCheck = true}) async {
    _orderDetails = null;
    _isLoading = true;
    _showCancelled = false;

    ApiResponse apiResponse;
    if (userId != null) {
      apiResponse = await orderRepo!.orderDetailsWithUserId(orderID, userId);
    } else {
      apiResponse = await orderRepo!.getOrderDetails(orderID);
    }

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _orderDetails = [];
      apiResponse.response!.data.forEach((orderDetail) =>
          _orderDetails!.add(OrderDetailsModel.fromJson(orderDetail)));
    } else {
      _orderDetails = [];

      if (isApiCheck) {
        ApiChecker.checkApi(apiResponse);
      }
    }
    _isLoading = false;
    notifyListeners();
    return _orderDetails;
  }

  Future<void> getDeliveryManData(String? orderID) async {
    _isLoading = true;

    ApiResponse apiResponse = await orderRepo!.getDeliveryManData(orderID);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _deliveryManModel = DeliveryManModel.fromJson(apiResponse.response!.data);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setOrderNote(String orderID,String note) async {
    await orderRepo!.setOrderNote(orderID,note);
  }

  void setPaymentIndex(int? index, {bool isUpdate = true}) {
    _paymentMethodIndex = index;
    _paymentMethod = null;
    if (isUpdate) {
      notifyListeners();
    }
  }

  void changePaymentMethod(
      {PaymentMethod? digitalMethod,
      bool isUpdate = true,
      OfflinePaymentModel? offlinePaymentModel,
      bool isClear = false}) {
    if (offlinePaymentModel != null) {
      _selectedOfflineMethod = offlinePaymentModel;
    } else if (digitalMethod != null) {
      _paymentMethod = digitalMethod;
      _paymentMethodIndex = null;
      _selectedOfflineMethod = null;
      _selectedOfflineValue = null;
    }
    if (isClear) {
      _paymentMethod = null;
      _selectedPaymentMethod = null;
      clearOfflinePayment();
    }
    if (isUpdate) {
      notifyListeners();
    }
  }

  void savePaymentMethod(
      {int? index, PaymentMethod? method, bool isUpdate = true}) {
    if (method != null) {
      _selectedPaymentMethod = method.copyWith('online');
    } else if (index != null && index == 0) {
      _selectedPaymentMethod = PaymentMethod(
        getWayTitle: getTranslated('cash_on_delivery', Get.context!),
        getWay: 'cash_on_delivery',
        type: 'cash_on_delivery',
      );
    } else if (index != null && index == 1) {
      _selectedPaymentMethod = PaymentMethod(
        getWayTitle: getTranslated('wallet_payment', Get.context!),
        getWay: 'wallet_payment',
        type: 'wallet_payment',
      );
    } else {
      _selectedPaymentMethod = null;
    }

    if (isUpdate) {
      notifyListeners();
    }
  }

  void clearOfflinePayment() {
    _selectedOfflineMethod = null;
    _selectedOfflineValue = null;
    _isOfflineSelected = false;
  }

  Future<ResponseModel?> trackOrder(String? orderID,
      {bool isUpdate = false,
      OrderModel? orderModel,
      bool fromTracking = true}) async {
    _trackModel = null;
    _responseModel = null;
    if (!fromTracking) {
      _orderDetails = null;
    }
    _showCancelled = false;
    if (orderModel == null) {
      _isLoading = true;
      if (isUpdate) {
        notifyListeners();
      }
      ApiResponse apiResponse;

      apiResponse = await orderRepo!.trackOrder(
        orderID,
        guestId:
            Provider.of<AuthProvider>(Get.context!, listen: false).getGuestId(),
      );

      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _trackModel = OrderModel.fromJson(apiResponse.response!.data);
        _responseModel =
            ResponseModel(true, apiResponse.response!.data.toString());
      } else {
        _trackModel = OrderModel(id: -1);
        _responseModel = ResponseModel(
            false, ApiChecker.getError(apiResponse).errors![0].message);
        ApiChecker.checkApi(apiResponse);
      }
    } else {
      _trackModel = orderModel;
      _responseModel = ResponseModel(true, 'Successful');
    }
    _isLoading = false;
    notifyListeners();
    return _responseModel;
  }

  Future<void> placeOrder(PlaceOrderBody placeOrderBody, Function callback,
      {bool isUpdate = true}) async {
    _isLoading = true;
    if (isUpdate) {
      notifyListeners();
    }
    ApiResponse apiResponse = await orderRepo!.placeOrder(placeOrderBody);
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      String? message = apiResponse.response!.data['message'];
      String orderID = apiResponse.response!.data['order_id'].toString();
      callback(true, message, orderID);
    } else {
      showCustomSnackBar(ApiChecker.getError(apiResponse).errors![0].message);
      callback(
          false, ApiChecker.getError(apiResponse).errors![0].message, '-1', -1);
    }

    notifyListeners();
  }

  void stopLoader() {
    _isLoading = false;
    notifyListeners();
  }

  void setAddressIndex(int index) {
    _addressIndex = index;
    notifyListeners();
  }

  void clearPrevData({bool isUpdate = false}) {
    _paymentMethod = null;
    _addressIndex = -1;
    _branchIndex = 0;
    _paymentMethodIndex = null;
    _selectedPaymentMethod = null;
    _selectedOfflineMethod = null;
    clearOfflinePayment();
    _partialAmount = null;
    _distance = -1;
    _trackModel = null;
    if (isUpdate) {
      notifyListeners();
    }
  }

  void cancelOrder(String orderID, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await orderRepo!.cancelOrder(orderID,
        Provider.of<AuthProvider>(Get.context!, listen: false).getGuestId());
    _isLoading = false;

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      OrderModel? orderModel;
      for (var order in _runningOrderList ?? []) {
        if (order.id.toString() == orderID) {
          orderModel = order;
        }
      }
      _runningOrderList?.remove(orderModel);
      _showCancelled = true;
      callback(apiResponse.response!.data['message'], true, orderID);
    } else {
      callback(
          ApiChecker.getError(apiResponse).errors?.first.message, false, '-1');
    }
    notifyListeners();
  }

  void setOrderType(String? type, {bool notify = true}) {
    _orderType = type;
    if (notify) {
      notifyListeners();
    }
  }

  void setBranchIndex(int index) {
    _branchIndex = index;
    _addressIndex = -1;
    _distance = -1;
    notifyListeners();
  }

  Future<void> initializeTimeSlot(BuildContext context) async {
    final scheduleTime = Provider.of<SplashProvider>(context, listen: false)
        .configModel!
        .restaurantScheduleTime!;
    int? duration = Provider.of<SplashProvider>(context, listen: false)
        .configModel!
        .scheduleOrderSlotDuration;
    _timeSlots = [];
    _allTimeSlots = [];
    _selectDateSlot = 0;
    int minutes = 0;
    DateTime now = DateTime.now();
    for (int index = 0; index < scheduleTime.length; index++) {
      DateTime openTime = DateTime(
        now.year,
        now.month,
        now.day,
        DateConverter.convertStringTimeToDate(scheduleTime[index].openingTime!)
            .hour,
        DateConverter.convertStringTimeToDate(scheduleTime[index].openingTime!)
            .minute,
      );

      DateTime closeTime = DateTime(
        now.year,
        now.month,
        now.day,
        DateConverter.convertStringTimeToDate(scheduleTime[index].closingTime!)
            .hour,
        DateConverter.convertStringTimeToDate(scheduleTime[index].closingTime!)
            .minute,
      );

      if (closeTime.difference(openTime).isNegative) {
        minutes = openTime.difference(closeTime).inMinutes;
      } else {
        minutes = closeTime.difference(openTime).inMinutes;
      }
      if (duration! > 0 && minutes > duration) {
        DateTime time = openTime;
        for (;;) {
          if (time.isBefore(closeTime)) {
            DateTime start = time;
            DateTime end = start.add(Duration(minutes: duration));
            if (end.isAfter(closeTime)) {
              end = closeTime;
            }
            _timeSlots!.add(TimeSlotModel(
                day: int.tryParse(scheduleTime[index].day!),
                startTime: start,
                endTime: end));
            _allTimeSlots!.add(TimeSlotModel(
                day: int.tryParse(scheduleTime[index].day!),
                startTime: start,
                endTime: end));
            time = time.add(Duration(minutes: duration));
          } else {
            break;
          }
        }
      } else {
        _timeSlots!.add(TimeSlotModel(
            day: int.tryParse(scheduleTime[index].day!),
            startTime: openTime,
            endTime: closeTime));
        _allTimeSlots!.add(TimeSlotModel(
            day: int.tryParse(scheduleTime[index].day!),
            startTime: openTime,
            endTime: closeTime));
      }
    }
    validateSlot(_allTimeSlots!, 0, notify: false);
  }

  void sortTime() {
    _timeSlots!.sort((a, b) {
      return a.startTime!.compareTo(b.startTime!);
    });

    _allTimeSlots!.sort((a, b) {
      return a.startTime!.compareTo(b.startTime!);
    });
  }

  void updateTimeSlot(int index) {
    _selectTimeSlot = index;
    notifyListeners();
  }

  void updateDateSlot(int index) {
    _selectDateSlot = index;
    if (_allTimeSlots != null) {
      validateSlot(_allTimeSlots!, index);
    }
    notifyListeners();
  }

  void validateSlot(List<TimeSlotModel> slots, int dateIndex,
      {bool notify = true}) {
    _timeSlots = [];
    int day = 0;
    if (dateIndex == 0) {
      day = DateTime.now().weekday;
    } else {
      day = DateTime.now().add(const Duration(days: 1)).weekday;
    }
    if (day == 7) {
      day = 0;
    }
    for (var slot in slots) {
      if (day == slot.day &&
          (dateIndex == 0 ? slot.endTime!.isAfter(DateTime.now()) : true)) {
        _timeSlots!.add(slot);
      }
    }

    if (notify) {
      notifyListeners();
    }
  }

  Future<bool> getDistanceInMeter(
      LatLng originLatLng, LatLng destinationLatLng) async {
    _distance = -1;
    bool isSuccess = false;
    ApiResponse response =
        await orderRepo!.getDistanceInMeter(originLatLng, destinationLatLng);
    try {
      if (response.response!.statusCode == 200 &&
          response.response!.data['status'] == 'OK') {
        isSuccess = true;
        _distance = DistanceModel.fromJson(response.response!.data)
                .rows![0]
                .elements![0]
                .distance!
                .value! /
            1000;
      } else {
        _distance = getDistanceBetween(originLatLng, destinationLatLng) / 1000;
      }
    } catch (e) {
      _distance = getDistanceBetween(originLatLng, destinationLatLng) / 1000;
    }
    notifyListeners();
    return isSuccess;
  }

  Future<void> setPlaceOrder(String placeOrder) async {
    await sharedPreferences!.setString(AppConstants.placeOrderData, placeOrder);
  }

  String? getPlaceOrder() {
    return sharedPreferences!.getString(AppConstants.placeOrderData);
  }

  Future<void> clearPlaceOrder() async {
    await sharedPreferences!.remove(AppConstants.placeOrderData);
  }

  double getDistanceBetween(LatLng startLatLng, LatLng endLatLng) {
    return Geolocator.distanceBetween(
      startLatLng.latitude,
      startLatLng.longitude,
      endLatLng.latitude,
      endLatLng.longitude,
    );
  }

  void changePartialPayment({double? amount, bool isUpdate = true}) {
    _partialAmount = amount;
    if (isUpdate) {
      notifyListeners();
    }
  }

  void setOfflineSelectedValue(List<Map<String, String>>? data,
      {bool isUpdate = true}) {
    _selectedOfflineValue = data;

    if (isUpdate) {
      notifyListeners();
    }
  }

  bool paymentVisibility = true;

  void updatePaymentVisibility(bool vale) {
    paymentVisibility = vale;
    // notifyListeners();
  }

  void setOfflineSelect(bool value) {
    _isOfflineSelected = value;
    notifyListeners();
  }

  Future<ResponseModel> acceptOrderDelivery(String orderId) async {
    _isLoading = true;

    ResponseModel responseModel;
    http.StreamedResponse response =
        await orderRepo!.acceptOrderDelivery(orderId);
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

  Future<ResponseModel> purchaseGift(String giftId) async {
    _isLoading = true;

    ResponseModel responseModel;
    http.StreamedResponse response = await orderRepo!.purchaseGift(giftId);
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

  Future<ResponseModel> rejectOrderDelivery(String orderId, String note) async {
    _isLoading = true;

    ResponseModel responseModel;
    http.StreamedResponse response =
        await orderRepo!.rejectOrderDelivery(orderId, note);
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

  Future<ResponseModel> deliverOrderDelivery(String orderId,String note,String paymentMethod) async {
    _isLoading = true;

    ResponseModel responseModel;
    http.StreamedResponse response =
        await orderRepo!.deliverOrderDelivery(orderId,note,paymentMethod);
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

  Future<ResponseModel> returnOrderDelivery(String orderId) async {
    _isLoading = true;

    ResponseModel responseModel;
    http.StreamedResponse response =
        await orderRepo!.returnOrderDelivery(orderId);
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
