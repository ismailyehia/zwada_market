import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/brand_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/repository/brand_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';

class BrandProvider extends ChangeNotifier {
  final BrandRepo? brandRepo;

  BrandProvider({required this.brandRepo});

  List<BrandModel>? _brandList;
  List<Product>? _brandProductList;
  bool _pageFirstIndex = true;
  bool _pageLastIndex = false;
  bool _isLoading = false;

  List<BrandModel>? get brandList => _brandList;
  List<Product>? get brandProductList => _brandProductList;
  bool get pageFirstIndex => _pageFirstIndex;
  bool get pageLastIndex => _pageLastIndex;
  bool get isLoading => _isLoading;

  Future<void> getBrandsList(bool reload) async {
    if(_brandList == null || reload) {
      _isLoading = true;
      ApiResponse apiResponse = await brandRepo!.getBrandList();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _brandList = [];
        apiResponse.response!.data.forEach((category) => _brandList!.add(BrandModel.fromJson(category)));
        if(_brandList!.isNotEmpty){
        }

      } else {
        ApiChecker.checkApi(apiResponse);
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  void getBrandProductList(String? brandID, {String? name}) async {
    _brandProductList = null;
    notifyListeners();
    ApiResponse apiResponse = await brandRepo!.getBrandProductList(brandID, name);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _brandProductList = [];
      apiResponse.response!.data.forEach(
        (brandProduct) => _brandProductList!.add(Product.fromJson(brandProduct))
      );
      notifyListeners();
    } else {
      showCustomSnackBar(apiResponse.error.toString());
    }
  }

  int _selectBrand = -1;

  int get selectBrand => _selectBrand;

  updateSelectBrand(int index) {
    _selectBrand = index;
    notifyListeners();
  }
  updateProductCurrentIndex(int index, int totalLength) {
    if(index > 0) {
      _pageFirstIndex = false;
      notifyListeners();
    }else{
      _pageFirstIndex = true;
      notifyListeners();
    }
    if(index + 1  == totalLength) {
      _pageLastIndex = true;
      notifyListeners();
    }else {
      _pageLastIndex = false;
      notifyListeners();
    }
  }
}
