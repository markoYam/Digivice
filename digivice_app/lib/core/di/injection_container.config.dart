// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_remote_config/firebase_remote_config.dart' as _i627;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/digimon/data/datasources/digimon_data_source.dart'
    as _i174;
import '../../features/digimon/data/datasources/digimon_local_data_source.dart'
    as _i809;
import '../../features/digimon/data/datasources/digimon_remote_data_source.dart'
    as _i84;
import '../../features/digimon/data/repositories/digimon_repository_impl.dart'
    as _i440;
import '../../features/digimon/domain/repositories/digimon_repository.dart'
    as _i10;
import '../../features/digimon/domain/usecases/consume_digimon_service.dart'
    as _i691;
import '../../features/digimon/domain/usecases/decrypt_message.dart' as _i1050;
import '../../features/digimon/domain/usecases/generate_totp.dart' as _i330;
import '../../features/digimon/domain/usecases/get_encrypted_key.dart'
    as _i1020;
import '../../features/digimon/domain/usecases/get_ntp_time.dart' as _i478;
import '../../features/digimon/domain/usecases/get_softtoken_encrypted_key.dart'
    as _i240;
import '../../features/digimon/presentation/bloc/digimon_cubit.dart' as _i509;
import '../encryption/native_decryption_service.dart' as _i490;
import '../firebase/firebase_initialization_service.dart' as _i250;
import '../firebase/firebase_module.dart' as _i1055;
import '../firebase/firebase_remote_config_service.dart' as _i1071;
import '../network/configurable_http_service.dart' as _i184;
import '../network/network_info.dart' as _i932;
import '../network/network_module.dart' as _i200;
import '../security/totp_service.dart' as _i783;
import '../services/softtoken_service.dart' as _i878;
import '../time/ntp_time_service.dart' as _i335;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final firebaseModule = _$FirebaseModule();
    final networkModule = _$NetworkModule();
    gh.factory<_i627.FirebaseRemoteConfig>(() => firebaseModule.remoteConfig);
    gh.singleton<_i490.NativeDecryptionService>(
      () => _i490.NativeDecryptionService(),
    );
    gh.singleton<_i361.Dio>(() => networkModule.dio);
    gh.singleton<_i335.NtpTimeService>(() => _i335.NtpTimeService());
    gh.factory<_i478.GetNtpTime>(
      () => _i478.GetNtpTime(gh<_i335.NtpTimeService>()),
    );
    gh.singleton<_i783.TotpService>(
      () => _i783.TotpService(gh<_i335.NtpTimeService>()),
    );
    gh.factory<_i1071.FirebaseRemoteConfigService>(
      () => _i1071.FirebaseRemoteConfigServiceImpl(
        gh<_i627.FirebaseRemoteConfig>(),
      ),
    );
    gh.factory<_i932.NetworkInfo>(() => const _i932.NetworkInfoImpl());
    gh.singleton<_i878.SofttokenService>(
      () => _i878.SofttokenService(
        gh<_i361.Dio>(),
        gh<_i1071.FirebaseRemoteConfigService>(),
      ),
    );
    gh.factory<_i174.DigimonLocalDataSource>(
      () => _i809.DigimonLocalDataSourceImpl(),
    );
    gh.factory<_i174.DigimonRemoteDataSource>(
      () => _i84.DigimonRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.singleton<_i184.ConfigurableHttpService>(
      () => _i184.ConfigurableHttpService(
        gh<_i361.Dio>(),
        gh<_i1071.FirebaseRemoteConfigService>(),
      ),
    );
    gh.factory<_i1050.DecryptMessage>(
      () => _i1050.DecryptMessage(gh<_i490.NativeDecryptionService>()),
    );
    gh.factory<_i240.GetSofttokenEncryptedKey>(
      () => _i240.GetSofttokenEncryptedKey(gh<_i878.SofttokenService>()),
    );
    gh.factory<_i330.GenerateTotp>(
      () => _i330.GenerateTotp(gh<_i783.TotpService>()),
    );
    gh.factory<_i10.DigimonRepository>(
      () => _i440.DigimonRepositoryImpl(
        remoteDataSource: gh<_i174.DigimonRemoteDataSource>(),
        localDataSource: gh<_i174.DigimonLocalDataSource>(),
        networkInfo: gh<_i932.NetworkInfo>(),
        firebaseRemoteConfigService: gh<_i1071.FirebaseRemoteConfigService>(),
        nativeDecryptionService: gh<_i490.NativeDecryptionService>(),
        totpService: gh<_i783.TotpService>(),
      ),
    );
    gh.factory<_i250.FirebaseInitializationService>(
      () => _i250.FirebaseInitializationService(
        gh<_i1071.FirebaseRemoteConfigService>(),
        gh<_i184.ConfigurableHttpService>(),
      ),
    );
    gh.factory<_i691.ConsumeDigimonService>(
      () => _i691.ConsumeDigimonService(gh<_i10.DigimonRepository>()),
    );
    gh.factory<_i1020.GetEncryptedKey>(
      () => _i1020.GetEncryptedKey(gh<_i10.DigimonRepository>()),
    );
    gh.factory<_i509.DigimonCubit>(
      () => _i509.DigimonCubit(
        consumeDigimonService: gh<_i691.ConsumeDigimonService>(),
      ),
    );
    return this;
  }
}

class _$FirebaseModule extends _i1055.FirebaseModule {}

class _$NetworkModule extends _i200.NetworkModule {}
