import 'package:flutter/material.dart';
import 'package:rick_and_morty/domain/entities/character/character_entity.dart';
import 'package:rick_and_morty/presentation/ui/character/character_info.dart';
import 'package:rick_and_morty/presentation/ui/character/location_info.dart';

class CharacterDetails extends StatelessWidget {
  final CharacterEntity character;

  const CharacterDetails({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          character.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        CharacterInfo(label: 'Status', value: character.status),
        CharacterInfo(label: 'Species', value: character.species),
        CharacterInfo(label: 'Gender', value: character.gender),
        const SizedBox(height: 6),
        LocationInfo(label: 'Origin', value: character.origin),
        const SizedBox(height: 6),
        LocationInfo(label: 'Location', value: character.location),
      ],
    );
  }
}
