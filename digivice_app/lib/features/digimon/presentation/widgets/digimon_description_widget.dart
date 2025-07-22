import 'package:digivice_app/features/digimon/domain/entities/digimon.dart';
import 'package:flutter/material.dart';

class DigimonDescriptionWidget extends StatelessWidget {
  const DigimonDescriptionWidget({
    required this.digimon,
    super.key,
  });

  final Digimon digimon;

  @override
  Widget build(BuildContext context) {
    if (digimon.englishDescription == null ||
        digimon.englishDescription!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description,
                size: 20,
                color: Colors.blue[600],
              ),
              const SizedBox(width: 8),
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[600],
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            digimon.englishDescription!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.blue[700],
                  height: 1.4,
                ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
