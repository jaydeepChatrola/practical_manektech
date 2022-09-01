import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:practical_manektech/helper/exceptions.dart';
import 'package:practical_manektech/helper/string_constant.dart';

class ApiHelper {
  final String baseUrl =
      "http://205.134.254.135/~mobile/MtProject/public/api/product_list.php";
  final String jsonHeaderName = "Content-Type";
  final String jsonHeaderValue = "application/json; charset=UTF-8";
  final String jsonAuthenticationName = "Authorization";
  final String token = "token";
  final int successResponse = 200;
  final String _tokenValue =
      "eyJhdWQiOiI1IiwianRpIjoiMDg4MmFiYjlmNGU1MjIyY2MyNjc4Y2FiYTQwOGY2MjU4Yzk5YTllN2ZkYzI0NWQ4NDMxMTQ4ZWMz";

  Map<String, String> _getJsonHeader() {
    var header = <String, String>{};
    header[jsonHeaderName] = jsonHeaderValue;
    return header;
  }

  Future<Map<String, String>> getAuthorizedHeader() async {
    final header = _getJsonHeader();
    header[token] = _tokenValue;
    return header;
  }

  Future<http.Response> post(
      {dynamic body,
      Encoding? encoding,
      bool closeDialogOnTimeout = true}) async {
    var headers = await getAuthorizedHeader();
    var response = await http
        .post(Uri.parse(baseUrl),
            headers: headers, body: body, encoding: encoding)
        .timeout(const Duration(seconds: 45), onTimeout: () {
      throw CustomException(StringConstant.timeoutMessage);
    });
    return response;
  }
}
