import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../global/colors.dart';
import '../../../global/controllers/theme_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = context.read();
    final darkMode = themeController.darkMode;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        color: darkMode ? AppColors.dark : Colors.white,
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(),
              ),
              SizedBox(height: 20),
              Text('LOADING...'),
            ],
          ),
        ),
      ),
    );
  }
}
