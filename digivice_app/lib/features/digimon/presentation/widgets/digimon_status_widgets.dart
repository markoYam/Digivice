import 'package:digivice_app/features/digimon/presentation/bloc/digimon_state.dart';
import 'package:flutter/material.dart';

class DigimonLoadingWidget extends StatelessWidget {
  const DigimonLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class DigimonErrorWidget extends StatelessWidget {
  const DigimonErrorWidget({
    required this.state,
    super.key,
  });

  final DigimonState state;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red[700],
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              'Error',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.red[700],
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              state.errorMessage,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
