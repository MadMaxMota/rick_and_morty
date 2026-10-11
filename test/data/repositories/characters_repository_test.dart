import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty/data/data_sources/local/character_local_data_source_impl.dart';
import 'package:rick_and_morty/data/data_sources/remote/apis/character_remote_data_source_impl.dart';
import 'package:rick_and_morty/data/data_sources/remote/clients/http_client.dart';
import 'package:rick_and_morty/data/repositories/characters_repository_impl.dart';

void main() {
  late CharacterRepositoryImpl repository;
  late CharacterRemoteDataSourceImpl remoteDataSource;
  late CharacterLocalDataSourceImpl localDataSource;

  setUp(() {
    remoteDataSource = CharacterRemoteDataSourceImpl(httpClient: HttpClient(dio: Dio()));

    localDataSource = CharacterLocalDataSourceImpl();

    repository = CharacterRepositoryImpl(remoteDataSource: remoteDataSource, localDataSource: localDataSource);
  });

  test('Should return characters from API when cache is empty', () async {
    // Act
    final result = await repository.getCharactersFromRepository(page: 1);

    // Assert
    final response = result.fold((failure) => null, (response) => response);

    expect(response, isNotNull);
    expect(response!.currentPage, 1);
    expect(response.totalPages, 42);
    expect(response.totalRows, 826);
    expect(response.itemsList.first.name, 'Rick Sanchez');
  });

  test('Should return cached characters on subsequent requests', () async {
    // Arrange
    await repository.getCharactersFromRepository(page: 1);

    // Act
    final result = await repository.getCharactersFromRepository(page: 1);

    // Assert

    final response = result.fold((failure) => null, (response) => response);

    expect(response, isNotNull);
    expect(response!.currentPage, 1);
    expect(response.itemsList.first.name, 'Rick Sanchez');
  });

  test('Should fetch different pages independently', () async {
    // Act
    final firstPage = await repository.getCharactersFromRepository(page: 1);
    final secondPage = await repository.getCharactersFromRepository(page: 2);

    // Assert
    final responseOne = firstPage.fold((failure) => null, (response) => response);
    final responseTwo = secondPage.fold((failure) => null, (response) => response);

    expect(responseOne!.currentPage, 1);
    expect(responseTwo!.currentPage, 2);
  });
}
