import 'package:digivice_app/features/digimon/domain/entities/digimon.dart';
import 'package:flutter/material.dart';

class DigimonEvolutionWidget extends StatelessWidget {
  const DigimonEvolutionWidget({
    required this.digimon,
    this.maxEvolutionsToShow = 3,
    super.key,
  });

  final Digimon digimon;
  final int maxEvolutionsToShow;

  @override
  Widget build(BuildContext context) {
    if (digimon.priorEvolutions.isEmpty && digimon.nextEvolutions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_up,
                size: 20,
                color: Colors.green[600],
              ),
              const SizedBox(width: 8),
              Text(
                'Evolution Lines',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[600],
                    ),
              ),
            ],
          ),
          if (digimon.priorEvolutions.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildEvolutionSection(
              context,
              'Previous Evolutions',
              digimon.priorEvolutions,
              maxEvolutionsToShow,
            ),
          ],
          if (digimon.nextEvolutions.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildEvolutionSection(
              context,
              'Next Evolutions',
              digimon.nextEvolutions,
              maxEvolutionsToShow,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEvolutionSection(
    BuildContext context,
    String title,
    List<DigimonEvolution> evolutions,
    int maxToShow,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title (${evolutions.length}):',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.green[700],
              ),
        ),
        const SizedBox(height: 4),
        ...evolutions.take(maxToShow).map(
              (evolution) => Text(
                '• ${evolution.digimon}${evolution.condition.isNotEmpty ? ' (${evolution.condition})' : ''}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.green[600],
                    ),
              ),
            ),
        if (evolutions.length > maxToShow)
          Text(
            '... and ${evolutions.length - maxToShow} more',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.green[500],
                  fontStyle: FontStyle.italic,
                ),
          ),
      ],
    );
  }
}
