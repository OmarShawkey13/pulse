import 'package:just_audio/just_audio.dart';
import 'package:pulse/core/network/service/pulse_audio_handler.dart';
import 'package:pulse/core/network/service/audio_player_service.dart';
import 'package:pulse/core/network/service/palette_service.dart';
import 'package:pulse/core/network/local/database_helper.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:pulse/core/utils/cubit/theme/theme_cubit.dart';
import 'package:pulse/features/home/presentation/logic/playlist_songs_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initInjections(PulseAudioHandler handler) async {
  sl.registerLazySingleton(() => handler);
  sl.registerLazySingleton(() => DatabaseHelper.instance);

  sl.registerFactory(() => HomeCubit(databaseHelper: sl<DatabaseHelper>()));
  sl.registerFactory(() => ThemeCubit());
  sl.registerFactory(
    () => PlaylistSongsCubit(databaseHelper: sl<DatabaseHelper>()),
  );

  sl.registerLazySingleton(() => AudioPlayer());
  sl.registerFactory(() => AudioPlayerService(player: sl<AudioPlayer>()));
  sl.registerLazySingleton(() => PaletteService());

  final sharedPref = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPref);
}
