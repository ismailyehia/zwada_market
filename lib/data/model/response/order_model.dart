import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/model/response/userinfo_model.dart';

class OrderModel {
  int? _id;
  int? _userId;
  double? _orderAmount;
  double? _couponDiscountAmount;
  String? _couponDiscountTitle;
  String? _paymentStatus;
  String? _orderStatus;
  String? _rejectReason;
  UserInfoModel? _customer;
  double? _totalTaxAmount;
  String? _paymentMethod;
  String? _transactionReference;
  int? _deliveryAddressId;
  String? _createdAt;
  String? _updatedAt;
  int? _deliveryManId;
  double? _deliveryCharge;
  String? _orderNote;
  String? _deliveryRejectReason;
  List<int>? _addOnIds;
  List<Details>? _details;
  DeliveryMan? _deliveryMan;
  UserInfoModel? _sales;
  int? _detailsCount;
  String? _orderType;
  String? _deliveryTime;
  String? _deliveryDate;
  double? _extraDiscount;
  DeliveryAddress? _deliveryAddress;
  String? _preparationTime;
  bool? _isProductAvailable;
  List<OrderPartialPayment>? _orderPartialPayments;
  bool? _isGuest;

  OrderModel({
    int? id,
    int? userId,
    double? orderAmount,
    double? couponDiscountAmount,
    String? couponDiscountTitle,
    String? paymentStatus,
    String? orderStatus,
    double? totalTaxAmount,
    String? paymentMethod,
    String? transactionReference,
    int? deliveryAddressId,
    String? createdAt,
    String? updatedAt,
    String? checked,
    int? deliveryManId,
    double? deliveryCharge,
    String? orderNote,
    String? deliveryRejectReason,
    List<int>? addOnIds,
    List<Details>? details,
    DeliveryMan? deliveryMan,
    UserInfoModel? sales,
    int? detailsCount,
    String? deliveryTime,
    String? deliveryDate,
    String? orderType,
    double? extraDiscount,
    DeliveryAddress? deliveryAddress,
    String? preparationTime,
    bool? isProductAvailable,
    List<OrderPartialPayment>? orderPartialPayments,
    bool? isGuest,
  }) {
    _id = id;
    _userId = userId;
    _orderAmount = orderAmount;
    _couponDiscountAmount = couponDiscountAmount;
    _couponDiscountTitle = couponDiscountTitle;
    _paymentStatus = paymentStatus;
    _orderStatus = orderStatus;
    _rejectReason = rejectReason;
    _customer = customer;
    _totalTaxAmount = totalTaxAmount;
    _paymentMethod = paymentMethod;
    _transactionReference = transactionReference;
    _deliveryAddressId = deliveryAddressId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deliveryManId = deliveryManId;
    _deliveryCharge = deliveryCharge;
    _orderNote = orderNote;
    _deliveryRejectReason = deliveryRejectReason;
    _addOnIds = addOnIds;
    _details = details;
    _deliveryMan = deliveryMan;
    _sales = sales;
    _detailsCount = detailsCount;
    _orderType = orderType;
    _deliveryTime = deliveryTime;
    _deliveryDate = deliveryDate;
    _extraDiscount = extraDiscount;
    _deliveryAddress = deliveryAddress;
    _preparationTime = preparationTime;
    _isProductAvailable = isProductAvailable;
    _orderPartialPayments = orderPartialPayments;
    _isGuest = isGuest;
  }

  int? get id => _id;
  int? get userId => _userId;
  double? get orderAmount => _orderAmount;
  double? get couponDiscountAmount => _couponDiscountAmount;
  String? get couponDiscountTitle => _couponDiscountTitle;
  String? get paymentStatus => _paymentStatus;
  String? get orderStatus => _orderStatus;
  String? get rejectReason => _rejectReason;
  UserInfoModel? get customer => _customer;
  double? get totalTaxAmount => _totalTaxAmount;
  // ignore: unnecessary_getters_setters
  String? get paymentMethod => _paymentMethod;

  get partialAmount => null;
  // ignore: unnecessary_getters_setters
  set paymentMethod(String? method) => _paymentMethod = method;
  String? get transactionReference => _transactionReference;
  int? get deliveryAddressId => _deliveryAddressId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get deliveryManId => _deliveryManId;
  double? get deliveryCharge => _deliveryCharge;
  String? get orderNote => _orderNote;
  String? get deliveryRejectReason => _deliveryRejectReason;
  List<int>? get addOnIds => _addOnIds;
  List<Details>? get details => _details;
  DeliveryMan? get deliveryMan => _deliveryMan;
  UserInfoModel? get sales => _sales;
  int? get detailsCount => _detailsCount;
  String? get orderType => _orderType;
  String? get deliveryTime => _deliveryTime;
  String? get deliveryDate => _deliveryDate;
  double? get extraDiscount => _extraDiscount;
  DeliveryAddress? get deliveryAddress => _deliveryAddress;
  String? get preparationTime => _preparationTime;
  bool? get isProductAvailable => _isProductAvailable;
  List<OrderPartialPayment>? get orderPartialPayments => _orderPartialPayments;
  bool? get isGuest => _isGuest;

  OrderModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _orderAmount = json['order_amount'].toDouble();
    _couponDiscountAmount = 0.00;
    _couponDiscountTitle = json['coupon_discount_title'];
    _paymentStatus = json['payment_status'];
    _orderStatus =
        json['order_status'] == 'cooking' || json['order_status'] == 'done'
            ? 'processing'
            : json['order_status'];
    _rejectReason = json['reject_reason'] ?? '';
    _totalTaxAmount = 0.00;
    _paymentMethod = json['payment_method'];
    _transactionReference = json['transaction_reference'];
    _deliveryAddressId = json['delivery_address_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deliveryManId = json['delivery_man_id'];
    _deliveryCharge = 0.00;
    _orderNote = json['order_note'];
    _deliveryRejectReason = json['delivery_reject_reason'];
    _detailsCount = json['details_count'];
    if (json['add_on_ids'] != null) {
      _addOnIds = json['add_on_ids'].cast<int>();
    }
    if (json['details'] != null) {
      _details = [];
      json['details'].forEach((v) {
        _details!.add(Details.fromJson(v));
      });
    }

    if (json['customer'] != null) {
      _customer = UserInfoModel.fromJson(json['customer']);
    }

    _deliveryMan = json['delivery_man'] != null
        ? DeliveryMan.fromJson(json['delivery_man'])
        : null;
    _sales =
        json['sales'] != null ? UserInfoModel.fromJson(json['sales']) : null;
    _orderType = json['order_type'];
    _deliveryTime = json['delivery_time'];
    _deliveryDate = json['delivery_date'];
    if (json['extra_discount'] != null) {
      try {
        _extraDiscount = double.parse(json['extra_discount']);
      } catch (e) {
        _extraDiscount = json['extra_discount'];
      }
    }
    _deliveryMan = json['delivery_man'] != null
        ? DeliveryMan.fromJson(json['delivery_man'])
        : null;
    _deliveryAddress = json['delivery_address'] != null
        ? DeliveryAddress.fromJson(json['delivery_address'])
        : null;
    _preparationTime = json['preparation_time'].toString();
    // print('order pre time -- $_preparationTime');
    _isProductAvailable =
        int.tryParse('${json['is_product_available']}') == 1 ? true : false;
    try {
      _orderPartialPayments = json["order_partial_payments"] == null
          ? []
          : List<OrderPartialPayment>.from(json["order_partial_payments"]!
              .map((x) => OrderPartialPayment.fromMap(x)));
    } catch (error) {
      debugPrint('order model-> _orderPartialPayments $error');
    }
    _isGuest = '${json["is_guest"]}'.contains('1');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['user_id'] = _userId;
    data['order_amount'] = _orderAmount;
    data['coupon_discount_amount'] = _couponDiscountAmount;
    data['coupon_discount_title'] = _couponDiscountTitle;
    data['payment_status'] = _paymentStatus;
    data['order_status'] = _orderStatus;
    data['customer'] = _customer;
    data['total_tax_amount'] = _totalTaxAmount;
    data['payment_method'] = _paymentMethod;
    data['transaction_reference'] = _transactionReference;
    data['delivery_address_id'] = _deliveryAddressId;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['delivery_man_id'] = _deliveryManId;
    data['delivery_charge'] = _deliveryCharge;
    data['order_note'] = _orderNote;
    data['add_on_ids'] = _addOnIds;
    data['details_count'] = _detailsCount;
    if (_details != null) {
      data['details'] = _details!.map((v) => v.toJson()).toList();
    }
    data['order_type'] = _orderType;
    data['delivery_time'] = _deliveryTime;
    data['delivery_date'] = _deliveryDate;
    data['extra_discount'] = _extraDiscount;
    if (_deliveryAddress != null) {
      data['delivery_address'] = _deliveryAddress!.toJson();
    }
    data['order_partial_payments'] = _orderPartialPayments;
    return data;
  }
}

class DeliveryAddress {
  int? _id;
  String? _addressType;
  String? _contactPersonNumber;
  String? _address;
  String? _latitude;
  String? _longitude;
  String? _createdAt;
  String? _updatedAt;
  int? _userId;
  String? _contactPersonName;

  DeliveryAddress(
      {int? id,
      String? addressType,
      String? contactPersonNumber,
      String? address,
      String? latitude,
      String? longitude,
      String? createdAt,
      String? updatedAt,
      int? userId,
      String? contactPersonName}) {
    _id = id;
    _addressType = addressType;
    _contactPersonNumber = contactPersonNumber;
    _address = address;
    _latitude = latitude;
    _longitude = longitude;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _userId = userId;
    _contactPersonName = contactPersonName;
  }

  int? get id => _id;
  String? get addressType => _addressType;
  String? get contactPersonNumber => _contactPersonNumber;
  String? get address => _address;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get userId => _userId;
  String? get contactPersonName => _contactPersonName;

  DeliveryAddress.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _addressType = json['address_type'];
    _contactPersonNumber = json['contact_person_number'];
    _address = json['address'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _userId = json['user_id'];
    _contactPersonName = json['contact_person_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['address_type'] = _addressType;
    data['contact_person_number'] = _contactPersonNumber;
    data['address'] = _address;
    data['latitude'] = _latitude;
    data['longitude'] = _longitude;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['user_id'] = _userId;
    data['contact_person_name'] = _contactPersonName;
    return data;
  }
}

class Details {
  int? _id;
  int? _productId;
  int? _orderId;
  double? _price;
  double? _discountOnProduct;
  String? _status;
  String? _discountType;
  int? _quantity;
  double? _taxAmount;
  String? _createdAt;
  String? _updatedAt;
  DeliveryMan? _deliveryMan;

  Details(
      {int? id,
      int? productId,
      int? orderId,
      double? price,
      String? productDetails,
      double? discountOnProduct,
      String? discountType,
      String? status,
      DeliveryMan? deliveryMan,
      int? quantity,
      double? taxAmount,
      String? createdAt,
      String? updatedAt,
      String? addOnIds,
      String? variant}) {
    _id = id;
    _productId = productId;
    _orderId = orderId;
    _price = price;
    _discountOnProduct = discountOnProduct;
    _discountType = discountType;
    _status = status;
    _deliveryMan = deliveryMan;
    _quantity = quantity;
    _taxAmount = taxAmount;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  int? get id => _id;
  int? get productId => _productId;
  int? get orderId => _orderId;
  double? get price => _price;
  double? get discountOnProduct => _discountOnProduct;
  String? get discountType => _discountType;
  String? get status => _status;
  int? get quantity => _quantity;
  DeliveryMan? get deliveryMan => _deliveryMan;
  double? get taxAmount => _taxAmount;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Details.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _productId = json['product_id'];
    _orderId = json['order_id'];
    _price = json['price'].toDouble();
    _discountOnProduct = json['discount_on_product'] != null
        ? json['discount_on_product'].toDouble()
        : 0;
    _discountType = json['discount_type'];
    _status = json['status'];
    _quantity = json['quantity'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deliveryMan = json['delivery_man'] != null
        ? DeliveryMan.fromJson(json['delivery_man'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['product_id'] = _productId;
    data['order_id'] = _orderId;
    data['price'] = _price;
    data['discount_on_product'] = _discountOnProduct;
    data['discount_type'] = _discountType;
    data['status'] = _status;
    data['quantity'] = _quantity;
    data['tax_amount'] = _taxAmount;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    if (_deliveryMan != null) {
      data['delivery_man'] = _deliveryMan!.toJson();
    }
    return data;
  }
}

class DeliveryMan {
  int? _id;
  String? _fName;
  String? _lName;
  String? _phone;
  String? _email;
  String? _identityNumber;
  String? _identityType;
  String? _identityImage;
  String? _image;
  String? _password;
  String? _createdAt;
  String? _updatedAt;
  String? _authToken;
  String? _fcmToken;
  List<Rating>? _rating;

  DeliveryMan(
      {int? id,
      String? fName,
      String? lName,
      String? phone,
      String? email,
      String? identityNumber,
      String? identityType,
      String? identityImage,
      String? image,
      String? password,
      String? createdAt,
      String? updatedAt,
      String? authToken,
      String? fcmToken,
      List<Rating>? rating}) {
    _id = id;
    _fName = fName;
    _lName = lName;
    _phone = phone;
    _email = email;
    _identityNumber = identityNumber;
    _identityType = identityType;
    _identityImage = identityImage;
    _image = image;
    _password = password;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _authToken = authToken;
    _fcmToken = fcmToken;
    _rating = rating;
  }

  int? get id => _id;
  String? get fName => _fName;
  String? get lName => _lName;
  String? get phone => _phone;
  String? get email => _email;
  String? get identityNumber => _identityNumber;
  String? get identityType => _identityType;
  String? get identityImage => _identityImage;
  String? get image => _image;
  String? get password => _password;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get authToken => _authToken;
  String? get fcmToken => _fcmToken;
  List<Rating>? get rating => _rating;

  DeliveryMan.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _fName = json['f_name'];
    _lName = json['l_name'];
    _phone = json['phone'];
    _email = json['email'];
    _identityNumber = json['identity_number'];
    _identityType = json['identity_type'];
    _identityImage = json['identity_image'];
    _image = json['image'];
    _password = json['password'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _authToken = json['auth_token'];
    _fcmToken = json['fcm_token'];
    if (json['rating'] != null) {
      _rating = [];
      json['rating'].forEach((v) {
        _rating!.add(Rating.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['f_name'] = _fName;
    data['l_name'] = _lName;
    data['phone'] = _phone;
    data['email'] = _email;
    data['identity_number'] = _identityNumber;
    data['identity_type'] = _identityType;
    data['identity_image'] = _identityImage;
    data['image'] = _image;
    data['password'] = _password;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['auth_token'] = _authToken;
    data['fcm_token'] = _fcmToken;
    if (_rating != null) {
      data['rating'] = _rating!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderPartialPayment {
  int? id;
  int? orderId;
  String? paidWith;
  double? paidAmount;
  double? dueAmount;

  OrderPartialPayment({
    this.id,
    this.orderId,
    this.paidWith,
    this.paidAmount,
    this.dueAmount,
  });

  factory OrderPartialPayment.fromJson(String str) =>
      OrderPartialPayment.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderPartialPayment.fromMap(Map<String, dynamic> json) =>
      OrderPartialPayment(
        id: json["id"],
        orderId: json["order_id"],
        paidWith: json["paid_with"],
        paidAmount: double.parse('${json["paid_amount"]}'),
        dueAmount: double.parse('${json["due_amount"]}'),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "order_id": orderId,
        "paid_with": paidWith,
        "paid_amount": paidAmount,
        "due_amount": dueAmount,
      };
}
