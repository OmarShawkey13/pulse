import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pulse/core/errors/either.dart';
import 'package:pulse/core/errors/failures.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/utils/constants/palette_generator_master.dart';

class PaletteService {
  Future<Either<Failure, Color>> extractDominantColor(
    String assetPath,
  ) async {
    try {
      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List();
      return await extractDominantColorFromBytes(bytes);
    } catch (_) {
      return const Left(PaletteFailure());
    }
  }

  Future<Either<Failure, Color>> extractDominantColorFromBytes(
    Uint8List bytes,
  ) async {
    try {
      final image = await decodeImageFromList(bytes);
      final palette = await PaletteGeneratorMaster.fromImage(
        image,
        maximumColorCount: 12,
        targets: [PaletteTargetMaster.vibrant],
      );
      return Right(
        palette.vibrantColor?.color ??
            palette.dominantColor?.color ??
            ColorsManager.primary,
      );
    } catch (_) {
      return const Left(PaletteFailure());
    }
  }
}
