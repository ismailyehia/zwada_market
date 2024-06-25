

class PlaceOrderBody {
  List<Cart>? _cart;
  double? _orderAmount;

  PlaceOrderBody copyWith({String? paymentMethod, String? transactionReference}) {
    return this;
  }

  PlaceOrderBody(
      {required List<Cart> cart,
        required double orderAmount,
      }) {
    _cart = cart;
    _orderAmount = orderAmount;
  }

  List<Cart>? get cart => _cart;
  
  double? get orderAmount => _orderAmount;

  PlaceOrderBody.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      _cart = [];
      json['cart'].forEach((v) {
        _cart!.add(Cart.fromJson(v));
      });
    }
    _orderAmount = json['order_amount'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (_cart != null) {
      data['cart'] = _cart!.map((v) => v.toJson()).toList();
    }
    data['order_amount'] = _orderAmount;

    return data;
  }
}

class Cart {
  String? _productId;
  String? _price;
  double? _discountAmount;
  int? _quantity;
  double? _taxAmount;

  Cart(
    String productId,
    String price,
    double? discountAmount,
    int? quantity,
    double? taxAmount,
    ) {
    _productId = productId;
    _price = price;
    _discountAmount = discountAmount;
    _quantity = quantity;
    _taxAmount = taxAmount;
  }

  String? get productId => _productId;
  String? get price => _price;
  double? get discountAmount => _discountAmount;
  int? get quantity => _quantity;
  double? get taxAmount => _taxAmount;

  Cart.fromJson(Map<String, dynamic> json) {
    _productId = json['product_id'];
    _price = json['price'];

    _discountAmount = json['discount_amount'];
    _quantity = json['quantity'];
    _taxAmount = json['tax_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = _productId;
    data['price'] = _price;
    data['discount_amount'] = _discountAmount;
    data['quantity'] = _quantity;
    data['tax_amount'] = _taxAmount;
    return data;
  }
}

class OrderVariation {
  String? name;
  OrderVariationValue? values;

  OrderVariation({this.name, this.values});

  OrderVariation.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    values =
    json['values'] != null ? OrderVariationValue.fromJson(json['values']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (values != null) {
      data['values'] = values!.toJson();
    }
    return data;
  }
}
class OrderVariationValue {
  List<String?>? label;

  OrderVariationValue({this.label});

  OrderVariationValue.fromJson(Map<String, dynamic> json) {
    label = json['label'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    return data;
  }
}

class OfflinePaymentInfo{
  final String? paymentName;
  final String? paymentNote;
  final List<Map<String, dynamic>?>? methodFields;
  final List<Map<String, String>>? methodInformation;

  OfflinePaymentInfo(
      {this.paymentName,
        this.paymentNote,
        this.methodFields,
        this.methodInformation});


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_name'] = paymentName;
    data['method_fields'] = methodFields;
    data['payment_note'] = paymentNote;
    data['method_information'] = methodInformation;
    return data;
  }
}
