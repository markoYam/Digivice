import 'dart:async';
import 'dart:developer';

import 'package:digivice_app/core/error/failures.dart';
import 'package:digivice_app/features/digimon/domain/entities/digimon.dart';
import 'package:digivice_app/features/digimon/domain/usecases/consume_digimon_service.dart';
import 'package:digivice_app/features/digimon/presentation/bloc/digimon_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class DigimonCubit extends Cubit<DigimonState> {
  DigimonCubit({
    required this.consumeDigimonService,
  }) : super(const DigimonState());

  final ConsumeDigimonService consumeDigimonService;

  Timer? _consumptionTimer;

  /// Inicia el consumo automático del servicio /digimon cada 30 segundos
  Future<void> startDigimonConsumption(String nickname) async {
    if (state.isAutomaticConsumptionActive) {
      log('Cannot start consumption: Already active');
      return;
    }

    log('🚀 Starting Digimon consumption for: $nickname');

    emit(
      state.copyWith(
        status: DigimonStatus.consuming,
        nickname: nickname,
        isAutomaticConsumptionActive: true,
      ),
    );

    // Detener cualquier timer previo
    _consumptionTimer?.cancel();

    // Ejecutar la primera llamada inmediatamente
    await _executeDigimonConsumption(nickname);

    // Crear timer para consumo automático cada 30 segundos
    _consumptionTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      await _executeDigimonConsumption(nickname);
    });

    log('✅ Automatic consumption timer started successfully');
  }

  /// Ejecuta una llamada individual al servicio Digimon
  Future<void> _executeDigimonConsumption(String nickname) async {
    log('⏰ Executing Digimon service consumption...');
    
    final result = await consumeDigimonService(
      ConsumeDigimonServiceParams(nickname: nickname),
    );

    result.fold(
      (Failure failure) {
        log('❌ Error consuming Digimon service: $failure');
        emit(
          state.copyWith(
            status: DigimonStatus.error,
            errorMessage: 'Error consuming Digimon service: ${failure.runtimeType}',
          ),
        );
      },
      (Digimon digimon) {
        emit(
          state.copyWith(
            status: DigimonStatus.loading,
          ),
        );
        log('✅ Digimon consumed successfully: ${digimon.name}');
        emit(
          state.copyWith(
            status: DigimonStatus.success,
            currentDigimon: digimon,
            isAutomaticConsumptionActive: true, // Mantener activo
          ),
        );
      },
    );
  }

  /// Detiene el consumo automático del servicio /digimon
  Future<void> stopDigimonConsumption() async {
    log('🛑 Stopping automatic Digimon consumption...');
    
    emit(state.copyWith(status: DigimonStatus.loading));

    // Cancelar el timer
    _consumptionTimer?.cancel();
    _consumptionTimer = null;

    emit(
      state.copyWith(
        status: DigimonStatus.success,
        isAutomaticConsumptionActive: false,
      ),
    );

    log('✅ Automatic consumption stopped successfully');
  }

  /// Consume el servicio una sola vez (modo manual)
  Future<void> consumeDigimonOnce(String nickname) async {
    if (state.status != DigimonStatus.success) {
      log('Cannot consume service: Sistema no inicializado correctamente');
      return;
    }

    emit(state.copyWith(status: DigimonStatus.loading));

    final result = await consumeDigimonService(
      ConsumeDigimonServiceParams(nickname: nickname),
    );

    result.fold(
      (failure) {
        log('Failed to consume Digimon service: $failure');
        emit(
          state.copyWith(
            status: DigimonStatus.error,
            errorMessage: 'Failed to consume Digimon service',
          ),
        );
      },
      (digimon) {
        log('Digimon consumed successfully: ${digimon.name}');
        emit(
          state.copyWith(
            status: DigimonStatus.success,
            currentDigimon: digimon,
            nickname: nickname,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    // Cancelar el timer antes de cerrar el cubit
    _consumptionTimer?.cancel();
    return super.close();
  }
}
