import 'package:rick_and_morty/domain/entities/character/character_entity.dart';

class CharacterModel extends CharacterEntity {
  CharacterModel({
    required super.id,
    required super.name,
    required super.image,
    required super.status,
    required super.species,
    required super.type,
    required super.gender,
    required super.location,
    required super.origin,
    required super.episode,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      status: json['status'],
      species: json['species'],
      type: json['type'],
      gender: json['gender'],
      location: json['location']['name'],
      origin: json['origin']['name'],
      episode: (json['episode'] as List).first.toString(),
    );
  }

  CharacterEntity toEntity() {
    return CharacterEntity(
      id: id,
      name: name,
      image: image,
      status: status,
      species: species,
      type: type,
      gender: gender,
      location: location,
      origin: origin,
      episode: episode,
    );
  }
}
