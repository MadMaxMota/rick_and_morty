import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty/data/data_sources/local/character_local_data_source_impl.dart';
import 'package:rick_and_morty/data/data_sources/remote/apis/character_remote_data_source_impl.dart';
import 'package:rick_and_morty/data/data_sources/remote/clients/http_client.dart';
import 'package:rick_and_morty/data/repositories/characters_repository_impl.dart';
import 'package:rick_and_morty/domain/use_cases/get_characters_use_case.dart';

void main() {
  late GetCharactersUseCase getCharactersUseCase;

  setUp(() {
    getCharactersUseCase = GetCharactersUseCase(
      characterRepository: CharacterRepositoryImpl(
        remoteDataSource: CharacterRemoteDataSourceImpl(httpClient: HttpClient(dio: Dio())),
        localDataSource: CharacterLocalDataSourceImpl(),
      ),
    );
  });

  test('Should get the first page', () async {
    // Act
    final response = await getCharactersUseCase.call(page: 1);

    // Assert
    final firstPage = response.fold((failure) => null, (result) => result);

    expect(firstPage, isNotNull);
    expect(firstPage!.currentPage, 1);
    expect(firstPage.totalPages, 42);
    expect(firstPage.totalRows, 826);
    expect(firstPage.itemsList.first.name, 'Rick Sanchez');
  });

  test('Should merge page 1 with page 2', () async {
    // Arrange
    final responseOne = await getCharactersUseCase.call(page: 1);

    final firstPage = responseOne.fold((failure) => null, (result) => result);

    expect(firstPage, isNotNull);

    // Act
    final responseTwo = await getCharactersUseCase.call(page: 2, currentResponse: firstPage);

    // Assert
    final secondPage = responseTwo.fold((failure) => null, (result) => result);

    expect(secondPage, isNotNull);
    expect(secondPage!.currentPage, 2);
    expect(secondPage.totalPages, 42);
    expect(secondPage.totalRows, 826);

    expect(secondPage.itemsList.length, greaterThan(firstPage!.itemsList.length));

    expect(secondPage.itemsList.first.name, 'Rick Sanchez');
  });
}
