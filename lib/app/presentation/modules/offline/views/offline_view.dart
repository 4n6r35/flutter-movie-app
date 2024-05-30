import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/repositories/connectivity_repository.dart';
import '../../../routes/router.dart';
import '../../../service_locator/service_locator.dart';

class OfflineView extends StatefulWidget {
  const OfflineView({super.key});

  @override
  State<OfflineView> createState() => _OfflineViewState();
}

class _OfflineViewState extends State<OfflineView> {
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _streamSubscription ??= ServiceLocator.instance
        .find<ConnectivityRepository>()
        .onInternetChanged
        .listen(
      (connected) async {
        if (connected) {
          final initialRouteName = await getInitialRouteName(context);
          if (mounted) {
            context.goNamed(initialRouteName);
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('OFFLINE'),
      ),
    );
  }
}
