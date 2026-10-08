import 'package:rick_and_morty/data/data_sources/local/character_local_data_source.dart';
import 'package:rick_and_morty/domain/entities/base/paginated_response.dart';
import 'package:rick_and_morty/domain/entities/character/character_entity.dart';

class CharacterLocalDataSourceImpl implements CharacterLocalDataSource {
  final Map<int, _CacheEntry<PaginatedResponse<CharacterEntity>>> _cacheMap = <int, _CacheEntry<PaginatedResponse<CharacterEntity>>>{};

  @override
  Future<PaginatedResponse<CharacterEntity>?> getCharacters({required int page}) {
    final _CacheEntry<PaginatedResponse<CharacterEntity>>? entry = _cacheMap[page];

    if (_hasNoCacheEntry(entry)) {
      return Future.value(null);
    }

    if (entry!.isExpired()) {
      _cacheMap.remove(page);
      return Future.value(null);
    }

    return Future.value(entry.data);
  }

  bool _hasNoCacheEntry(_CacheEntry<PaginatedResponse<CharacterEntity>>? entry) => entry == null;

  @override
  Future<void> saveCharacters({required int page, required PaginatedResponse<CharacterEntity> response}) {
    _cacheMap[page] = _CacheEntry<PaginatedResponse<CharacterEntity>>(data: response, cachedAt: DateTime.now());

    return Future.value();
  }

  @override
  Future<void> clear() {
    _cacheMap.clear();

    return Future.value();
  }
}

class _CacheEntry<T> {
  final T data;
  final DateTime cachedAt;

  _CacheEntry({required this.data, required this.cachedAt});

  final Duration _cacheDuration = Duration(minutes: 2);

  bool isExpired() => DateTime.now().difference(cachedAt) >= _cacheDuration;
}
