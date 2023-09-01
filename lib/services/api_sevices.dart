import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:skyhigh/services/base_api.dart';
import 'package:skyhigh/services/base_url.dart';
import 'package:skyhigh/services/models/charts_model.dart';
import 'package:http/http.dart' as http;

BaseUrl url = BaseUrl();

class ApiService extends BaseApi {
  @override
  Future<ChartsModel> chartApi() async {
    try {
      final response = await http.post(
        Uri.parse(url.baseUrl),
        body: jsonEncode({"angular_test": "angular-developer"}),
      );

      final res = jsonDecode(response.body);
      if (response.statusCode == 200 && res['status'] == true) {
        ChartsModel charts = chartsModelFromJson(response.body);

        return ChartsModel(
          profit: charts.profit,
          quantity: charts.quantity,
          sales: charts.sales,
          orderDate: charts.orderDate,
        );
      }

      return ChartsModel();
    } on SocketException catch (_) {
      return ChartsModel();
    } on TimeoutException catch (_) {
      return ChartsModel();
    } catch (e) {
      return ChartsModel();
    }
  }
}
