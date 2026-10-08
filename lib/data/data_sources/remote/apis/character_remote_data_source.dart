import 'package:rick_and_morty/domain/entities/base/paginated_response.dart';
import 'package:rick_and_morty/domain/entities/character/character_entity.dart';

abstract class CharacterRemoteDataSource {
  Future<PaginatedResponse<CharacterEntity>> getCharactersFromDataSource({int currentPage});
}
