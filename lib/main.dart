import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/data/data_sources/local/character_local_data_source_impl.dart';
import 'package:rick_and_morty/data/data_sources/remote/apis/character_remote_data_source_impl.dart';
import 'package:rick_and_morty/data/data_sources/remote/clients/http_client.dart';
import 'package:rick_and_morty/data/repositories/characters_repository_impl.dart';
import 'package:rick_and_morty/domain/use_cases/get_characters.dart';
import 'package:rick_and_morty/presentation/bloc/characters_bloc.dart';
import 'package:rick_and_morty/presentation/ui/list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: BlocProvider(
        create: (_) => CharactersCubit(
          getCharacters: GetCharactersUseCase(
            characterRepository: CharacterRepositoryImpl(
              remoteDataSource: CharacterRemoteDataSourceImpl(httpClient: HttpClient(dio: Dio())),
              localDataSource: CharacterLocalDataSourceImpl(),
            ),
          ),
        ),
        child: ListViewWidget(),
      ),
    );
  }
}
