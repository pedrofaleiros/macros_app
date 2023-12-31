import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ios_macros/src/features/auth/presentation/controller/login_controller.dart';
import 'package:ios_macros/src/features/auth/presentation/viewmodel/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = context.read<LoginController>();
    final auth = context.read<AuthViewmodel>();

    return CupertinoButton.filled(
      onPressed: auth.isLoading
          ? null
          : () async => await auth.login(loginController.user),
      child: Observer(
        builder: (context) => auth.isLoading
            ? const CupertinoActivityIndicator()
            : const Text(
                'Login',
                style: TextStyle(color: CupertinoColors.white),
              ),
      ),
    );
  }
}
