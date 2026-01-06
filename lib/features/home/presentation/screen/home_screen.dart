import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/utils/cubit/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home_state.dart';
import 'package:pulse/features/home/presentation/widgets/custom_tab_switch.dart';
import 'package:pulse/features/home/presentation/widgets/favorite_songs_list.dart';
import 'package:pulse/features/home/presentation/widgets/home_app_bar.dart';
import 'package:pulse/features/home/presentation/widgets/home_background.dart';
import 'package:pulse/features/home/presentation/widgets/home_content.dart';
import 'package:pulse/features/home/presentation/widgets/mini_player.dart';
import 'package:pulse/features/home/presentation/widgets/recent_songs_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Track player expansion state to hide AppBar
  bool _isPlayerExpanded = false;
  final PageController _pageController = PageController();
  int? _targetPage;

  @override
  void initState() {
    super.initState();
    homeCubit.loadSongs();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
            SafeArea(
              child: BlocConsumer<HomeCubit, HomeStates>(
                buildWhen: (previous, current) =>
                    current is HomeTabChangedState,
                listener: (context, state) {
                  if (state is HomeTabChangedState) {
                    final target = homeCubit.selectedTabIndex;

                    if (_pageController.hasClients) {
                      final current = _pageController.page?.round() ?? 0;

                      if (current != target) {
                        _targetPage = target;
                        _pageController
                            .animateToPage(
                              target,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            )
                            .then((_) {
                              if (_targetPage == target) {
                                _targetPage = null;
                              }
                            });
                      }
                    }
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      CustomTabSwitch(
                        selectedIndex: homeCubit.selectedTabIndex,
                        onTap: (index) {
                          homeCubit.changeTab(index);
                        },
                        tabs: const ['Songs', 'Recent', 'Favorite'],
                      ),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            if (_targetPage != null && _targetPage != index) {
                              return;
                            }
                            homeCubit.changeTab(index);
                          },
                          children: const [
                            HomeContent(),
                            RecentSongsList(),
                            FavoriteSongsList(),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
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
