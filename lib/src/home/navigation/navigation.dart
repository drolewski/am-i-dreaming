import 'package:firebase_auth/firebase_auth.dart';
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
                // navigationBar: const CupertinoNavigationBar(),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 60.0),
                    ),
                    Center(child: Text(_tabName(context, index))),
                    Center(
                      child: CupertinoButton(
                          child: const Text("logout"),
                          onPressed: () => FirebaseAuth.instance.signOut()),
                    )
                  ],
                ), // implementation of tabs in navigation
              );
            },
          );
        });
  }
}

String _tabName(BuildContext context, int index) {
  switch (index) {
    case 0:
      return AppLocalizations.of(context)!.dreams;
    case 1:
      return AppLocalizations.of(context)!.horoscopes;
    case 2:
      return AppLocalizations.of(context)!.user;
    default:
      return "null";
  }
}
