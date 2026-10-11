import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rick_and_morty/data/data_sources/remote/apis/character_remote_data_source_impl.dart';
import 'package:rick_and_morty/data/data_sources/remote/clients/http_client.dart';
import 'package:rick_and_morty/domain/entities/base/paginated_response.dart';
import 'package:rick_and_morty/domain/entities/character/character_entity.dart';
import 'package:rick_and_morty/domain/entities/error/exceptions.dart';

void main() {
  group('CharacterRemoteDataSourceImpl', () {
    late Dio dio;
    late CharacterRemoteDataSourceImpl dataSource;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://rickandmortyapi.com/api'));

      final HttpClient httpClient = HttpClient(dio: dio);

      dataSource = CharacterRemoteDataSourceImpl(httpClient: httpClient);
    });

    test('Should return the character Rick Sanchez', () async {
      final PaginatedResponse<CharacterEntity> response = await dataSource.getCharacters();

      expect(response.currentPage, 1);
      expect(response.totalPages, 42);
      expect(response.totalRows, 826);
      expect(response.itemsList.first.name, 'Rick Sanchez');
    });

    test('Should return SearchException', () async {
      expect(() => dataSource.getCharacters(currentPage: 10000), throwsA(isA<SearchException>()));
    });
  });
}
