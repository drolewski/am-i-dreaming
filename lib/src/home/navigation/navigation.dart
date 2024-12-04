import 'package:am_i_dreaming/src/view/dreams/dream_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              return CupertinoPageScaffold(
                child: _navigationTab(
                    context, index), // implementation of tabs in navigation
              );
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
      return Text(AppLocalizations.of(context)!.horoscopes);
    case 2:
      return Text(AppLocalizations.of(context)!.user);
    default:
      return const Text("null");
  }
}
