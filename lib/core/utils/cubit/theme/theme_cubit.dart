import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/errors/either.dart';
import 'package:pulse/core/errors/failures.dart';
import 'package:pulse/core/models/translations.dart';
import 'package:pulse/core/network/local/cache_helper.dart';
import 'package:pulse/core/utils/constants/constants.dart';
import 'package:pulse/core/utils/cubit/theme/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitialState());

  static ThemeCubit get(BuildContext context) => BlocProvider.of(context);

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  Either<Failure, void> changeTheme({bool? fromShared}) {
    try {
      _isDarkMode = fromShared ?? !_isDarkMode;
      CacheHelper.saveData(key: 'isDark', value: _isDarkMode);
      emit(ThemeChangeThemeState());
      return const Right(null);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  bool _isArabicLang = false;
  TranslationModel? _translationModel;

  bool get isArabicLang => _isArabicLang;

  TranslationModel? get translationModel => _translationModel;

  Either<Failure, void> changeLanguage({
    required bool isArabic,
    required String translations,
  }) {
    try {
      if (_isArabicLang == isArabic && _translationModel != null) {
        setAppTranslation(_translationModel!);
        emit(ThemeLanguageUpdatedState());
        return const Right(null);
      }
      emit(ThemeLanguageLoadingState());
      final model = TranslationModel.fromJson(json.decode(translations));
      _isArabicLang = isArabic;
      _translationModel = model;
      setAppTranslation(model);
      emit(ThemeLanguageUpdatedState());
      return const Right(null);
    } catch (_) {
      emit(ThemeLanguageErrorState('generic_error'));
      return const Left(CacheFailure());
    }
  }

  Future<Either<Failure, void>> toggleLanguage() async {
    try {
      emit(ThemeLanguageLoadingState());
      final newLang = !_isArabicLang;
      final jsonString = await rootBundle.loadString(
        'assets/translations/${newLang ? 'ar' : 'en'}.json',
      );
      _translationModel = TranslationModel.fromJson(json.decode(jsonString));
      _isArabicLang = newLang;
      setAppTranslation(_translationModel!);
      await CacheHelper.saveData(
        key: 'isArabicLang',
        value: _isArabicLang,
      );
      emit(ThemeLanguageUpdatedState());
      return const Right(null);
    } catch (_) {
      emit(ThemeLanguageErrorState('generic_error'));
      return const Left(CacheFailure());
    }
  }
}
