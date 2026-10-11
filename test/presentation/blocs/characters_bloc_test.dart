import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty/data/data_sources/local/character_local_data_source_impl.dart';
import 'package:rick_and_morty/data/data_sources/remote/apis/character_remote_data_source_impl.dart';
import 'package:rick_and_morty/data/data_sources/remote/clients/http_client.dart';
import 'package:rick_and_morty/data/repositories/characters_repository_impl.dart';
import 'package:rick_and_morty/domain/use_cases/get_characters_use_case.dart';
import 'package:rick_and_morty/presentation/bloc/characters_bloc.dart';

void main() {
  late CharactersCubit cubit;

  setUp(() {
    final remoteDataSource = CharacterRemoteDataSourceImpl(httpClient: HttpClient(dio: Dio()));

    final localDataSource = CharacterLocalDataSourceImpl();

    final repository = CharacterRepositoryImpl(remoteDataSource: remoteDataSource, localDataSource: localDataSource);

    final getCharacters = GetCharactersUseCase(characterRepository: repository);

    cubit = CharactersCubit(getCharacters: getCharacters);
  });

  tearDown(() async {
    await cubit.close();
  });

  test('Should load the first page from API', () async {
    // Arrange
    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CharactersLoading>(),
        isA<CharactersLoaded>()
            .having((state) => state.currentResponse.currentPage, 'currentPage', 1)
            .having((state) => state.currentResponse.itemsList.first.name, 'firstCharacter', 'Rick Sanchez')
            .having((state) => state.isLoadingMore, 'isLoadingMore', false),
      ]),
    );

    // Act
    await cubit.loadFirstPage();

    // Assert
    await expectation;
  });

  test('Should load the next page and merge characters', () async {
    // Arrange
    await cubit.loadFirstPage();

    final CharactersLoaded firstState = cubit.state as CharactersLoaded;

    final int firstPageLength = firstState.currentResponse.itemsList.length;

    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CharactersLoaded>().having((state) => state.isLoadingMore, 'isLoadingMore', true),
        isA<CharactersLoaded>()
            .having((state) => state.currentResponse.currentPage, 'currentPage', 2)
            .having((state) => state.currentResponse.itemsList.length, 'charactersCount', greaterThan(firstPageLength))
            .having((state) => state.isLoadingMore, 'isLoadingMore', false),
      ]),
    );

    // Act
    await cubit.loadNextPage();

    // Assert
    await expectation;
  });
}
