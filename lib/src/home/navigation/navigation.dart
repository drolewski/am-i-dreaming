import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../app_state.dart';
import '../../view/dreams/dream_input.dart';
import '../../view/dreams/dreams_list.dart';

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
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 60.0),
                    ),
                    Expanded(
                      flex: 3,
                        child: Consumer<ApplicationState>(
                      builder: (context, appState, _) => Center(
                          child: DreamsList(
                              dreamDocuments: appState.dreamDocuments)),
                    )),
                    Container(
                        padding: const EdgeInsets.only(bottom: 80),
                        // margin: EdgeInsets.all(100),
                        child: Consumer<ApplicationState>(
                            builder: (context, appState, _) => Center(
                                  child: DreamInput(
                                      addDream: (dream) =>
                                          appState.addNewDream(dream)),
                                )))
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
