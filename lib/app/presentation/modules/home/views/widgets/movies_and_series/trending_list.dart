import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/either/either.dart';
import '../../../../../../domain/failures/http_request/http_request_failure.dart';
import '../../../../../../domain/models/media/media.dart';
import '../../../../../global/widgets/request_failed.dart';
import '../../../controller/home_controller.dart';
import '../../../controller/state/home_state.dart';
import 'trending_tile.dart';
import 'trending_time_window.dart';

typedef EitherListMedia = Either<HttpRequestFailure, List<Media>>;

class TrendingList extends StatelessWidget {
  const TrendingList({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = context.watch();
    final moviesAndSeries = controller.state.moviesAndSeries;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TrendingTimeWindow(
          timeWindow: moviesAndSeries.timeWindow,
          onChange: controller.onTimeWindowsChanged,
        ),
        const SizedBox(height: 10),
        AspectRatio(
          aspectRatio: 16 / 8,
          child: LayoutBuilder(
            builder: (_, constraints) {
              final width = constraints.maxHeight * 0.65;
              return Center(
                  child: moviesAndSeries.when(
                loading: (_) => const CircularProgressIndicator(),
                failed: (_) => RequestFailed(
                  onRetry: () => controller.loadMoviesAndSeries(
                    moviesAndSeries: MoviesAndSeriesState.loading(
                      moviesAndSeries.timeWindow,
                    ),
                  ),
                ),
                loaded: (
                  _,
                  list,
                ) =>
                    ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  separatorBuilder: (_, i) => const SizedBox(width: 10),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final media = list[i];
                    return TrendingTile(
                      media: media,
                      width: width,
                    );
                  },
                ),
              ));
            },
          ),
        ),
      ],
    );
  }
}
