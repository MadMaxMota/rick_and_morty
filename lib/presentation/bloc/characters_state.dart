part of 'characters_bloc.dart';

abstract class CharactersState {}

class CharactersInitial extends CharactersState {}

class CharactersLoading extends CharactersState {}

class CharactersLoaded extends CharactersState {
  final List<CharacterEntity> charactersList;
  final bool isLoadingMore;

  CharactersLoaded({required this.charactersList, this.isLoadingMore = false});
}

class CharactersError extends CharactersState {}
