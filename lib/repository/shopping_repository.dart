import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:practical_manektech/helper/api_helper.dart';

import '../helper/exceptions.dart';
import '../model/product_list_model.dart';

class ShoppingRepository extends ApiHelper {
  Future<ProductResponse> getProducts(Map<String, dynamic> params) async {
    try {
      final response = await post(body: jsonEncode(params).toString());
      final products = fromJson(response.body);
      debugPrint(response.body);
      if (response.statusCode == successResponse) {
        return products;
      } else {
        throw CustomException(products.message!);
      }
    } catch (e, s) {
      debugPrint("we got $e $s");
      rethrow;
    }
  }
}
