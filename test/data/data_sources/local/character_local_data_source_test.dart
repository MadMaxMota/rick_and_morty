import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty/data/data_sources/local/character_local_data_source_impl.dart';
import 'package:rick_and_morty/data/data_sources/remote/apis/character_remote_data_source_impl.dart';
import 'package:rick_and_morty/data/data_sources/remote/clients/http_client.dart';
import 'package:rick_and_morty/domain/entities/base/paginated_response.dart';
import 'package:rick_and_morty/domain/entities/character/character_entity.dart';

void main() {
  group('CharacterLocalDataSourceImpl', () {
    late Dio dio;
    late CharacterRemoteDataSourceImpl characterRemoteDataSource;
    late CharacterLocalDataSourceImpl characterLocalDataSource;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://rickandmortyapi.com/api'));

      final HttpClient httpClient = HttpClient(dio: dio);

      characterRemoteDataSource = CharacterRemoteDataSourceImpl(httpClient: httpClient);
      characterLocalDataSource = CharacterLocalDataSourceImpl();
    });

    test('Should return null when page is not cached', () async {
      final PaginatedResponse<CharacterEntity>? response = await characterLocalDataSource.getCharacters(page: 1);

      expect(response, null);
    });

    test('Should save and return characters', () async {
      final PaginatedResponse<CharacterEntity> response = await characterRemoteDataSource.getCharacters();

      await characterLocalDataSource.saveCharacters(page: 1, response: response);

      PaginatedResponse<CharacterEntity>? result = await characterLocalDataSource.getCharacters(page: 1);

      expect(result!, isNotNull);
      expect(result.currentPage, 1);
      expect(result.totalPages, 42);
      expect(result.totalRows, 826);
      expect(result.itemsList.first.name, 'Rick Sanchez');
    });

    test('Should cache each page separately', () async {
      final PaginatedResponse<CharacterEntity> responseOne = await characterRemoteDataSource.getCharacters();
      await characterLocalDataSource.saveCharacters(page: 1, response: responseOne);
      PaginatedResponse<CharacterEntity>? resultOne = await characterLocalDataSource.getCharacters(page: 1);

      final PaginatedResponse<CharacterEntity> responseTwo = await characterRemoteDataSource.getCharacters(currentPage: 2);
      await characterLocalDataSource.saveCharacters(page: 2, response: responseTwo);
      PaginatedResponse<CharacterEntity>? resultTwo = await characterLocalDataSource.getCharacters(page: 2);

      expect(resultOne!, isNotNull);
      expect(resultOne.currentPage, 1);
      expect(resultOne.totalPages, 42);
      expect(resultOne.totalRows, 826);
      expect(resultOne.itemsList.first.name, 'Rick Sanchez');

      expect(resultTwo!, isNotNull);
      expect(resultTwo.currentPage, 2);
      expect(resultTwo.totalPages, 42);
      expect(resultTwo.totalRows, 826);
    });
  });
}
