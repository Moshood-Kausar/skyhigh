
import 'package:dartz/dartz.dart';
import 'package:skyhigh/services/models/charts_model.dart';

abstract class BaseApi {
  Future<Either<String , List<ChartsModel>>>chartApi();
 
}