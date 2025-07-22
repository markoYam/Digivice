import 'package:digivice_app/features/digimon/data/models/digimon_model.dart';

abstract class DigimonRemoteDataSource {
  Future<String> generateEncryptedKey();
  Future<DigimonModel> consumeDigimonService({
    required String otp,
    required String encryptedKey,
    required String username,
  });
}

abstract class DigimonLocalDataSource {
  Future<List<DigimonModel>> getAllDigimon();
  Future<DigimonModel> getDigimonById(int id);
  Future<void> cacheDigimon(List<DigimonModel> digimon);
}
