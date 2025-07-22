import 'package:digivice_app/features/digimon/domain/entities/digimon.dart';
import 'package:flutter/material.dart';

class DigimonImageWidget extends StatelessWidget {
  const DigimonImageWidget({
    required this.digimon,
    this.size = 120,
    super.key,
  });

  final Digimon digimon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: digimon.images.isNotEmpty
            ? Image.network(
                digimon.images.first.href,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.catching_pokemon,
                    size: 60,
                    color: Colors.grey,
                  );
                },
              )
            : const Icon(
                Icons.catching_pokemon,
                size: 60,
                color: Colors.grey,
              ),
      ),
    );
  }
}
