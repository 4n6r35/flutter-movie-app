import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../global/controllers/session_controller.dart';
import '../../../global/controllers/theme_controller.dart';
import '../../../global/extensions/build_context_ext.dart';
import '../../../routes/routes.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: context.darkMode,
                onChanged: context.read<ThemeController>().onChange,
              ),
              ListTile(
                title: const Text('Cerrar sesión'),
                onTap: () {
                  context.read<SessionController>().signOut();
                  // ServiceLocator.instance.find<SessionController>().signOut();
                  context.goNamed(
                    Routes.signIn,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
