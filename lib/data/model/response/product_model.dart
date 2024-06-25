class ProductModel {
  int? _totalSize;
  String? _limit;
  String? _offset;
  List<Product>? _products;

  ProductModel(
      {int? totalSize,
      String? limit,
      String? offset,
      List<Product>? products}) {
    _totalSize = totalSize;
    _limit = limit;
    _offset = offset;
    _products = products;
  }

  int? get totalSize => _totalSize;
  String? get limit => _limit;
  String? get offset => _offset;
  List<Product>? get products => _products;

  ProductModel.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _limit = json['limit']?.toString();
    _offset = json['offset']?.toString();
    if (json['products'] != null) {
      _products = [];
      json['products'].forEach((v) {
        _products!.add(Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = _totalSize;
    data['limit'] = _limit;
    data['offset'] = _offset;
    if (_products != null) {
      data['products'] = _products!.map((v) => v.toJson()).toList();
    }
    return data;
  }


 // Method to filter products by supplier ID
  List<Product>? getProductsBySupplierId(int supplierId) {
    return _products?.where((product) => product.supplierId == supplierId).toList();
  }

  



}




class Product {
  int? _id;
  int? _supplierId;
  int? _displayName;
  Map<String, dynamic>? _name;
  String? _offerName;
  Map<String, dynamic>? _description;
  Map<String, dynamic>? _information;
  String? _origin;
  String? _image;
  double? _price;
  double? _offerPrice;
  List<Variation>? _variations;
  List<Product>? _subProducts;
  Product? _product;
  List<AddOns>? _addOns;
  double? _tax;
  String? _availableTimeStarts;
  String? _availableTimeEnds;
  int? _status;
  int? _isActive;
  String? _expiryDate;
  String? _disableAfter;
  String? _createdAt;
  String? _updatedAt;
  List<CategoryId>? _categoryIds;
  int? _brandId;
  List<ChoiceOption>? _choiceOptions;
  double? _discount;
  String? _discountType;
  String? _taxType;
  int? _setMenu;
  int? _minQty;
  int? _maxQty;
  List<Rating>? _rating;
  BranchProduct? _branchProduct;
  double? _mainPrice;

  Product({
    int? id,
    int? supplierId,
    Map<String, dynamic>? name,
    Map<String, dynamic>? description,
    Map<String, dynamic>? information,
    String? origin,
    String? image,
    double? price,
    List<Variation>? variations,
    List<Product>? subProducts,
    Product? product,
    List<AddOns>? addOns,
    double? tax,
    String? availableTimeStarts,
    String? availableTimeEnds,
    int? status,
    int? isActive,
    String? createdAt,
    String? updatedAt,
    List<String>? attributes,
    List<CategoryId>? categoryIds,
    int? brandId,
    List<ChoiceOption>? choiceOptions,
    double? discount,
    String? discountType,
    String? taxType,
    int? setMenu,
    int? minQty,
    int? maxQty,
    List<Rating>? rating,
    BranchProduct? branchProduct,
    double? mainPrice,
  }) {
    _id = id;
    _supplierId = supplierId;
    _displayName = displayName;
    _name = name;
    _offerName = offerName;
    _description = description;
    _information = information;
    _origin = origin;
    _image = image;
    _price = price;
    _offerPrice = offerPrice;
    _variations = variations;
    _subProducts = subProducts;
    _product = product;
    _addOns = addOns;
    _tax = tax;
    _availableTimeStarts = availableTimeStarts;
    _availableTimeEnds = availableTimeEnds;
    _status = status;
    _isActive = isActive;
    _expiryDate = expiryDate;
    _disableAfter = disableAfter;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _categoryIds = categoryIds;
    _brandId = brandId;
    _choiceOptions = choiceOptions;
    _discount = discount;
    _discountType = discountType;
    _taxType = taxType;
    _setMenu = setMenu;
    _minQty = minQty;
    _maxQty = maxQty;
    _rating = rating;
    _branchProduct = branchProduct;
    _mainPrice = mainPrice;
  }

  int? get id => _id;
  int? get supplierId => _supplierId;
  int? get displayName => _displayName;
  Map<String, dynamic>? get name => _name;
  String? get offerName => _offerName;
  Map<String, dynamic>? get description => _description;
  Map<String, dynamic>? get information => _information;
  String? get origin => _origin;
  String? get image => _image;
  double? get price => _price;
  double? get offerPrice => _offerPrice;
  List<Variation>? get variations => _variations;
  List<Product>? get subProducts => _subProducts;
  Product? get product => _product;
  List<AddOns>? get addOns => _addOns;
  double? get tax => _tax;
  String? get availableTimeStarts => _availableTimeStarts;
  String? get availableTimeEnds => _availableTimeEnds;
  int? get status => _status;
  int? get isActive => _isActive;
  String? get expiryDate => _expiryDate;
  String? get disableAfter => _disableAfter;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<CategoryId>? get categoryIds => _categoryIds;
  int? get brandId => _brandId;
  double? get discount => _discount;
  String? get discountType => _discountType;
  String? get taxType => _taxType;
  int? get setMenu => _setMenu;
  int? get minQty => _minQty;
  int? get maxQty => _maxQty;
  List<Rating>? get rating => _rating;
  String? productType;
  BranchProduct? get branchProduct => _branchProduct;

  Product.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _supplierId = json['supplier_id'];
    _displayName =
        json['supplier'] != null ? json['supplier']['display_name'] : 0;
    _name = json['name'] ??
        (json['product'] != null ? json['product']['name'] : {});
    _minQty = json['quantity'] ?? json['min_qty'] ?? 1;
    _maxQty = json['max_qty'] ?? 999999999999;
    _description = json['description'] ??
        (json['product'] != null ? json['product']['description'] : {});
    _information = json['information'] ??
        (json['product'] != null ? json['product']['information'] : {});
    _origin = json['origin'] ??
        (json['product'] != null ? json['product']['origin'] : '');

    _image = json['image'] ??
        (json['product'] != null ? json['product']['image'] : '');

    _price = json['price'].toDouble();

    _status = json['status'] ?? 0;
    _isActive = json['is_available'] ?? 0;
    _expiryDate = json['expiry_date'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];

    if (json['product'] != null && json['product']['category_ids'] != null) {
      _categoryIds = [];
      json['product']['category_ids'].forEach((v) {
        _categoryIds!.add(CategoryId.fromJson(v));
      });
    }

    if (json['category_ids'] != null &&
        (json['category_ids'] as List).isNotEmpty) {
      _categoryIds = [];
      json['category_ids'].forEach((v) {
        _categoryIds!.add(CategoryId.fromJson(v));
      });
    }

    _brandId = json['brand_id'] ??
        (json['product'] != null ? json['product']['brand_id'] : 0);

    if (json['products'] != null && (json['products'] as List).isNotEmpty) {
      _disableAfter = json['disable_after'];
      _offerName = json['offer_name'];
      _offerPrice = json['offer_price'].toDouble();
      _subProducts = [];
      json['products'].forEach((v) {
        _subProducts!.add(Product.fromJson(v));
      });
    }

    _discount = json['discount'].toDouble();
    _mainPrice = double.tryParse('${json['price']}');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['min_qty'] = _minQty;
    data['max_qty'] = _maxQty;
    data['offer_name'] = _offerName;
    data['description'] = _description;
    data['information'] = _information;
    data['origin'] = _origin;
    data['image'] = _image;
    data['price'] = _price;
    data['offer_price'] = _offerPrice;
    if (_variations != null) {
      data['variations'] = _variations!.map((v) => v.toJson()).toList();
    }

    if (_addOns != null) {
      data['add_ons'] = _addOns!.map((v) => v.toJson()).toList();
    }
    data['tax'] = _tax;
    data['available_time_starts'] = _availableTimeStarts;
    data['available_time_ends'] = _availableTimeEnds;
    data['status'] = _status;
    data['is_available'] = _isActive;
    data['expiry_date'] = _expiryDate;
    data['disable_after'] = _disableAfter;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['brand_id'] = _brandId;
    if (_categoryIds != null) {
      data['category_ids'] = _categoryIds!.map((v) => v.toJson()).toList();
    }
    if (_choiceOptions != null) {
      data['choice_options'] = _choiceOptions!.map((v) => v.toJson()).toList();
    }
    data['discount'] = _discount;
    data['discount_type'] = _discountType;
    data['tax_type'] = _taxType;
    data['set_menu'] = _setMenu;
    data['main_price'] = _mainPrice;
    if (_rating != null) {
      data['rating'] = _rating!.map((v) => v.toJson()).toList();
    }
    data['branch_product'] = _branchProduct;
    return data;
  }
}

class BranchProduct {
  int? id;
  int? productId;
  int? branchId;
  double? price;
  bool? isAvailable;
  List<Variation>? variations;
  double? discount;
  String? discountType;
  int? stock;
  int? soldQuantity;
  String? stockType;

  BranchProduct({
    this.id,
    this.productId,
    this.branchId,
    this.isAvailable,
    this.variations,
    this.price,
    this.discount,
    this.discountType,
    this.stockType,
    this.soldQuantity,
    this.stock,
  });

  BranchProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    branchId = json['branch_id'];
    price = double.tryParse('${json['price']}');
    isAvailable = ('${json['is_available']}' == '1') ||
        '${json['is_available']}' == 'true';
    if (json['variations'] != null) {
      variations = [];
      json['variations'].forEach((v) {
        if (!v.containsKey('price')) {
          variations!.add(Variation.fromJson(v));
        }
      });
    }
    discount = json['discount'].toDouble();
    discountType = json['discount_type'];
    stockType = json['stock_type'];
    stock = json['stock'];
    soldQuantity = json['sold_quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['branch_id'] = branchId;
    data['is_available'] = isAvailable;
    data['variations'] = variations;
    data['price'] = price;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['stock'] = stock;
    data['stock_type'] = stockType;
    data['sold_quantity'] = soldQuantity;
    return data;
  }
}

class VariationValue {
  String? level;
  double? optionPrice;

  VariationValue({this.level, this.optionPrice});

  VariationValue.fromJson(Map<String, dynamic> json) {
    level = json['label'];
    optionPrice = double.parse(json['optionPrice'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = level;
    data['optionPrice'] = optionPrice;
    return data;
  }
}

class Variation {
  Map<String, dynamic>? name;
  int? min;
  int? max;
  bool? isRequired;
  bool? isMultiSelect;
  List<VariationValue>? variationValues;

  Variation({
    this.name,
    this.min,
    this.max,
    this.isRequired,
    this.variationValues,
    this.isMultiSelect,
  });

  Variation.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isMultiSelect = '${json['type']}' == 'multi';
    min = isMultiSelect! ? int.parse(json['min'].toString()) : 0;
    max = isMultiSelect! ? int.parse(json['max'].toString()) : 0;
    isRequired = '${json['required']}' == 'on';
    if (json['values'] != null) {
      variationValues = [];
      json['values'].forEach((v) {
        variationValues!.add(VariationValue.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = isMultiSelect! ? 'multi' : 'single';
    data['min'] = min;
    data['max'] = max;
    data['required'] = isRequired! ? 'on' : 'off';
    if (variationValues != null) {
      data['values'] = variationValues!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class AddOns {
  int? _id;
  Map<String, dynamic>? _name;
  double? _price;
  String? _createdAt;
  String? _updatedAt;
  double? _tax; // percentage

  AddOns(
      {int? id,
      Map<String, dynamic>? name,
      double? price,
      String? createdAt,
      String? updatedAt,
      double? tax}) {
    _id = id;
    _name = name;
    _price = price;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _tax = tax;
  }

  int? get id => _id;
  Map<String, dynamic>? get name => _name;
  double? get price => _price;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  double? get tax => _tax;

  AddOns.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _price = json['price'].toDouble();
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _tax = double.tryParse('${json['tax']}');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['price'] = _price;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['tax'] = _tax;
    return data;
  }
}

class CategoryId {
  String? _id;

  CategoryId({String? id}) {
    _id = id;
  }

  String? get id => _id;

  CategoryId.fromJson(Map<String, dynamic> json) {
    _id = json['id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    return data;
  }
}

class ChoiceOption {
  Map<String, dynamic>? _name;
  String? _title;
  List<String>? _options;

  ChoiceOption(
      {Map<String, dynamic>? name, String? title, List<String>? options}) {
    _name = name;
    _title = title;
    _options = options;
  }

  Map<String, dynamic>? get name => _name;
  String? get title => _title;
  List<String>? get options => _options;

  ChoiceOption.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _title = json['title'];
    _options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = _name;
    data['title'] = _title;
    data['options'] = _options;
    return data;
  }
}

class Rating {
  String? _average;
  int? _productId;

  Rating({String? average, int? productId}) {
    _average = average;
    _productId = productId;
  }

  String? get average => _average;
  int? get productId => _productId;

  Rating.fromJson(Map<String, dynamic> json) {
    _average = json['average'];
    _productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['average'] = _average;
    data['product_id'] = _productId;
    return data;
  }
}



