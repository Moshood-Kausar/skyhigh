import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:skyhigh/services/base_api.dart';
import 'package:dartz/dartz.dart';
import 'package:skyhigh/services/base_url.dart';
import 'package:skyhigh/services/models/charts_model.dart';
import 'package:http/http.dart' as http;

BaseUrl url = BaseUrl();

class ApiService extends BaseApi {
  @override
  Future<Either<String, List<ChartsModel>>> chartApi() async {
    try {
      final response = await http.post(
        Uri.parse(url.baseUrl),
        body: jsonEncode({"angular_test": "angular-developer"}),
      );

      final res = jsonDecode(response.body);
      final responseBody = res as List;
      final finalResponse =
          responseBody.map((e) => ChartsModel.fromJson(e)).toList();
      // ChartsModel charts = chartsModelFromJson(response.body);

      return right(finalResponse);
    } catch (_) {
      return left('An error occured');
    }
  }
}
