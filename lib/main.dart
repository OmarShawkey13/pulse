import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/di/injections.dart';
import 'package:pulse/core/network/local/cache_helper.dart';
import 'package:pulse/core/network/service/pulse_audio_handler.dart';
import 'package:pulse/core/theme/theme.dart';
import 'package:pulse/core/utils/constants/my_bloc_observer.dart';
import 'package:pulse/core/utils/constants/routes.dart';
import 'package:pulse/core/utils/cubit/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home_state.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final audioHandler = await AudioService.init(
    builder: () => PulseAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.pulse.music.playback',
      androidNotificationChannelName: 'Pulse Music',
      androidNotificationOngoing: true,
      androidResumeOnClick: true,
      androidNotificationClickStartsActivity: true,
      androidShowNotificationBadge: false,
    ),
  );
  await initInjections(audioHandler);
  Bloc.observer = MyBlocObserver();
  final bool? isDarkMode = CacheHelper.getData(key: 'isDark');
  runApp(
    MyApp(
      isDark: isDarkMode,
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool? isDark;

  const MyApp({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeCubit>()
        ..changeTheme(fromShared: isDark)
        ..initializeAudioHandler(),
      child: BlocBuilder<HomeCubit, HomeStates>(
        buildWhen: (previous, current) => current is HomeChangeThemeState,
        builder: (context, state) {
          final cubit = HomeCubit.get(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: cubit.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routes: Routes.routes,
            initialRoute: Routes.home,
          );
        },
      ),
    );
  }
}
