import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/core/models/translations.dart';

void main() {
  test('returns the key when a value is missing', () {
    const translation = TranslationModel({});

    expect(translation.get('missing_key'), 'missing_key');
  });
}
