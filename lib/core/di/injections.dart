import 'package:just_audio/just_audio.dart';
import 'package:pulse/core/network/service/pulse_audio_handler.dart';
import 'package:pulse/core/utils/cubit/home_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initInjections(PulseAudioHandler handler) async {
  sl.registerLazySingleton(() => handler);

  sl.registerFactory(() => HomeCubit());

  sl.registerLazySingleton(() => AudioPlayer());

  final sharedPref = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPref);
}
