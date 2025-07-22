import 'package:digivice_app/features/digimon/domain/entities/digimon.dart';
import 'package:digivice_app/features/digimon/presentation/widgets/digimon_basic_info_widget.dart';
import 'package:digivice_app/features/digimon/presentation/widgets/digimon_description_widget.dart';
import 'package:digivice_app/features/digimon/presentation/widgets/digimon_evolution_widget.dart';
import 'package:digivice_app/features/digimon/presentation/widgets/digimon_fields_widget.dart';
import 'package:digivice_app/features/digimon/presentation/widgets/digimon_image_widget.dart';
import 'package:digivice_app/features/digimon/presentation/widgets/digimon_skills_widget.dart';
import 'package:flutter/material.dart';

class DigimonDetailWidget extends StatelessWidget {
  const DigimonDetailWidget({
    required this.digimon,
    super.key,
  });

  final Digimon digimon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context),
            const SizedBox(height: 16),

            // Image and Basic Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DigimonImageWidget(digimon: digimon),
                const SizedBox(width: 16),
                Expanded(
                  child: DigimonBasicInfoWidget(digimon: digimon),
                ),
              ],
            ),

            // Description
            const SizedBox(height: 16),
            DigimonDescriptionWidget(digimon: digimon),

            // Additional Details Section
            const SizedBox(height: 16),

            // Skills Section
            DigimonSkillsWidget(digimon: digimon),
            const SizedBox(height: 12),

            // Fields Section
            DigimonFieldsWidget(digimon: digimon),
            const SizedBox(height: 12),

            // Evolution Lines Section
            DigimonEvolutionWidget(digimon: digimon),

            // Success timestamp
            const SizedBox(height: 12),
            _buildTimestamp(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.catching_pokemon,
          color: Colors.blue[600],
          size: 28,
        ),
        const SizedBox(width: 8),
        Text(
          'Current Digimon',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.blue[600],
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildTimestamp(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.check_circle,
          color: Colors.green[600],
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          'Retrieved at: ${DateTime.now().toString().substring(0, 19)}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.green[600],
                fontStyle: FontStyle.italic,
              ),
        ),
      ],
    );
  }
}
