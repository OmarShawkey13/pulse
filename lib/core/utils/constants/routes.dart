import 'package:flutter/material.dart';
import 'package:pulse/features/home/presentation/screen/home_screen.dart';
import 'package:pulse/features/song_details/presentation/screen/song_details_screen.dart';

class Routes {
  static const String home = "/home";
  static const String songDetails = "/songDetails";

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => const HomeScreen(),
    songDetails: (context) => const SongDetailsScreen(),
  };
}
