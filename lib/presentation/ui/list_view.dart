import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/presentation/bloc/characters_bloc.dart';
import 'package:rick_and_morty/presentation/ui/character/character_card.dart';

class ListViewWidget extends StatefulWidget {
  const ListViewWidget({super.key});

  @override
  State<ListViewWidget> createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    context.read<CharactersCubit>().loadFirstPage();
  }

  void _onScroll() {
    if (!_shouldLoadNextPage()) {
      return;
    }

    final CharactersState state = context.read<CharactersCubit>().state;

    if (state is! CharactersLoaded || state.isLoadingMore) {
      return;
    }

    context.read<CharactersCubit>().loadNextPage();
  }

  bool _shouldLoadNextPage() {
    return _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 500;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CharactersCubit, CharactersState>(
        builder: (context, state) {
          if (state is CharactersLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CharactersLoaded) {
            final bool isLoadingMore = state.isLoadingMore;

            return ListView.builder(
              itemCount: state.charactersList.length + (isLoadingMore ? 1 : 0),
              controller: _scrollController,
              itemBuilder: (context, index) {
                if (index == state.charactersList.length) {
                  return Center(child: const CircularProgressIndicator());
                }
                return CharacterCard(character: state.charactersList[index]);
              },
            );
          }

          return const Center(child: Text('Error'));
        },
      ),
    );
  }
}
