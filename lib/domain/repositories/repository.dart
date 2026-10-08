import 'package:rick_and_morty/domain/entities/base/paginated_response.dart';
import 'package:rick_and_morty/domain/entities/character/character_entity.dart';
import 'package:rick_and_morty/domain/entities/either_of/either_of.dart';
import 'package:rick_and_morty/domain/entities/error/failure.dart';

abstract class CharacterRepository {
  Future<EitherOf<Failure, PaginatedResponse<CharacterEntity>>> getCharactersFromRepository({required int page});
}
