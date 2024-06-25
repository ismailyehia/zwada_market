class SignUpModel {
  String? fName;
  String? lName;
  String? userType;
  String? name;
  String? phone;
  String? email;
  String? password;
  String? address;

  SignUpModel({
    this.fName,
    this.lName,
    this.userType,
    this.name,
    this.phone,
    this.email = '',
    this.password,
    this.address = '',
  });

  SignUpModel.fromJson(Map<String, dynamic> json) {
    fName = json['f_name'];
    lName = json['l_name'];
    userType = json['user_type'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['user_type'] = userType;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['password'] = password;
    data['address'] = address;
    return data;
  }
}
