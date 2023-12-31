import 'package:flutter/cupertino.dart';
import 'package:ios_macros/src/features/auth/presentation/viewmodel/auth_viewmodel.dart';
import 'package:ios_macros/src/features/home/presentation/view/pages/HB_page.dart';
import 'package:ios_macros/src/features/home/presentation/view/pages/edit_foods_page.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthViewmodel>();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(auth.sessionUser!.name),
      ),
      child: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoButton(
              padding: const EdgeInsets.all(0),
              onPressed: () async {
                final response = await showCupertinoModalPopup(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                    title: const Text('Fazer logout?'),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: () => Navigator.pop(context, false),
                        isDestructiveAction: true,
                        child: const Text('Não'),
                      ),
                      CupertinoDialogAction(
                        onPressed: () => Navigator.pop(context, true),
                        isDefaultAction: true,
                        child: const Text('Sim'),
                      ),
                    ],
                  ),
                );
                if (response) {
                  await auth.logout();
                }
              },
              child: const CupertinoListTile(
                // backgroundColor: CupertinoColors.systemFill,
                title: Text('Logout'),
              ),
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: CupertinoColors.systemFill,
            ),
            if (auth.sessionUser!.name == 'admin')
              CupertinoButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  if (auth.sessionUser!.name == 'admin') {
                    Navigator.pushNamed(context, EditFoodsPage.routeName);
                  }
                },
                child: const CupertinoListTile(
                  // backgroundColor: CupertinoColors.systemFill,
                  title: Text('Editar alimentos'),
                ),
              ),
            Container(
              height: 1,
              width: double.infinity,
              color: CupertinoColors.systemFill,
            ),
            CupertinoButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                Navigator.pushNamed(context, HBPage.routeName);
              },
              child: const CupertinoListTile(
                // backgroundColor: CupertinoColors.systemFill,
                title: Text('Harris-Benedict'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
