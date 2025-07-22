import 'package:digivice_app/features/digimon/presentation/bloc/digimon_cubit.dart';
import 'package:digivice_app/features/digimon/presentation/bloc/digimon_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DigimonConfigurationWidget extends StatelessWidget {
  const DigimonConfigurationWidget({
    required this.nicknameController,
    super.key,
  });

  final TextEditingController nicknameController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DigimonCubit, DigimonState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Digimon Service Configuration',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nicknameController,
                  enabled: !state.isAutomaticConsumptionActive,
                  decoration: const InputDecoration(
                    labelText: 'User Name',
                    hintText: 'Enter your user name for the service',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                _buildControlButtons(context, state),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlButtons(BuildContext context, DigimonState state) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: !state.isAutomaticConsumptionActive &&
                    nicknameController.text.isNotEmpty
                ? () {
                    context
                        .read<DigimonCubit>()
                        .startDigimonConsumption(nicknameController.text);
                  }
                : null,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start (30s)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: state.isAutomaticConsumptionActive
                ? () {
                    context.read<DigimonCubit>().stopDigimonConsumption();
                  }
                : null,
            icon: const Icon(Icons.stop),
            label: const Text('Stop Auto'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
