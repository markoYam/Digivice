import 'package:digivice_app/features/digimon/presentation/bloc/digimon_state.dart';
import 'package:flutter/material.dart';

class DigimonServiceStatusWidget extends StatelessWidget {
  const DigimonServiceStatusWidget({
    required this.state,
    super.key,
  });

  final DigimonState state;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 12),
            _buildSuccessStatus(context),
            if (state.isAutomaticConsumptionActive) ...[
              const SizedBox(height: 12),
              _buildAutomaticConsumptionStatus(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.info_outline,
          color: Colors.amber[600],
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          'Service Status',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.amber[600],
              ),
        ),
      ],
    );
  }

  Widget _buildSuccessStatus(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green[600],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Successfully retrieved Digimon from service',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
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
