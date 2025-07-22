import 'package:equatable/equatable.dart';

class DigimonImage extends Equatable {
  const DigimonImage({
    required this.href,
    required this.transparent,
  });

  final String href;
  final bool transparent;

  @override
  List<Object?> get props => [href, transparent];
}

class DigimonLevel extends Equatable {
  const DigimonLevel({
    required this.id,
    required this.level,
  });

  final int id;
  final String level;

  @override
  List<Object?> get props => [id, level];
}

class DigimonType extends Equatable {
  const DigimonType({
    required this.id,
    required this.type,
  });

  final int id;
  final String type;

  @override
  List<Object?> get props => [id, type];
}

class DigimonAttribute extends Equatable {
  const DigimonAttribute({
    required this.id,
    required this.attribute,
  });

  final int id;
  final String attribute;

  @override
  List<Object?> get props => [id, attribute];
}

class DigimonField extends Equatable {
  const DigimonField({
    required this.id,
    required this.field,
    required this.image,
  });

  final int id;
  final String field;
  final String image;

  @override
  List<Object?> get props => [id, field, image];
}

class DigimonDescription extends Equatable {
  const DigimonDescription({
    required this.origin,
    required this.language,
    required this.description,
  });

  final String origin;
  final String language;
  final String description;

  @override
  List<Object?> get props => [origin, language, description];
}

class DigimonSkill extends Equatable {
  const DigimonSkill({
    required this.id,
    required this.skill,
    required this.translation,
    required this.description,
  });

  final int id;
  final String skill;
  final String translation;
  final String description;

  @override
  List<Object?> get props => [id, skill, translation, description];
}

class DigimonEvolution extends Equatable {
  const DigimonEvolution({
    required this.id,
    required this.digimon,
    required this.condition,
    required this.image,
    required this.url,
  });

  final int id;
  final String digimon;
  final String condition;
  final String image;
  final String url;

  @override
  List<Object?> get props => [id, digimon, condition, image, url];
}

// Clase principal Digimon con toda la estructura completa
class Digimon extends Equatable {
  const Digimon({
    required this.id,
    required this.name,
    required this.xAntibody,
    required this.images,
    required this.levels,
    required this.types,
    required this.attributes,
    required this.fields,
    required this.releaseDate,
    required this.descriptions,
    required this.skills,
    required this.priorEvolutions,
    required this.nextEvolutions,
  });

  final int id;
  final String name;
  final bool xAntibody;
  final List<DigimonImage> images;
  final List<DigimonLevel> levels;
  final List<DigimonType> types;
  final List<DigimonAttribute> attributes;
  final List<DigimonField> fields;
  final String releaseDate;
  final List<DigimonDescription> descriptions;
  final List<DigimonSkill> skills;
  final List<DigimonEvolution> priorEvolutions;
  final List<DigimonEvolution> nextEvolutions;

  // Métodos de conveniencia para acceder a propiedades comunes
  String get primaryImageUrl => images.isNotEmpty ? images.first.href : '';
  String get primaryLevel => levels.isNotEmpty ? levels.first.level : 'Unknown';
  String get primaryType => types.isNotEmpty ? types.first.type : 'Unknown';
  String get primaryAttribute =>
      attributes.isNotEmpty ? attributes.first.attribute : 'Unknown';
  String? get englishDescription {
    try {
      final englishDesc = descriptions.firstWhere(
        (desc) => desc.language == 'en_us',
      );
      return englishDesc.description;
    } on Exception catch (_) {
      return null;
    }
  }

  String? get japaneseDescription {
    try {
      final japaneseDesc = descriptions.firstWhere(
        (desc) => desc.language == 'jap',
      );
      return japaneseDesc.description;
    } on Exception catch (_) {
      return null;
    }
  }

  @override
  List<Object?> get props => [
    id,
    name,
    xAntibody,
    images,
    levels,
    types,
    attributes,
    fields,
    releaseDate,
    descriptions,
    skills,
    priorEvolutions,
    nextEvolutions,
  ];
}
