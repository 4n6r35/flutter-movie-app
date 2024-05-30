import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../my_app.dart';
import '../global/controllers/favorites/favorites_controller.dart';
import '../global/controllers/session_controller.dart';
import '../inject_reposiotries.dart';
import '../modules/favorites/views/favorites_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/movie/views/movie_view.dart';
import '../modules/offline/views/offline_view.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/sign_in/views/sign_in_view.dart';
import 'routes.dart';

Future<String> getInitialRouteName(BuildContext context) async {
  final SessionController sessionController = context.read();
  final FavoritesController favoritesController = context.read();

  final hasInternet = Repositories.connectivity.hasInternet;
  if (!hasInternet) {
    return Routes.offline;
  }
  final isSignedIn = await Repositories.authentication.isSignedIn;
  if (!isSignedIn) {
    return Routes.signIn;
  }
  final user = await Repositories.account.getUserData();

  if (user != null) {
    sessionController.setUser(user);
    favoritesController.init();
    return Routes.home;
  }
  return Routes.signIn;
}

mixin RouterMixin on State<MyApp> {
  GoRouter? _router;
  late String _initialRouteName;
  bool _loading = true;
  bool get loading => _loading;

  GoRouter get router {
    if (_router != null) {
      return _router!;
    }
    final routes = [
      GoRoute(
        name: Routes.home,
        path: '/',
        builder: (_, __) => const HomeView(),
      ),
      GoRoute(
        name: Routes.signIn,
        path: '/sign-in',
        builder: (_, __) => const SignInView(),
      ),
      GoRoute(
        name: Routes.movie,
        path: '/movie/:id',
        builder: (_, state) => MovieView(
          movieId: int.parse(
            state.pathParameters['id']!,
          ),
        ),
      ),
      GoRoute(
        name: Routes.profile,
        path: '/profile',
        builder: (_, __) => const ProfileView(),
      ),
      GoRoute(
        name: Routes.offline,
        path: '/offline',
        builder: (_, __) => const OfflineView(),
      ),
      GoRoute(
        name: Routes.favorites,
        path: '/favorites',
        builder: (_, __) => const FavoritesView(),
      ),
    ];

    final initialLocation = routes
        .firstWhere(
          (element) => element.name == _initialRouteName,
          orElse: () => routes.first,
        )
        .path;
    _router = GoRouter(
      initialLocation: initialLocation,
      routes: routes,
    );

    return _router!;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _init(),
    );
  }

  Future<void> _init() async {
    _initialRouteName = await getInitialRouteName(context);
    setState(() {
      _loading = false;
    });
  }
}
