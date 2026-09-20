import 'package:pulse/core/models/translations.dart';

TranslationModel _currentTranslation = TranslationModel.fromJson({});

TranslationModel appTranslation() => _currentTranslation;

void setAppTranslation(TranslationModel translation) {
  _currentTranslation = translation;
}
