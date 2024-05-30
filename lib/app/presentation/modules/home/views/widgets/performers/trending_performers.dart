import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../global/widgets/request_failed.dart';
import '../../../controller/home_controller.dart';
import '../../../controller/state/home_state.dart';
import 'performer_tile.dart';

class TrendingPerformers extends StatefulWidget {
  const TrendingPerformers({super.key});

  @override
  State<TrendingPerformers> createState() => _TrendingPerformersState();
}

class _TrendingPerformersState extends State<TrendingPerformers> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HomeController controller = context.watch();
    final performers = controller.state.performers;
    return Expanded(
      child: performers.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        failed: () => RequestFailed(
          onRetry: () => controller.loadPerformers(
            performers: const PerformerState.loading(),
          ),
        ),
        loaded: (list) => Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: list.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) {
                final performer = list[i];
                return PerformerTile(performer: performer);
              },
            ),
            Positioned(
              bottom: 30,
              child: AnimatedBuilder(
                animation: _pageController,
                builder: (_, __) {
                  int currentCard = _pageController.page?.toInt() ?? 0;
                  return Row(
                    children: List.generate(
                      list.length,
                      (i) => Icon(
                        Icons.circle,
                        size: 14,
                        color: currentCard == i ? Colors.blue : Colors.white30,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
