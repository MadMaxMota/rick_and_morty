import 'package:rick_and_morty/domain/entities/base/paginated_response.dart';
import 'package:rick_and_morty/domain/entities/character/character_entity.dart';

abstract class CharacterLocalDataSource {
  Future<PaginatedResponse<CharacterEntity>?> getCharacters({required int page});
  Future<void> saveCharacters({required int page, required PaginatedResponse<CharacterEntity> response});
  Future<void> clear();
}
