import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/body/review_body_model.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';

class ProductRepo {
  final DioClient? dioClient;

  ProductRepo({
    required this.dioClient,
  });

  Future<ApiResponse> getLatestProductList(String offset) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.latestProductUri}?limit=12&&offset=$offset',
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getPopularProductList(String offset, String type) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.popularProductUri}?limit=12&&offset=$offset&product_type=$type',
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getOnSaleProductList(String offset, String limit) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.onSaleProductUri}?limit=$limit&&offset=$offset',
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getOfferProductList(String offset, String limit) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.offerProductUri}?limit=$limit&&offset=$offset',
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getFeatureProductList() async {
    try {
      final response = await dioClient!.get(AppConstants.featureProductUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSupplierProductList(String? supplierId) async {
    try {
      final response =
          await dioClient!.get(AppConstants.supplierProductUri + supplierId!);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getgiftList() async {
    try {
      final response = await dioClient!.get(AppConstants.giftUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> submitReview(ReviewBody reviewBody) async {
    try {
      final response =
          await dioClient!.post(AppConstants.reviewUri, data: reviewBody);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> submitDeliveryManReview(ReviewBody reviewBody) async {
    try {
      final response = await dioClient!
          .post(AppConstants.deliverManReviewUri, data: reviewBody);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
