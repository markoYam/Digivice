import 'package:digivice_app/features/digimon/data/datasources/digimon_data_source.dart';
import 'package:digivice_app/features/digimon/data/models/digimon_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: DigimonLocalDataSource)
class DigimonLocalDataSourceImpl implements DigimonLocalDataSource {
  DigimonLocalDataSourceImpl();

  // For now, we'll use a simple in-memory cache
  List<DigimonModel> _cachedDigimon = [];

  @override
  Future<List<DigimonModel>> getAllDigimon() async {
    if (_cachedDigimon.isEmpty) {
      throw Exception('No cached data available');
    }
    return _cachedDigimon;
  }

  @override
  Future<DigimonModel> getDigimonById(int id) async {
    final digimon = _cachedDigimon.where((d) => d.id == id).firstOrNull;
    if (digimon == null) {
      throw Exception('Digimon not found in cache');
    }
    return digimon;
  }

  @override
  Future<void> cacheDigimon(List<DigimonModel> digimon) async {
    _cachedDigimon = digimon;
  }
}
