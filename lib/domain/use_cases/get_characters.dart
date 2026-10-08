import 'package:rick_and_morty/domain/entities/base/paginated_response.dart';
import 'package:rick_and_morty/domain/entities/character/character_entity.dart';
import 'package:rick_and_morty/domain/entities/either_of/either_of.dart';
import 'package:rick_and_morty/domain/entities/error/failure.dart';
import 'package:rick_and_morty/domain/repositories/repository.dart';

class GetCharactersUseCase {
  final CharacterRepository characterRepository;

  GetCharactersUseCase({required this.characterRepository});

  Future<EitherOf<Failure, PaginatedResponse<CharacterEntity>>> call({
    required int page,
    PaginatedResponse<CharacterEntity>? currentResponse,
  }) async {
    final EitherOf<Failure, PaginatedResponse<CharacterEntity>> paginatedResult = await characterRepository.getCharactersFromRepository(
      page: page,
    );

    if (_isInitialRequest(currentResponse)) {
      return paginatedResult;
    }

    return paginatedResult.fold(
      (Failure failure) => left(failure),
      (PaginatedResponse<CharacterEntity> newResponse) => right(_mergePages(currentResponse: currentResponse!, newResponse: newResponse)),
    );
  }

  bool _isInitialRequest(PaginatedResponse<CharacterEntity>? currentResponse) {
    return currentResponse == null;
  }

  PaginatedResponse<CharacterEntity> _mergePages({
    required PaginatedResponse<CharacterEntity> currentResponse,
    required PaginatedResponse<CharacterEntity> newResponse,
  }) {
    return currentResponse.addPage(
      newItemsList: newResponse.itemsList,
      newCurrentPage: newResponse.currentPage,
      newTotalPages: newResponse.totalPages,
    );
  }
}
