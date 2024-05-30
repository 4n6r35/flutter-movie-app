import 'package:flutter/material.dart';

import '../../inject_reposiotries.dart';

class MyScaffold extends StatelessWidget {
  const MyScaffold({
    super.key,
    required this.body,
    this.appBar,
  });
  final Widget body;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    final connectivityRepository = Repositories.connectivity;
    return Scaffold(
      appBar: appBar,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(child: body),
            StreamBuilder<bool>(
              initialData: connectivityRepository.hasInternet,
              stream: connectivityRepository.onInternetChanged,
              builder: (_, snapshot) {
                return AnimatedSwitcher(
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  duration: const Duration(milliseconds: 200),
                  child: snapshot.data == false
                      ? Container(
                          width: double.infinity,
                          color: Colors.redAccent,
                          child: const Text(
                            'No Internet',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : const SizedBox(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
