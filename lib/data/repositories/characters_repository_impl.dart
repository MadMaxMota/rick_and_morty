import 'package:rick_and_morty/data/data_sources/local/character_local_data_source.dart';
import 'package:rick_and_morty/data/data_sources/remote/apis/character_remote_data_source.dart';
import 'package:rick_and_morty/domain/entities/base/paginated_response.dart';
import 'package:rick_and_morty/domain/entities/character/character_entity.dart';
import 'package:rick_and_morty/domain/entities/either_of/either_of.dart';
import 'package:rick_and_morty/domain/entities/error/exceptions.dart';
import 'package:rick_and_morty/domain/entities/error/failure.dart';
import 'package:rick_and_morty/domain/repositories/repository.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;
  final CharacterLocalDataSource localDataSource;

  CharacterRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<EitherOf<Failure, PaginatedResponse<CharacterEntity>>> getCharactersFromRepository({required int page}) async {
    try {
      final PaginatedResponse<CharacterEntity>? cachedResponse = await localDataSource.getCharacters(page: page);

      if (cachedResponse != null) {
        return right(cachedResponse);
      }

      final PaginatedResponse<CharacterEntity> remoteResponse = await remoteDataSource.getCharactersFromDataSource(currentPage: page);

      await localDataSource.saveCharacters(page: page, response: remoteResponse);

      return right(remoteResponse);
    } on SearchException catch (exception, stackTrace) {
      return left(SearchFailure(message: 'Search error.', stackTrace: stackTrace, originalException: exception));
    }
  }
}
