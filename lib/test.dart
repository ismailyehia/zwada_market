import 'dart:convert';

import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class Test {
  late final SharedPreferences sharedPreferences;
  Future<List<dynamic>> getData() async {
    var url = Uri.parse('https://zawada.app/api/v1/customer/info');

    String? token = sharedPreferences.getString(AppConstants.token);
    print(" token is  $token");

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      print(data);
      return data;
    } else {
      print('error:   ${response.statusCode}');
      return [];
    }
  }
}
