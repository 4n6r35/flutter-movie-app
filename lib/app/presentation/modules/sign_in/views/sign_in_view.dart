import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../generated/translations.g.dart';
import '../../../global/extensions/build_context_ext.dart';
import '../../../inject_reposiotries.dart';
import '../controller/sing_in_controller.dart';
import 'widgets/image_list_view.dart';
import 'widgets/submit_button.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignInController(
        authenticationRepository: Repositories.authentication,
        favoritesController: context.read(),
        sessionController: context.read(),
      ),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              child: Builder(
                builder: (context) {
                  final SignInController controller = context.watch();
                  return AbsorbPointer(
                    absorbing: controller.state.fetching,
                    child: Column(
                      children: [
                        const Column(
                          children: <Widget>[
                            SizedBox(height: 30),
                            ImageListView(
                              startIndex: 1,
                              duration: 25,
                            ),
                            SizedBox(height: 10),
                            ImageListView(
                              startIndex: 11,
                              duration: 45,
                            ),
                            SizedBox(height: 10),
                            ImageListView(
                              startIndex: 21,
                              duration: 65,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 50),
                              Text(
                                'Iniciar sesión',
                                style: context.textTheme.titleLarge,
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  hintText: t.signIn.username,
                                ),
                                onChanged: controller.onUsernameChanged,
                                validator: (text) {
                                  text = text?.trim().toLowerCase() ?? '';
                                  if (text.isEmpty) {
                                    return t.signIn.errors.username;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  hintText: t.signIn.password,
                                ),
                                onChanged: controller.onPasswordChanged,
                                validator: (text) {
                                  text = text?.replaceAll(' ', '') ?? '';
                                  if (text.length < 4) {
                                    return t.signIn.errors.password;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),
                              const Center(child: SubmitButton())
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
