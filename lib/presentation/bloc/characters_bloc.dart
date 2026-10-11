import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/domain/entities/base/paginated_response.dart';
import 'package:rick_and_morty/domain/entities/character/character_entity.dart';
import 'package:rick_and_morty/domain/entities/either_of/either_of.dart';
import 'package:rick_and_morty/domain/entities/error/failure.dart';
import 'package:rick_and_morty/domain/use_cases/get_characters_use_case.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final GetCharactersUseCase getCharacters;

  CharactersCubit({required this.getCharacters}) : super(CharactersInitial());

  Future<void> loadFirstPage() async {
    emit(CharactersLoading());

    final EitherOf<Failure, PaginatedResponse<CharacterEntity>> result = await getCharacters.call(page: 1);

    result.fold(
      (Failure failure) => emit(CharactersError()),
      (PaginatedResponse<CharacterEntity> response) => emit(CharactersLoaded(currentResponse: response, isLoadingMore: false)),
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

    if (!currentState.currentResponse.hasMore) {
      return;
    }

    emit(CharactersLoaded(currentResponse: currentState.currentResponse, isLoadingMore: true));

    final int nextPage = currentState.currentResponse.currentPage + 1;

    final EitherOf<Failure, PaginatedResponse<CharacterEntity>> result = await getCharacters.call(
      page: nextPage,
      currentResponse: currentState.currentResponse,
    );

    result.fold(
      (Failure failure) => emit(CharactersLoaded(currentResponse: currentState.currentResponse, isLoadingMore: false)),
      (PaginatedResponse<CharacterEntity> response) => emit(CharactersLoaded(currentResponse: response, isLoadingMore: false)),
    );
  }
}
