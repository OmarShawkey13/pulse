// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/core/models/translations.dart';

void main() {
  test('translation interpolation works', () {
    const translation = TranslationModel({'song_count': '{count} songs'});

    expect(translation.get('song_count', params: {'count': 2}), '2 songs');
  });
}
