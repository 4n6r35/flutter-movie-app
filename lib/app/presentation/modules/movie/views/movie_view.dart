import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../global/widgets/request_failed.dart';
import '../../../inject_reposiotries.dart';
import '../controller/movie_controller.dart';
import 'widgets/movie_app_bar.dart';
import 'widgets/movie_content.dart';

class MovieView extends StatelessWidget {
  const MovieView({super.key, required this.movieId});
  final int movieId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MovieController(
        movieId: movieId,
        moviesRepository: Repositories.movies,
      )..init(),
      builder: (context, child) {
        final MovieController controller = context.watch();
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: const MovieAppBar(),
          body: controller.state.map(
            loading: (_) => const Center(
              child: CircularProgressIndicator(),
            ),
            failed: (_) => RequestFailed(onRetry: () => controller.init()),
            loaded: (state) => MovieContent(state: state),
          ),
        );
      },
    );
  }
}
