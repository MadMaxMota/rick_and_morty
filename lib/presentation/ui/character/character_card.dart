import 'package:flutter/material.dart';
import 'package:rick_and_morty/domain/entities/character/character_entity.dart';
import 'package:rick_and_morty/presentation/ui/character/character_details.dart';
import 'package:rick_and_morty/presentation/ui/character/character_image.dart';

class CharacterCard extends StatelessWidget {
  final CharacterEntity character;

  const CharacterCard({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFF151B22), borderRadius: BorderRadius.circular(20)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CharacterImage(imageUrl: character.image),
            const SizedBox(width: 14),
            Expanded(child: CharacterDetails(character: character)),
          ],
        ),
      ),
    );
  }
}
