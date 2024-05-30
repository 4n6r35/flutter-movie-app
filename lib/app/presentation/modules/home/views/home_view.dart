import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../global/widgets/my_scaffold.dart';
import '../../../inject_reposiotries.dart';
import '../../../routes/routes.dart';
import '../controller/home_controller.dart';
import 'widgets/movies_and_series/trending_list.dart';
import 'widgets/performers/trending_performers.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    return ChangeNotifierProvider(
      key: Key('home-$languageCode'),
      create: (_) => HomeController(
        trendingRepository: Repositories.trending,
      )..init(),
      child: MyScaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () => context.pushNamed(Routes.favorites),
              icon: const Icon(
                Icons.favorite,
              ),
            ),
            IconButton(
              onPressed: () => context.pushNamed(Routes.profile),
              icon: const Icon(
                Icons.person,
              ),
            ),
          ],
        ),
        body: SafeArea(
            child: LayoutBuilder(
          builder: (context, constrains) => RefreshIndicator(
            onRefresh: context.read<HomeController>().init,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              child: SizedBox(
                height: constrains.maxHeight,
                child: const Column(
                  children: [
                    SizedBox(height: 10),
                    TrendingList(),
                    SizedBox(height: 20),
                    TrendingPerformers(),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        )),
      ),
    );
  }
}
