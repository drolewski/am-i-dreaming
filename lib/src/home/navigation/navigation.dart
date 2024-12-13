import 'package:am_i_dreaming/src/model/user_document.dart';
import 'package:am_i_dreaming/src/state/app_state.dart';
import 'package:am_i_dreaming/src/view/dreams/dream_view.dart';
import 'package:am_i_dreaming/src/view/users/user_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../view/horoscopes/horoscopes_options.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, appState, _) => CupertinoTabScaffold(
            tabBar: CupertinoTabBar(items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: const Icon(CupertinoIcons.moon_zzz_fill),
                  label: AppLocalizations.of(context)!.dreams),
              // dreams
              BottomNavigationBarItem(
                  // zodiac icon based on zodiac symbol of user
                  icon: getHoroscopeIcon(appState.userDocument),
                  label: AppLocalizations.of(context)!.horoscopes),
              // horoscopes
              BottomNavigationBarItem(
                  // zodiac icon based on zodiac symbol of user
                  icon: const Icon(CupertinoIcons.person_fill),
                  label: AppLocalizations.of(context)!.user)
              // user
            ]),
            tabBuilder: (BuildContext context, int index) {
              return CupertinoTabView(
                builder: (BuildContext context) {
                  return _navigationTab(context, index);
                },
              );
            }));
  }

  Widget getHoroscopeIcon(UserDocument userDocument) {
    if (userDocument == UserDocument.empty()) {
      return const Icon(CupertinoIcons.star_fill);
    }
    return Text(
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        userDocument.sunZodiac.toModel().icon);
  }

  Widget _navigationTab(BuildContext context, int index) {
    switch (index) {
      case 0:
        return const DreamView();
      case 1:
        return const HoroscopesOptions();
      case 2:
        return const UserView();
      default:
        return const CupertinoPageScaffold(child: Text("null"));
    }
  }
}
