import 'package:flutter/material.dart';

class CharacterImage extends StatelessWidget {
  final String imageUrl;

  const CharacterImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        imageUrl,
        width: 110,
        height: 140,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return const SizedBox(width: 110, height: 140, child: Center(child: CircularProgressIndicator()));
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 110,
            height: 140,
            color: const Color(0xFF1A1F26),
            child: const Icon(Icons.image_not_supported_outlined, color: Colors.white54, size: 32),
          );
        },
      ),
    );
  }
}
