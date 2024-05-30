import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../global/controllers/favorites/favorites_controller.dart';
import '../../../../utils/mask_as_favorite.dart';
import '../../controller/movie_controller.dart';

class MovieAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MovieAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final MovieController controller = context.watch();
    final FavoritesController favoritesController = context.watch();
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: Colors.transparent,
      actions: controller.state.mapOrNull(
        loaded: (moviestate) => [
          favoritesController.state.maybeMap(
            loading: (_) => const CircularProgressIndicator(),
            loaded: (favoritesState) => IconButton(
              onPressed: () => markAsFavorite(
                context: context,
                media: moviestate.movie.toMedia(),
                mounted: () => controller.mounted,
              ),
              icon: Icon(
                favoritesState.movies.containsKey(moviestate.movie.id)
                    ? Icons.favorite
                    : Icons.favorite_outline,
              ),
            ),
            orElse: () => const SizedBox(),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
