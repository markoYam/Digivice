import 'package:digivice_app/features/digimon/domain/entities/digimon.dart';
import 'package:digivice_app/features/digimon/presentation/widgets/digimon_card_widget.dart';
import 'package:flutter/material.dart';

class DigimonListWidget extends StatelessWidget {
  const DigimonListWidget({
    required this.digimon,
    super.key,
  });

  final List<Digimon> digimon;

  @override
  Widget build(BuildContext context) {
    if (digimon.isEmpty) {
      return const Center(
        child: Text(
          'No Digimon found',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: digimon.length,
      itemBuilder: (context, index) {
        return DigimonCardWidget(
          digimon: digimon[index],
          onTap: () {
            // TODO: Navigate to detail page
          },
        );
      },
    );
  }
}
