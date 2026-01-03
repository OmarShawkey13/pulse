import 'package:flutter/material.dart';
import 'package:pulse/core/utils/cubit/home_cubit.dart';
import 'package:pulse/features/home/presentation/widgets/home_app_bar.dart';
import 'package:pulse/features/home/presentation/widgets/home_background.dart';
import 'package:pulse/features/home/presentation/widgets/home_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    homeCubit.loadSongs();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBodyBehindAppBar: true,
      appBar: HomeAppBar(),
      body: HomeBackground(
        child: SafeArea(
          child: HomeContent(),
        ),
      ),
    );
  }
}
