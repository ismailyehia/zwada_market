import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/gift_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/repository/product_repo.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:provider/provider.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo? productRepo;

  ProductProvider({required this.productRepo});

  // Latest products
  List<Product>? _popularProductList;
  List<Product>? _onSaleProductList;
  List<Product>? _featureProductList;
  List<Product>? _supplierProductList;
  List<GiftModel>? _giftList;
  List<Product>? _offerProductList;
  List<Product>? _latestProductList;
  bool _isLoading = false;
  int? _popularPageSize;
  int? _latestPageSize;
  List<String> _offsetList = [];
  // List<int> _variationIndex = [0];
  int? _quantity = 1;
  List<bool> _addOnActiveList = [];
  List<int?> _addOnQtyList = [];
  bool _seeMoreButtonVisible = true;
  int latestOffset = 1;
  int popularOffset = 1;
  int _cartIndex = -1;
  final List<String> _productTypeList = ['all', 'non_veg', 'veg'];
  List<List<bool?>> _selectedVariations = [];

  List<Product>? get popularProductList => _popularProductList;
  List<Product>? get onSaleProductList => _onSaleProductList;
  List<Product>? get featureProductList => _featureProductList;
  List<Product>? get supplierProductList => _supplierProductList;
  List<GiftModel>? get giftList => _giftList;
  List<Product>? get offerProductList => _offerProductList;
  List<Product>? get latestProductList => _latestProductList;
  bool get isLoading => _isLoading;
  int? get popularPageSize => _popularPageSize;
  int? get latestPageSize => _latestPageSize;
  int? get quantity => _quantity;
  List<bool> get addOnActiveList => _addOnActiveList;
  List<int?> get addOnQtyList => _addOnQtyList;
  bool get seeMoreButtonVisible => _seeMoreButtonVisible;
  int get cartIndex => _cartIndex;
  List<String> get productTypeList => _productTypeList;
  List<List<bool?>> get selectedVariations => _selectedVariations;

  Future<void> getLatestProductList(bool reload, String offset) async {
    if (reload || offset == '1' || _latestProductList == null) {
      latestOffset = 1;
      _offsetList = [];
      _latestProductList = null;
    }
    if (!_offsetList.contains(offset)) {
      _offsetList = [];
      _offsetList.add(offset);
      ApiResponse apiResponse = await productRepo!.getLatestProductList(offset);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        if (reload || offset == '1' || _latestProductList == null) {
          _latestProductList = [];
        }
        _latestProductList!.addAll(
            ProductModel.fromJson(apiResponse.response!.data).products!);
        _latestPageSize =
            ProductModel.fromJson(apiResponse.response!.data).totalSize;
        _isLoading = false;
        notifyListeners();
      } else {
        _latestProductList = [];

        showCustomSnackBar(apiResponse.error.toString());
      }
    } else {
      if (isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<bool> getPopularProductList(bool reload, String offset,
      {String type = 'all', bool isUpdate = false}) async {
    bool apiSuccess = false;
    if (reload || offset == '1') {
      popularOffset = 1;
      _offsetList = [];
      _popularProductList = null;
    }
    if (isUpdate) {
      notifyListeners();
    }

    if (!_offsetList.contains(offset)) {
      _offsetList = [];
      _offsetList.add(offset);
      ApiResponse apiResponse =
          await productRepo!.getPopularProductList(offset, type);

      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        apiSuccess = true;
        if (reload || offset == '1') {
          _popularProductList = [];
        }
        _popularProductList!.addAll(
            ProductModel.fromJson(apiResponse.response!.data).products!);
        _popularPageSize =
            ProductModel.fromJson(apiResponse.response!.data).totalSize;
        _isLoading = false;
        notifyListeners();
      } else {
        showCustomSnackBar(apiResponse.error.toString());
      }
    } else {
      if (isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
    return apiSuccess;
  }

  Future<bool> getOnSaleProductList(bool reload, String offset, String limit,
      {bool isUpdate = false}) async {
    bool apiSuccess = false;
    if (reload || offset == '1') {
      popularOffset = 1;
      _offsetList = [];
      _onSaleProductList = [];
    }
    if (isUpdate) {
      notifyListeners();
    }

    if (!_offsetList.contains(offset)) {
      _offsetList = [];
      _offsetList.add(offset);
      ApiResponse apiResponse =
          await productRepo!.getOnSaleProductList(offset, limit);

      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        apiSuccess = true;
        if (reload || offset == '1') {
          _onSaleProductList = [];
        }
        _onSaleProductList!.addAll(
            ProductModel.fromJson(apiResponse.response!.data).products!);
        _popularPageSize =
            ProductModel.fromJson(apiResponse.response!.data).totalSize;
        _isLoading = false;
        notifyListeners();
      } else {
        showCustomSnackBar(apiResponse.error.toString());
      }
    } else {
      if (isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
    return apiSuccess;
  }

  Future<bool> getOfferProductList(bool reload, String offset, String limit,
      {bool isUpdate = false}) async {
    bool apiSuccess = false;
    if (reload || offset == '1') {
      popularOffset = 1;
      _offsetList = [];
      _offerProductList = null;
    }
    if (isUpdate) {
      notifyListeners();
    }

    if (!_offsetList.contains(offset)) {
      _offsetList = [];
      _offsetList.add(offset);
      ApiResponse apiResponse =
          await productRepo!.getOfferProductList(offset, limit);

      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        apiSuccess = true;
        if (reload || offset == '1') {
          _offerProductList = [];
        }
        _offerProductList!.addAll(
            ProductModel.fromJson(apiResponse.response!.data).products!);
        _popularPageSize =
            ProductModel.fromJson(apiResponse.response!.data).totalSize;
        _isLoading = false;
        notifyListeners();
      } else {
        showCustomSnackBar(apiResponse.error.toString());
      }
    } else {
      if (isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
    return apiSuccess;
  }

  Future<bool> getFeatureProductList(bool reload,{bool isUpdate = false}) async {
    bool apiSuccess = false;
    if (reload || _featureProductList == null) {
      _featureProductList = [];
    }
    if (isUpdate) {
      notifyListeners();
    }

    ApiResponse apiResponse = await productRepo!.getFeatureProductList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      apiSuccess = true;
      if (reload) {
        _featureProductList = [];
      }
      _featureProductList!
          .addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
      _isLoading = false;
      notifyListeners();
    } else {
      showCustomSnackBar(apiResponse.error.toString());
    }
    return apiSuccess;
  }

  // Future<bool> getSupplierProductList(bool reload, String? supplierId,{bool isUpdate = false}) async {
  //   bool apiSuccess = false;
  //   if (reload || _supplierProductList == null) {
  //     _supplierProductList = [];
  //   }
  //   if (isUpdate) {
  //     notifyListeners();
  //   }

  //   print('Supplier ID: $supplierId');

  //   ApiResponse apiResponse =
  //       await productRepo!.getSupplierProductList(supplierId);
  //   if (apiResponse.response != null &&
  //       apiResponse.response!.statusCode == 200) {
  //     apiSuccess = true;
  //     if (reload) {
  //       _supplierProductList = [];
  //     }
  //     _supplierProductList!
  //         .addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
  //     _isLoading = false;
  //     notifyListeners();
  //   } else {
  //     showCustomSnackBar(apiResponse.error.toString());
  //   }
  //   return apiSuccess;
  // }


  Future<bool> getSupplierProductList(bool reload, String? supplierId,{bool isUpdate = false}) async {
    bool apiSuccess = false;
    if (reload || _supplierProductList == null) {
      _supplierProductList = [];
    }
    if (isUpdate) {
      notifyListeners();
    }

    print('Supplier ID: $supplierId');

    if (supplierId != null) {
    ApiResponse apiResponse = await productRepo!.getSupplierProductList(supplierId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      apiSuccess = true;
      if (reload) {
        _supplierProductList = [];
      }
      _supplierProductList!
          .addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
      _isLoading = false;
      notifyListeners();
    } else {
      showCustomSnackBar(apiResponse.error.toString());
    }
    return apiSuccess;

  } 
  else {
    // Handle the case when supplierId is null
    print('Supplier ID is null');
    // Optionally, you can return false or throw an error to indicate the failure
    return false;
  }
    
  }








  Future<bool> getGiftList(bool reload, {bool isUpdate = false}) async {
    bool apiSuccess = false;
    if (reload || _giftList == null) {
      _giftList = [];
    }
    if (isUpdate) {
      notifyListeners();
    }

    ApiResponse apiResponse = await productRepo!.getgiftList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      apiSuccess = true;
      if (reload) {
        _giftList = [];
      }
      for (var giftData in apiResponse.response!.data) {
        _giftList!.add(GiftModel.fromJson(giftData));
      }
      _isLoading = false;
      notifyListeners();
    } else {
      showCustomSnackBar(apiResponse.error.toString());
    }
    return apiSuccess;
  }

  void showBottomLoader() {
    _isLoading = true;
    notifyListeners();
  }

  void initData(Product? product, CartModel? cart) {
    _selectedVariations = [];
    _addOnQtyList = [];
    _addOnActiveList = [];

    if (cart != null) {
      _quantity = cart.quantity;
    } else {
      _quantity = 1;
    }
  }

  void setAddOnQuantity(bool isIncrement, int index) {
    if (isIncrement) {
      _addOnQtyList[index] = _addOnQtyList[index]! + 1;
    } else {
      _addOnQtyList[index] = _addOnQtyList[index]! - 1;
    }
    notifyListeners();
  }

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity = _quantity! + 1;
    } else {
      _quantity = _quantity! - 1;
    }
    notifyListeners();
  }

  void setQuantityInt(int qty) {
    _quantity = qty;
    notifyListeners();
  }

  void setCartVariationIndex(
      int index, int i, Product? product, bool isMultiSelect) {
    if (!isMultiSelect) {
      for (int j = 0; j < _selectedVariations[index].length; j++) {
        if (product!.variations![index].isRequired!) {
          _selectedVariations[index][j] = j == i;
        } else {
          if (_selectedVariations[index][j]!) {
            _selectedVariations[index][j] = false;
          } else {
            _selectedVariations[index][j] = j == i;
          }
        }
      }
    } else {
      if (!_selectedVariations[index][i]! &&
          selectedVariationLength(_selectedVariations, index) >=
              product!.variations![index].max!) {
        showCustomSnackBar(
            '${getTranslated('maximum_variation_for', Get.context!)} ${product.variations![index].name} ${getTranslated('is', Get.context!)} ${product.variations![index].max}',
            isToast: true);
      } else {
        _selectedVariations[index][i] = !_selectedVariations[index][i]!;
      }
    }
    notifyListeners();
  }

  int selectedVariationLength(List<List<bool?>> selectedVariations, int index) {
    int length = 0;
    for (bool? isSelected in selectedVariations[index]) {
      if (isSelected!) {
        length++;
      }
    }
    return length;
  }

  int setExistInCart(Product product, {bool notify = true}) {
    final cartProvider = Provider.of<CartProvider>(Get.context!, listen: false);

    _cartIndex = cartProvider.isExistInCart(product.id, null);
    if (_cartIndex != -1) {
      _quantity = cartProvider.cartList[_cartIndex]!.quantity;
    }
    return _cartIndex;
  }

  void addAddOn(bool isAdd, int index) {
    _addOnActiveList[index] = isAdd;
    notifyListeners();
  }

  void moreProduct(BuildContext context) {
    int pageSize;
    pageSize = (latestPageSize! / 10).ceil();

    if (latestOffset < pageSize) {
      latestOffset++;
      showBottomLoader();
      getLatestProductList(false, latestOffset.toString());
    }
  }

  void seeMoreReturn() {
    latestOffset = 1;
    _seeMoreButtonVisible = true;
  }

  bool checkStock(Product product, {int? quantity}) {
    int? stock;
    if (product.branchProduct?.stockType != 'unlimited' &&
        product.branchProduct?.stock != null &&
        product.branchProduct?.soldQuantity != null) {
      stock =
          product.branchProduct!.stock! - product.branchProduct!.soldQuantity!;
      if (quantity != null) {
        stock = stock - quantity;
      }
    }
    return stock == null || (stock > 0);
  }
}



