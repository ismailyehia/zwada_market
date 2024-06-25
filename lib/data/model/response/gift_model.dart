import 'package:flutter_restaurant/data/model/response/product_model.dart';

class GiftModel {
  int? _id;
  Map<String, dynamic>? _name;
  Map<String, dynamic>? _description;
  String? _image;
  double? _pointPrice;
  int? _status;
  int? _stock;
  String? _disableAfter;
  String? _createdAt;
  String? _updatedAt;
  List<CategoryId>? _categoryIds;

  GiftModel({
    int? id,
    Map<String, dynamic>? name,
    Map<String, dynamic>? description,
    String? image,
    double? pointPrice,
    int? status,
    int? stock,
    String? disableAfter,
    String? createdAt,
    String? updatedAt,
    List<CategoryId>? categoryIds,
  }) {
    _id = id;
    _name = name;
    _description = description;
    _image = image;
    _pointPrice = pointPrice;
    _status = status;
    _stock = stock;
    _disableAfter = disableAfter;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _categoryIds = categoryIds;
  }

  int? get id => _id;
  Map<String, dynamic>? get name => _name;
  Map<String, dynamic>? get description => _description;
  String? get image => _image;
  double? get pointPrice => _pointPrice;
  int? get status => _status;
  int? get stock => _stock;
  String? get disableAfter => _disableAfter;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<CategoryId>? get categoryIds => _categoryIds;

  GiftModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _image = json['image'];
    _pointPrice = json['point_price'].toDouble();
    _status = json['status'];
    _stock = json['stock'];
    _disableAfter = json['disable_after'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];

    if (json['category_ids'] != null &&
        (json['category_ids'] as List).isNotEmpty) {
      _categoryIds = [];
      json['category_ids'].forEach((v) {
        _categoryIds!.add(CategoryId.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['description'] = _description;
    data['image'] = _image;
    data['point_price'] = _pointPrice;
    data['status'] = _status;
    data['stock'] = _stock;
    data['disable_after'] = _disableAfter;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    return data;
  }
}
