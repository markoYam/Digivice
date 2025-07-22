import 'package:digivice_app/features/digimon/domain/entities/digimon.dart';
import 'package:flutter/material.dart';

class DigimonBasicInfoWidget extends StatelessWidget {
  const DigimonBasicInfoWidget({
    required this.digimon,
    super.key,
  });

  final Digimon digimon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          digimon.name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.blue[700],
          ),
        ),
        const SizedBox(height: 8),
        _buildInfoChip(
          context,
          'Levels: ${digimon.levels.map((level) => level.level).join(", ")}',
          Colors.green,
        ),
        const SizedBox(height: 8),
        _buildInfoChip(
          context,
          'Types: ${digimon.types.map((type) => type.type).join(", ")}',
          Colors.orange,
        ),
        const SizedBox(height: 8),
        if (digimon.attributes.isNotEmpty) ...[
          _buildInfoChip(
            context,
            'Attributes: ${digimon.attributes.map((attr) => attr.attribute).join(", ")}',
            Colors.indigo,
          ),
          const SizedBox(height: 8),
        ],
        if (digimon.releaseDate.isNotEmpty) ...[
          _buildInfoChip(
            context,
            'Released: ${digimon.releaseDate}',
            Colors.teal,
          ),
          const SizedBox(height: 8),
        ],
        _buildInfoChip(
          context,
          'ID: ${digimon.id}',
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildInfoChip(
    BuildContext context,
    String text,
    MaterialColor color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: color[700],
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
