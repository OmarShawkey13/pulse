import 'package:flutter/material.dart';
import 'package:pulse/core/utils/cubit/home_cubit.dart';
import 'package:pulse/features/home/presentation/widgets/home_app_bar.dart';
import 'package:pulse/features/home/presentation/widgets/home_background.dart';
import 'package:pulse/features/home/presentation/widgets/home_content.dart';
import 'package:pulse/features/home/presentation/widgets/mini_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Track player expansion state to hide AppBar
  bool _isPlayerExpanded = false;

  @override
  void initState() {
    super.initState();
    homeCubit.loadSongs();
  }

  void _onPlayerExpansionChanged(double expansionValue) {
    final isExpanded = expansionValue > 0.8;
    if (_isPlayerExpanded != isExpanded) {
      setState(() {
        _isPlayerExpanded = isExpanded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _isPlayerExpanded ? null : const HomeAppBar(),
      body: HomeBackground(
        child: Stack(
          children: [
            const SafeArea(
              child: HomeContent(),
            ),
            MiniPlayer(
              onExpansionChanged: _onPlayerExpansionChanged,
            ),
          ],
        ),
      ),
    );
  }
}
