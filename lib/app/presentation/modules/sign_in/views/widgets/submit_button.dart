import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../generated/translations.g.dart';
import '../../../../routes/routes.dart';
import '../../controller/sing_in_controller.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final SignInController controller = context.watch();
    return controller.state.fetching
        ? const CircularProgressIndicator()
        : MaterialButton(
            minWidth: 350,
            height: 50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onPressed: () {
              final isValid = Form.of(context).validate();
              if (isValid) {
                _submit(context);
              }
            },
            color: Colors.green,
            child: Text(t.signIn.signIn),
          );
  }

  Future<void> _submit(BuildContext context) async {
    final SignInController controller = context.read();

    final result = await controller.submit();

    if (!controller.mounted) return;

    result.when(
      left: (failure) {
        final message = failure.when(
          notFound: () => t.signIn.errors.submit.notFound,
          network: () => t.signIn.errors.submit.network,
          unauthorized: () => t.signIn.errors.submit.unauthorized,
          unknow: () => t.signIn.errors.submit.unknow,
          notVerified: () => t.signIn.errors.submit.notVerified,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      },
      right: (_) => context.goNamed(Routes.home),
    );
  }
}
