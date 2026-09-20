import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';
import 'package:pulse/core/utils/cubit/theme/theme_state.dart';

void main() {
  test('loads a language and emits an updated state', () async {
    final cubit = ThemeCubit();
    final stateFuture = expectLater(
      cubit.stream,
      emits(isA<ThemeLanguageUpdatedState>()),
    );

    cubit.changeLanguage(
      isArabic: false,
      translations: jsonEncode({'app_title': 'Pulse Music'}),
    );

    await stateFuture;
    expect(cubit.translationModel?.get('app_title'), 'Pulse Music');

    await cubit.close();
  });
}
