import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/utils/cubit/home/home_cubit.dart';
import 'package:pulse/core/utils/cubit/home/home_state.dart';
import 'package:pulse/core/utils/constants/constants.dart';
import 'package:pulse/features/home/presentation/widgets/custom_tab_switch.dart';
import 'package:pulse/features/home/presentation/widgets/home_app_bar.dart';
import 'package:pulse/features/home/presentation/widgets/home_background.dart';
import 'package:pulse/features/home/presentation/widgets/home_pages_view.dart';
import 'package:pulse/features/home/presentation/widgets/home_mini_player_wrapper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isPlayerExpanded = false;
  final PageController _pageController = PageController();
  int? _targetPage;

  @override
  void initState() {
    super.initState();
    HomeCubit.get(context).loadSongs();
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
    final home = HomeCubit.get(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _isPlayerExpanded ? null : const HomeAppBar(),
      body: HomeBackground(
        child: Stack(
          children: [
            SafeArea(
              child: BlocConsumer<HomeCubit, HomeStates>(
                buildWhen: (_, current) =>
                    current is HomeTabChangedState ||
                    current is HomeLoadSongsSuccessState,
                listener: (context, state) {
                  if (state is HomeTabChangedState) {
                    final target = home.selectedTabIndex;
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
                              if (_targetPage == target) _targetPage = null;
                            });
                      }
                    }
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      CustomTabSwitch(
                        selectedIndex: home.selectedTabIndex,
                        onTap: home.changeTab,
                        tabs: [
                          appTranslation().get('songs'),
                          appTranslation().get('recent'),
                          appTranslation().get('favorite'),
                          appTranslation().get('playlists'),
                        ],
                      ),
                      HomePagesView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          if (_targetPage != null && _targetPage != index) {
                            return;
                          }
                          home.changeTab(index);
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: HomeMiniPlayerWrapper(
                onExpansionChanged: _onPlayerExpansionChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
