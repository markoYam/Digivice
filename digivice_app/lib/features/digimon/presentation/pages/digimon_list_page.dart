import 'package:digivice_app/core/di/injection_container.dart';
import 'package:digivice_app/features/digimon/presentation/bloc/digimon_cubit.dart';
import 'package:digivice_app/features/digimon/presentation/bloc/digimon_state.dart';
import 'package:digivice_app/features/digimon/presentation/widgets/digimon_configuration_widget.dart';
import 'package:digivice_app/features/digimon/presentation/widgets/digimon_detail_widget.dart';
import 'package:digivice_app/features/digimon/presentation/widgets/digimon_status_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DigimonListPage extends StatefulWidget {
  const DigimonListPage({super.key});

  @override
  State<DigimonListPage> createState() => _DigimonListPageState();
}

class _DigimonListPageState extends State<DigimonListPage> {
  final TextEditingController _nicknameController = TextEditingController(
    text: 'TestUser',
  );

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digivice - App'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocProvider(
        create: (_) => getIt<DigimonCubit>(),
        child: BlocBuilder<DigimonCubit, DigimonState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // DigimonServiceStatusWidget(state: state),
                  if (state.isAutomaticConsumptionActive) ...[
                    const SizedBox(height: 12),
                    _buildAutomaticConsumptionStatus(context),
                  ],
                  const SizedBox(height: 16),
                  // Configuration Section
                  DigimonConfigurationWidget(
                    nicknameController: _nicknameController,
                  ),
                  const SizedBox(height: 16),

                  // Current Digimon Display
                  if (state.currentDigimon != null) ...[
                    DigimonDetailWidget(digimon: state.currentDigimon!),
                    const SizedBox(height: 16),
                    // ,
                  ],

                  // Loading indicator
                  if (state.status == DigimonStatus.loading) ...[
                    const SizedBox(height: 16),
                    const DigimonLoadingWidget(),
                  ],

                  // Error display
                  if (state.status == DigimonStatus.error) ...[
                    const SizedBox(height: 16),
                    DigimonErrorWidget(state: state),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAutomaticConsumptionStatus(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.blue[600]!,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Automatic consumption active (every 30 seconds)',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.blue[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
