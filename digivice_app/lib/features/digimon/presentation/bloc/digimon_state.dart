import 'package:digivice_app/features/digimon/domain/entities/digimon.dart';
import 'package:equatable/equatable.dart';

class DigimonState extends Equatable {
  const DigimonState({
    this.status = DigimonStatus.initial,
    this.errorMessage = '',
    this.isAutomaticConsumptionActive = false,
    this.currentDigimon,
    this.nickname = '',
  });

  final DigimonStatus status;
  final String errorMessage;
  final bool isAutomaticConsumptionActive;
  final Digimon? currentDigimon;
  final String nickname;

  DigimonState copyWith({
    DigimonStatus? status,
    String? errorMessage,
    bool? isAutomaticConsumptionActive,
    Digimon? currentDigimon,
    String? nickname,
  }) {
    return DigimonState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isAutomaticConsumptionActive:
          isAutomaticConsumptionActive ?? this.isAutomaticConsumptionActive,
      currentDigimon: currentDigimon ?? this.currentDigimon,
      nickname: nickname ?? this.nickname,
    );
  }

  @override
  List<Object?> get props => [
    status,
  ];
}

enum DigimonStatus { initial, loading, success, error, consuming }
