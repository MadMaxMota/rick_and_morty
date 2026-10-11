import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty/data/model/character_model.dart';

void main() {
  group('CharacterModel', () {
    group('fromJson', () {
      test('Should return a valid CharacterModel', () {
        // Arrange
        final Map<String, dynamic> json = {
          'id': 1,
          'name': 'Rick Sanchez',
          'image': 'https://example.com/rick.png',
          'status': 'Alive',
          'species': 'Human',
          'type': '',
          'gender': 'Male',
          'location': {'name': 'Citadel of Ricks'},
          'origin': {'name': 'Earth'},
          'episode': ['https://rickandmortyapi.com/api/episode/1', 'https://rickandmortyapi.com/api/episode/2'],
        };

        // Act
        final result = CharacterModel.fromJson(json);

        // Assert
        expect(result.id, 1);
        expect(result.name, 'Rick Sanchez');
        expect(result.image, 'https://example.com/rick.png');
        expect(result.status, 'Alive');
        expect(result.species, 'Human');
        expect(result.type, '');
        expect(result.gender, 'Male');
        expect(result.location, 'Citadel of Ricks');
        expect(result.origin, 'Earth');
        expect(result.episode, 'https://rickandmortyapi.com/api/episode/1');
      });
    });

    group('toEntity', () {
      test('Should return a CharacterEntity with the same values', () {
        // Arrange
        final model = CharacterModel(
          id: 1,
          name: 'Rick Sanchez',
          image: 'https://example.com/rick.png',
          status: 'Alive',
          species: 'Human',
          type: '',
          gender: 'Male',
          location: 'Citadel of Ricks',
          origin: 'Earth',
          episode: 'https://rickandmortyapi.com/api/episode/1',
        );

        // Act
        final result = model.toEntity();

        // Assert
        expect(result.id, model.id);
        expect(result.name, model.name);
        expect(result.image, model.image);
        expect(result.status, model.status);
        expect(result.species, model.species);
        expect(result.type, model.type);
        expect(result.gender, model.gender);
        expect(result.location, model.location);
        expect(result.origin, model.origin);
        expect(result.episode, model.episode);
      });
    });
  });
}
