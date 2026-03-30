import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/network/local/cache_helper.dart';
import 'package:pulse/core/utils/cubit/theme/theme_state.dart';
import 'package:pulse/main.dart';

ThemeCubit get themeCubit => ThemeCubit.get(navigatorKey.currentContext!);

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitialState());

  static ThemeCubit get(BuildContext context) => BlocProvider.of(context);

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void changeTheme({bool? fromShared}) {
    _isDarkMode = fromShared ?? !_isDarkMode;
    CacheHelper.saveData(key: 'isDark', value: _isDarkMode);
    emit(ThemeChangeThemeState());
  }
}
