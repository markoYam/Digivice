import 'package:digivice_app/core/constants/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NetworkModule {
  @singleton
  Dio get dio => _createDio();

  static Dio _createDio() {
    final dio = Dio();
    
    _configureDio(dio);
    
    return dio;
  }
  
  static void _configureDio(Dio dio) {
    dio.options = BaseOptions(
      baseUrl: ApiConstants.defaultBaseUrl,
      connectTimeout: const Duration(
        milliseconds: ApiConstants.connectTimeout,
      ),
      receiveTimeout: const Duration(
        milliseconds: ApiConstants.receiveTimeout,
      ),
      headers: {
        ApiConstants.contentType: ApiConstants.applicationJson,
      },
    );
  }
}
