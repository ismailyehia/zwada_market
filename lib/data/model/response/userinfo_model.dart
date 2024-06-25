class UserInfoModel {
  int? id;
  String? name;
  String? fName;
  String? lName;
  String? userType;
  String? email;
  String? image;
  String? banner;
  String? code;
  String? gmLink;
  String? wpNumber;
  int? isPhoneVerified;
  int? successOrderCount;
  int? activeOrderCount;
  int? historyOrderCount;
  double? purchaseAmount;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? emailVerificationToken;
  String? phone;
  String? zoneName;
  String? cmFirebaseToken;
  double? point;
  String? loginMedium;
  String? referCode;
  double? walletBalance;

  UserInfoModel({
    this.id,
    this.name,
    this.fName,
    this.lName,
    this.userType,
    this.email,
    this.image,
    this.banner,
    this.code,
    this.gmLink,
    this.wpNumber,
    this.isPhoneVerified,
    this.successOrderCount,
    this.activeOrderCount,
    this.historyOrderCount,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.emailVerificationToken,
    this.phone,
    this.zoneName,
    this.point,
    this.purchaseAmount,
    this.cmFirebaseToken,
    this.loginMedium,
    this.referCode,
    this.walletBalance,
  });



  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    fName = json['f_name'];
    lName = json['l_name'];
    email = json['email'];
    image = json['image'];
    banner = json['banner'];
    code = json['code'] ?? '';
    gmLink = json['gm_link'] ?? '';
    wpNumber = json['wp_number'] ?? '';
    userType = json['user_type'];
    isPhoneVerified = json['is_phone_verified'];
    successOrderCount = json['successOrderCount'] ?? 0;
    activeOrderCount = json['activeOrderCount'] ?? 0;
    historyOrderCount = json['historyOrderCount'] ?? 0;
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    emailVerificationToken = json['email_verification_token'];
    phone = json['phone'];
    zoneName = json['zoneName'] ?? '';
    cmFirebaseToken = json['cm_firebase_token'];
    point = json['point'] != null ? json['point'].toDouble() : 0.00;
    purchaseAmount = json['purchaseAmount'] != null
        ? json['purchaseAmount'].toDouble()
        : 0.0;
    loginMedium = '${json['login_medium']}';
    referCode = json['refer_code'];
    walletBalance = double.tryParse('${json['wallet_balance']}');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['email'] = email;
    data['image'] = image;
    data['banner'] = banner;
    data['code'] = code;
    data['gm_link'] = gmLink;
    data['wp_number'] = wpNumber;
    data['user_type'] = userType;
    data['is_phone_verified'] = isPhoneVerified;
    data['successOrderCount'] = successOrderCount;
    data['activeOrderCount'] = activeOrderCount;
    data['historyOrderCount'] = historyOrderCount;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['email_verification_token'] = emailVerificationToken;
    data['phone'] = phone;
    data['zoneName'] = zoneName;
    data['cm_firebase_token'] = cmFirebaseToken;
    data['point'] = point;
    data['purchaseAmount'] = purchaseAmount;
    data['login_medium'] = loginMedium;
    data['refer_code'] = referCode;
    data['wallet_balance'] = walletBalance;
    return data;
  }


  @override
  String toString() {
    return 'UserInfoModel{id: $id, name: $name, email: $email, phone: $phone}';
  }
}


