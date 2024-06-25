class BrandModel {
  int? _id;
  Map<String, dynamic>? _name;
  Map<String, dynamic>? _description;
  String? _createdAt;
  String? _updatedAt;
  String? _image;
  String? _bannerImage;

  BrandModel(
      {int? id,
        Map<String, dynamic>? name,
        Map<String, dynamic>? description,
        int? parentId,
        int? position,
        int? status,
        String? createdAt,
        String? updatedAt,
        String? image,
        String? bannerImage,
      }) {
    _id = id;
    _name = name;
    _description = description;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _image = image;
    _bannerImage = bannerImage;
  }

  int? get id => _id;
  Map<String, dynamic>? get name => _name;
  Map<String, dynamic>? get description => _description;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get image => _image;
  String? get bannerImage => _bannerImage;

  BrandModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'] ?? 0;
    _name = json['name'] ?? {'en':''};
    _description = json['description'] ?? {'en':''};
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _image = json['logo'] ?? '';
    _bannerImage = json['banner_image'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['description'] = _description;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['logo'] = _image;
    data['banner_image'] = _bannerImage;
    return data;
  }
}
