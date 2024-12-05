import 'package:am_i_dreaming/src/view/dreams/dream_view.dart';
import 'package:am_i_dreaming/src/view/users/user_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../app_state.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.moon_zzz_fill),
              label: AppLocalizations.of(context)!.dreams), // dreams
          BottomNavigationBarItem(
              // zodiac icon based on zodiac symbol of user
              icon: const Icon(CupertinoIcons.star_fill),
              label: AppLocalizations.of(context)!.horoscopes), // horoscopes
          BottomNavigationBarItem(
              // zodiac icon based on zodiac symbol of user
              icon: const Icon(CupertinoIcons.person_fill),
              label: AppLocalizations.of(context)!.user) // user
        ]),
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(
            builder: (BuildContext context) {
              return _navigationTab(context, 2);
            },
          );
        });
  }
}

Widget _navigationTab(BuildContext context, int index) {
  switch (index) {
    case 0:
      return const DreamView();
    case 1:
      return const Text("horoskopy");
    case 2:
      return Consumer<ApplicationState>(
          builder: (context, appState, _) =>
              UserView(userDocument: appState.userDocument));
    default:
      return const CupertinoPageScaffold(child: Text("null"));
  }
}
