import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/domain/entities/base/paginated_response.dart';
import 'package:rick_and_morty/domain/entities/character/character_entity.dart';
import 'package:rick_and_morty/domain/entities/either_of/either_of.dart';
import 'package:rick_and_morty/domain/entities/error/failure.dart';
import 'package:rick_and_morty/domain/use_cases/get_characters.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final GetCharactersUseCase getCharacters;

  CharactersCubit({required this.getCharacters}) : super(CharactersInitial());

  late PaginatedResponse<CharacterEntity> currentPage;

  Future<void> loadFirstPage() async {
    emit(CharactersLoading());

    final EitherOf<Failure, PaginatedResponse<CharacterEntity>> result = await getCharacters.call(page: 1);

    result.fold(
      (Failure failure) {
        emit(CharactersError());
      },
      (PaginatedResponse<CharacterEntity> response) {
        currentPage = response;

        emit(CharactersLoaded(charactersList: response.itemsList, isLoadingMore: false));
      },
    );
  }

  Future<void> loadNextPage() async {
    if (state is! CharactersLoaded) {
      return;
    }

    final CharactersLoaded currentState = state as CharactersLoaded;

    if (currentState.isLoadingMore) {
      return;
    }

    if (!currentPage.hasMore) {
      return;
    }

    emit(CharactersLoaded(charactersList: currentState.charactersList, isLoadingMore: true));

    final int nextPage = currentPage.currentPage + 1;

    final EitherOf<Failure, PaginatedResponse<CharacterEntity>> result = await getCharacters.call(
      page: nextPage,
      currentResponse: currentPage,
    );

    result.fold(
      (Failure failure) {
        emit(CharactersLoaded(charactersList: currentState.charactersList, isLoadingMore: false));
      },
      (PaginatedResponse<CharacterEntity> response) {
        currentPage = response;

        emit(CharactersLoaded(charactersList: response.itemsList, isLoadingMore: false));
      },
    );
  }
}
