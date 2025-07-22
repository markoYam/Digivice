
import 'package:digivice_app/core/constants/api_constants.dart';
import 'package:digivice_app/core/error/exceptions.dart';
import 'package:digivice_app/features/digimon/data/datasources/digimon_data_source.dart';
import 'package:digivice_app/features/digimon/data/models/digimon_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: DigimonRemoteDataSource)
class DigimonRemoteDataSourceImpl implements DigimonRemoteDataSource {
  const DigimonRemoteDataSourceImpl(this.dio);

  final Dio dio;

  @override
  Future<String> generateEncryptedKey() async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        ApiConstants.softtokenEndpoint,
      );

      if (response.statusCode == 200) {
        final success = response.data?['Success'] as bool;
        if (!success) {
          throw ServerException();
        }
        return response.data?['Response'] as String;
      } else {
        throw ServerException();
      }
    } on DioException {
      throw NetworkException();
    } on Exception {
      throw ServerException();
    }
  }

  /// Consumes the Digimon service with the provided OTP and encrypted key
  @override
  Future<DigimonModel> consumeDigimonService({
    required String otp,
    required String encryptedKey,
    required String username,
  }) async {
    try {
      final requestData = {
        'otp': otp,
        'encryptedKey': encryptedKey,
        'username': username,
      };

      final response = await dio.request<dynamic>(
        ApiConstants.digimonEndpoint,
        data: requestData,
        options: Options(
          method: 'POST',
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode != 200) {
        if(response.data != null && response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          final errorMessage = data['Response'] as String? ?? 'Unknown error';
          throw Exception(errorMessage);
        }
        throw ServerException();
      }

      final responseData = response.data;
      if (responseData == null) {
        throw ServerException();
      }

      // Verificar si la respuesta tiene el formato esperado con Success/Response
      final responseMap = responseData as Map<String, dynamic>;
      
      // Verificar si es una respuesta exitosa
      final isSuccess = responseMap['Success'] as bool? ?? false;
      if (!isSuccess) {
        throw ServerException();
      }
      
      // Extraer los datos del digimon del campo Response
      final digimonData = responseMap['Response'] as Map<String, dynamic>?;
      if (digimonData == null) {
        throw ServerException();
      }

      // Parsear respuesta a modelo Digimon
      return DigimonModel.fromJson(digimonData);
    } on DioException {
      throw NetworkException();
    } on Exception {
      throw ServerException();
    }
  }
}
