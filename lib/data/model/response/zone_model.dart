class ZoneModel {
  int? _id;
  String? _image;
  String? _name;
  String? _description;
  String? _code;

  ZoneModel({
    int? id,
    String? image,
    String? name,
    String? code,
  }) {
    _id = id;
    _image = image;
    _name = name;
    _description = description;
    _code = code;
  }

  int? get id => _id;
  String? get image => _image;
  String? get name => _name;
  String? get description => _description;
  String? get code => _code;

  ZoneModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _image = json['image'];
    _name = json['name'];
    _description = json['description'] ?? '';
    _code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['image'] = _image;
    data['name'] = _name;
    data['code'] = _code;
    return data;
  }
}
