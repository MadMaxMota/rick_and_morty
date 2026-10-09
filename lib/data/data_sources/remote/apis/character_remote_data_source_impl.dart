import 'package:dio/dio.dart';
import 'package:rick_and_morty/data/data_sources/remote/apis/character_remote_data_source.dart';
import 'package:rick_and_morty/data/data_sources/remote/clients/http_client.dart';
import 'package:rick_and_morty/data/model/character_model.dart';
import 'package:rick_and_morty/domain/entities/base/paginated_response.dart';
import 'package:rick_and_morty/domain/entities/character/character_entity.dart';
import 'package:rick_and_morty/domain/entities/error/exceptions.dart';

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final HttpClient httpClient;

  CharacterRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<PaginatedResponse<CharacterEntity>> getCharacters({int currentPage = 1}) async {
    try {
      final String path = 'https://rickandmortyapi.com/api/character';
      final Response<dynamic> response = await httpClient.get(path, queryParameters: <String, dynamic>{'page': currentPage});

      Map<String, dynamic> json = Map<String, dynamic>.from(response.data);
      final List<dynamic> list = List.from(json['results']);

      final List<CharacterEntity> itemsList = list.map((e) => CharacterModel.fromJson(e).toEntity()).toList();
      final int pages = json['info']['pages'];
      final int totalRows = json['info']['count'];

      return PaginatedResponse(currentPage: currentPage, totalPages: pages, totalRows: totalRows, itemsList: itemsList);
    } catch (e) {
      throw SearchException();
    }
  }
}
