import 'package:digivice_app/features/digimon/domain/entities/digimon.dart';
import 'package:flutter/material.dart';

class DigimonSkillsWidget extends StatelessWidget {
  const DigimonSkillsWidget({
    required this.digimon,
    this.maxSkillsToShow = 3,
    super.key,
  });

  final Digimon digimon;
  final int maxSkillsToShow;

  @override
  Widget build(BuildContext context) {
    if (digimon.skills.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.flash_on,
                size: 20,
                color: Colors.red[600],
              ),
              const SizedBox(width: 8),
              Text(
                'Skills (${digimon.skills.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red[600],
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...digimon.skills.take(maxSkillsToShow).map(
                (skill) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• ${skill.skill} (${skill.translation})',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.red[700],
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        '  ${skill.description}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.red[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ),
          if (digimon.skills.length > maxSkillsToShow)
            Text(
              '... and ${digimon.skills.length - maxSkillsToShow} more skills',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.red[500],
                    fontStyle: FontStyle.italic,
                  ),
            ),
        ],
      ),
    );
  }
}
