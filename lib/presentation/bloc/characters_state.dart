part of 'characters_bloc.dart';

abstract class CharactersState {}

class CharactersInitial extends CharactersState {}

class CharactersLoading extends CharactersState {}

class CharactersLoaded extends CharactersState {
  final PaginatedResponse<CharacterEntity> currentResponse;
  final bool isLoadingMore;

  CharactersLoaded({required this.currentResponse, this.isLoadingMore = false});
}

class CharactersError extends CharactersState {}
