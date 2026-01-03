import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pulse/core/utils/constants/palette_generator_master.dart';

class PaletteService {
  static Future<Color> extractDominantColor(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();

    return extractDominantColorFromBytes(bytes);
  }

  static Future<Color> extractDominantColorFromBytes(Uint8List bytes) async {
    final image = await decodeImageFromList(bytes);

    final palette = await PaletteGeneratorMaster.fromImage(
      image,
      maximumColorCount: 12,
      targets: [PaletteTargetMaster.vibrant],
    );

    return palette.vibrantColor?.color ??
        palette.dominantColor?.color ??
        const Color(0xFF6750A4); // fallback
  }
}
