import 'package:am_i_dreaming/src/functions/horoscopes.dart';
import 'package:am_i_dreaming/src/model/user_status.dart';
import 'package:am_i_dreaming/src/state/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../ads/banner_ad_component.dart';
import '../../model/horoscope_model.dart';
import 'horoscope_row.dart';

class HoroscopesView extends StatefulWidget {
  const HoroscopesView({super.key});

  @override
  State<StatefulWidget> createState() => _HoroscopeViewState();
}

class _HoroscopeViewState extends State<HoroscopesView> {
  final _key = GlobalKey();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, appState, _) => _isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : Column(
                children: [
                  const BannerAdWidget(),
                  Container(
                      margin: const EdgeInsets.only(top: 24, bottom: 24),
                      child: Center(
                          child: SizedBox(
                              width: double.infinity,
                              child: appState.userStatus
                                          ?.isSingleHoroscopeGenerated ==
                                      true
                                  ? appState.userStatus
                                              ?.areAllHoroscopesGenerated ==
                                          true
                                      ? personalizedHoroscopesButton(appState)
                                      : allHoroscopesButton(appState)
                                  : singleHoroscopeButton(appState)))),
                  personalizedHoroscope(appState),
                  horoscopeList(appState)
                ],
              ));
  }

  Widget singleHoroscopeButton(ApplicationState appState) {
    return CupertinoButton.filled(
        child: Text(
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            AppLocalizations.of(context)!
                .horoscopes_button_generate_horoscope_for_my_zodiac(
                    appState.userDocument.sunZodiac.toModel().icon)),
        onPressed: () async {
          setState(() {
            _isLoading = true;
          });
          await horoscope(AppLocalizations.of(context)!.language,
              appState.userDocument.sunZodiac);
          await appState.updateHoroscopes();
          appState.upsertUserStatus(UserStatus(
              id: appState.userStatus?.id,
              updatedAt: DateTime.now().millisecondsSinceEpoch,
              isSingleHoroscopeGenerated: true,
              areAllHoroscopesGenerated:
                  appState.userStatus?.areAllHoroscopesGenerated ?? false,
              isPersonalizedHoroscopeGenerated:
                  appState.userStatus?.isPersonalizedHoroscopeGenerated ??
                      false,
              numberOfDreams: appState.userStatus?.numberOfDreams ?? 0));
          setState(() {
            _isLoading = false;
          });
        });
  }

  Widget allHoroscopesButton(ApplicationState appState) {
    return CupertinoButton.filled(
        child: Text(
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            AppLocalizations.of(context)!
                .horoscopes_button_generate_other_horoscopes),
        onPressed: () async {
          setState(() {
            _isLoading = true;
          });
          await appState.updateHoroscopes();
          appState.upsertUserStatus(UserStatus(
              id: appState.userStatus?.id,
              updatedAt: DateTime.now().millisecondsSinceEpoch,
              isSingleHoroscopeGenerated: true,
              areAllHoroscopesGenerated: true,
              isPersonalizedHoroscopeGenerated:
                  appState.userStatus?.isPersonalizedHoroscopeGenerated ??
                      false,
              numberOfDreams: appState.userStatus?.numberOfDreams ?? 0));
          setState(() {
            _isLoading = false;
          });
        });
  }

  Widget personalizedHoroscopesButton(ApplicationState appState) {
    return CupertinoButton.filled(
        child: Text(
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            AppLocalizations.of(context)!
                .horoscopes_button_generate_personalized_horoscope),
        onPressed: () async {
          setState(() {
            _isLoading = true;
          });
          appState.updateHoroscopes();
          appState.upsertUserStatus(UserStatus(
              id: appState.userStatus?.id,
              updatedAt: DateTime.now().millisecondsSinceEpoch,
              isSingleHoroscopeGenerated: true,
              areAllHoroscopesGenerated: true,
              isPersonalizedHoroscopeGenerated: true,
              numberOfDreams: appState.userStatus?.numberOfDreams ?? 0));
          setState(() {
            _isLoading = false;
          });
        });
  }

  Widget personalizedHoroscope(ApplicationState appState) {
    return appState.userStatus?.isPersonalizedHoroscopeGenerated == true
        ? const Text("Personalized horoscope")
        : const Text("");
  }

  Widget horoscopeList(ApplicationState appState) {
    final resHoroscopes = sortedListOfHoroscopes(appState);
    return Expanded(
        child: appState.horoscopesSet &&
                appState.horoscopes.isNotEmpty &&
                appState.userStatus?.isSingleHoroscopeGenerated == true
            ? appState.userStatus?.isSingleHoroscopeGenerated == true &&
                    appState.userStatus?.areAllHoroscopesGenerated == true
                ? AnimatedList(
                    key: _key,
                    reverse: false,
                    initialItemCount: resHoroscopes.length,
                    itemBuilder: (_, int index, Animation<double> animation) {
                      return HoroscopeRow(horoscope: resHoroscopes[index]);
                    },
                  )
                : HoroscopeRow(horoscope: resHoroscopes[0])
            : const Text("Generate horoscopes"));
  }

  List<Horoscope> sortedListOfHoroscopes(ApplicationState appState) {
    final resHoroscopes = appState.horoscopes.where((hor) {
      return hor.language == AppLocalizations.of(context)!.language;
    }).toList();
    resHoroscopes.sort((a, b) {
      if (appState.userDocument.sunZodiac == a.zodiac.name &&
          appState.userDocument.sunZodiac != b.zodiac.name) {
        return -1;
      }
      if (appState.userDocument.sunZodiac == b.zodiac.name &&
          appState.userDocument.sunZodiac != a.zodiac.name) {
        return 1;
      }
      return a.zodiac.name.name.compareTo(b.zodiac.name.name);
    });
    return resHoroscopes;
  }
}
