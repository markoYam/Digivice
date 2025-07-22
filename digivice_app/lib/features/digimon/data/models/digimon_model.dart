import 'package:digivice_app/features/digimon/domain/entities/digimon.dart';

class DigimonModel extends Digimon {
  const DigimonModel({
    required super.id,
    required super.name,
    required super.xAntibody,
    required super.images,
    required super.levels,
    required super.types,
    required super.attributes,
    required super.fields,
    required super.releaseDate,
    required super.descriptions,
    required super.skills,
    required super.priorEvolutions,
    required super.nextEvolutions,
  });

  factory DigimonModel.fromJson(Map<String, dynamic> json) {
    return DigimonModel(
      id: json['id'] as int,
      name: json['name'] as String,
      xAntibody: json['xAntibody'] as bool? ?? false,
      images: (json['images'] as List<dynamic>? ?? [])
          .map(
            (image) =>
                DigimonImageModel.fromJson(image as Map<String, dynamic>),
          )
          .toList(),
      levels: (json['levels'] as List<dynamic>? ?? [])
          .map(
            (level) =>
                DigimonLevelModel.fromJson(level as Map<String, dynamic>),
          )
          .toList(),
      types: (json['types'] as List<dynamic>? ?? [])
          .map(
            (type) => DigimonTypeModel.fromJson(type as Map<String, dynamic>),
          )
          .toList(),
      attributes: (json['attributes'] as List<dynamic>? ?? [])
          .map(
            (attribute) => DigimonAttributeModel.fromJson(
              attribute as Map<String, dynamic>,
            ),
          )
          .toList(),
      fields: (json['fields'] as List<dynamic>? ?? [])
          .map(
            (field) =>
                DigimonFieldModel.fromJson(field as Map<String, dynamic>),
          )
          .toList(),
      releaseDate: json['releaseDate'] as String? ?? '',
      descriptions: (json['descriptions'] as List<dynamic>? ?? [])
          .map(
            (description) => DigimonDescriptionModel.fromJson(
              description as Map<String, dynamic>,
            ),
          )
          .toList(),
      skills: (json['skills'] as List<dynamic>? ?? [])
          .map(
            (skill) =>
                DigimonSkillModel.fromJson(skill as Map<String, dynamic>),
          )
          .toList(),
      priorEvolutions: (json['priorEvolutions'] as List<dynamic>? ?? [])
          .map(
            (evolution) => DigimonEvolutionModel.fromJson(
              evolution as Map<String, dynamic>,
            ),
          )
          .toList(),
      nextEvolutions: (json['nextEvolutions'] as List<dynamic>? ?? [])
          .map(
            (evolution) => DigimonEvolutionModel.fromJson(
              evolution as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'xAntibody': xAntibody,
      'images': images
          .map((image) => (image as DigimonImageModel).toJson())
          .toList(),
      'levels': levels
          .map((level) => (level as DigimonLevelModel).toJson())
          .toList(),
      'types': types
          .map((type) => (type as DigimonTypeModel).toJson())
          .toList(),
      'attributes': attributes
          .map((attribute) => (attribute as DigimonAttributeModel).toJson())
          .toList(),
      'fields': fields
          .map((field) => (field as DigimonFieldModel).toJson())
          .toList(),
      'releaseDate': releaseDate,
      'descriptions': descriptions
          .map(
            (description) => (description as DigimonDescriptionModel).toJson(),
          )
          .toList(),
      'skills': skills
          .map((skill) => (skill as DigimonSkillModel).toJson())
          .toList(),
      'priorEvolutions': priorEvolutions
          .map((evolution) => (evolution as DigimonEvolutionModel).toJson())
          .toList(),
      'nextEvolutions': nextEvolutions
          .map((evolution) => (evolution as DigimonEvolutionModel).toJson())
          .toList(),
    };
  }
}

// Modelos auxiliares para las propiedades anidadas
class DigimonImageModel extends DigimonImage {
  const DigimonImageModel({
    required super.href,
    required super.transparent,
  });

  factory DigimonImageModel.fromJson(Map<String, dynamic> json) {
    return DigimonImageModel(
      href: json['href'] as String,
      transparent: json['transparent'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'href': href,
      'transparent': transparent,
    };
  }
}

class DigimonLevelModel extends DigimonLevel {
  const DigimonLevelModel({
    required super.id,
    required super.level,
  });

  factory DigimonLevelModel.fromJson(Map<String, dynamic> json) {
    return DigimonLevelModel(
      id: json['id'] as int,
      level: json['level'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level,
    };
  }
}

class DigimonTypeModel extends DigimonType {
  const DigimonTypeModel({
    required super.id,
    required super.type,
  });

  factory DigimonTypeModel.fromJson(Map<String, dynamic> json) {
    return DigimonTypeModel(
      id: json['id'] as int,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
    };
  }
}

class DigimonAttributeModel extends DigimonAttribute {
  const DigimonAttributeModel({
    required super.id,
    required super.attribute,
  });

  factory DigimonAttributeModel.fromJson(Map<String, dynamic> json) {
    return DigimonAttributeModel(
      id: json['id'] as int,
      attribute: json['attribute'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attribute': attribute,
    };
  }
}

class DigimonFieldModel extends DigimonField {
  const DigimonFieldModel({
    required super.id,
    required super.field,
    required super.image,
  });

  factory DigimonFieldModel.fromJson(Map<String, dynamic> json) {
    return DigimonFieldModel(
      id: json['id'] as int,
      field: json['field'] as String,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'field': field,
      'image': image,
    };
  }
}

class DigimonDescriptionModel extends DigimonDescription {
  const DigimonDescriptionModel({
    required super.origin,
    required super.language,
    required super.description,
  });

  factory DigimonDescriptionModel.fromJson(Map<String, dynamic> json) {
    return DigimonDescriptionModel(
      origin: json['origin'] as String,
      language: json['language'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'origin': origin,
      'language': language,
      'description': description,
    };
  }
}

class DigimonSkillModel extends DigimonSkill {
  const DigimonSkillModel({
    required super.id,
    required super.skill,
    required super.translation,
    required super.description,
  });

  factory DigimonSkillModel.fromJson(Map<String, dynamic> json) {
    return DigimonSkillModel(
      id: json['id'] as int,
      skill: json['skill'] as String,
      translation: json['translation'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'skill': skill,
      'translation': translation,
      'description': description,
    };
  }
}

class DigimonEvolutionModel extends DigimonEvolution {
  const DigimonEvolutionModel({
    required super.id,
    required super.digimon,
    required super.condition,
    required super.image,
    required super.url,
  });

  factory DigimonEvolutionModel.fromJson(Map<String, dynamic> json) {
    return DigimonEvolutionModel(
      id: json['id'] as int,
      digimon: json['digimon'] as String,
      condition: json['condition'] as String,
      image: json['image'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'digimon': digimon,
      'condition': condition,
      'image': image,
      'url': url,
    };
  }
}
