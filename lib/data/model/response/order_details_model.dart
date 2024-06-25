import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';

class OrderDetailsModel {
  int? _id;
  int? _productId;
  int? _orderId;
  double? _price;
  Product? _productDetails;
  List<Variation>? _variations;
  List<OldVariation>? _oldVariations;
  double? _discountOnProduct;
  String? _discountType;
  String? _status;
  int? _quantity;
  double? _taxAmount;
  String? _createdAt;
  String? _updatedAt;
  List<int>? _addOnIds;
  List<double>? _addOnPrices;
  List<int>? _addOnQtys;
  double? _addOnTaxAmount;
  OrderModel? _orderModel;

  OrderDetailsModel(
      {int? id,
        int? productId,
        int? orderId,
        double? price,
        Product? productDetails,
        List<Variation>? variations,
        List<OldVariation>? oldVariations,
        double? discountOnProduct,
        String? discountType,
        int? quantity,
        double? taxAmount,
        String? createdAt,
        String? updatedAt,
        List<int>? addOnIds,
        List<int>? addOnQtys,
        double? addOnTaxAmount,
        List<double>? addOnPrices,
        OrderModel? orderModel,


      }) {
    _id = id;
    _productId = productId;
    _orderId = orderId;
    _price = price;
    _productDetails = productDetails;
    _oldVariations = oldVariations;
    _variations = variations;
    _discountOnProduct = discountOnProduct;
    _discountType = discountType;
    _status = status;
    _quantity = quantity;
    _taxAmount = taxAmount;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _addOnIds = addOnIds;
    _addOnQtys = addOnQtys;
    _addOnTaxAmount = addOnTaxAmount;
    _addOnPrices = addOnPrices;
    _orderModel = orderModel;
  }

  int? get id => _id;
  int? get productId => _productId;
  int? get orderId => _orderId;
  double? get price => _price;
  Product? get productDetails => _productDetails;
  List<Variation>? get variations => _variations;
  List<OldVariation>? get oldVariations => _oldVariations;
  double? get discountOnProduct => _discountOnProduct;
  String? get discountType => _discountType;
  String? get status => _status;
  int? get quantity => _quantity;
  double? get taxAmount => _taxAmount;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<int>? get addOnIds => _addOnIds;
  List<int>? get addOnQtys => _addOnQtys;
  double? get addOnTaxAmount => _addOnTaxAmount;
  List<double>? get addOnPrices => _addOnPrices;
  OrderModel? get orderModel => _orderModel;

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _productId = json['product_id'];
    _orderId = json['order_id'];
    _price = json['price'].toDouble();
    _productDetails = Product.fromJson(json['product_details']);

    if (json['variation'] != null && json['variation'].isNotEmpty) {
      if(json['variation'][0]['values'] != null) {
        _variations = [];
        json['variation'].forEach((v) {
          _variations!.add(Variation.fromJson(v));
        });
      }else{
        _oldVariations = [];
        json['variation'].forEach((v) {
          _oldVariations!.add(OldVariation.fromJson(v));
        });
      }
    }

    _discountOnProduct = json['discount_on_product'].toDouble();
    _discountType = json['discount_type'];
    _status = json['status'];
    _quantity = json['quantity'];
    _taxAmount = json['tax_amount'].toDouble();
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _orderModel = OrderModel.fromJson(json['order']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['product_id'] = _productId;
    data['order_id'] = _orderId;
    data['price'] = _price;
    data['discount_on_product'] = _discountOnProduct;
    data['quantity'] = _quantity;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['order'] = _orderModel;
    return data;
  }
}

class OldVariation {
  String? type;
  double? price;

  OldVariation({this.type, this.price});

  OldVariation.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    price = double.tryParse('${json['price']}');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['price'] = price;
    return data;
  }
}