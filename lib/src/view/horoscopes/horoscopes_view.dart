import 'package:am_i_dreaming/src/functions/horoscopes.dart';
import 'package:am_i_dreaming/src/model/user_status.dart';
import 'package:am_i_dreaming/src/state/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../ads/banner_ad_component.dart';
import '../../ads/rewarded_ad.dart';
import '../../functions/personalized_horoscope.dart';
import '../../model/horoscope_model.dart';
import 'horoscope_row.dart';

// TODO refactor structure of this component
class HoroscopesView extends StatefulWidget {
  const HoroscopesView({super.key});

  @override
  State<StatefulWidget> createState() => _HoroscopeViewState();
}

class _HoroscopeViewState extends State<HoroscopesView> {
  final _key = GlobalKey();
  bool _isLoading = false;
  final DateTime _todayDate = DateTime.now();

  final RewardedAdUtil rewardedAd = RewardedAdUtil();

  @override
  void initState() {
    rewardedAd.loadRewardedAd();
    super.initState();
  }

  @override
  void dispose() {
    rewardedAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, appState, _) => _isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : Column(
                children: [
                  const BannerAdWidget(),
                  Center(
                      child: SizedBox(
                          width: double.infinity,
                          child: appState.userStatus
                                          ?.isSingleHoroscopeGenerated ==
                                      true &&
                                  _compareDates(appState)
                              ? appState.userStatus
                                          ?.areAllHoroscopesGenerated ==
                                      true
                                  ? appState.userStatus
                                              ?.isPersonalizedHoroscopeGenerated ==
                                          true
                                      ? const SizedBox.shrink()
                                      : personalizedHoroscopesButton(appState)
                                  : allHoroscopesButton(appState)
                              : singleHoroscopeButton(appState))),
                  horoscopeList(appState)
                ],
              ));
  }

  Widget singleHoroscopeButton(ApplicationState appState) {
    return Container(
        margin: const EdgeInsets.only(top: 24, bottom: 24),
        child: CupertinoButton.filled(
            child: Text(
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                AppLocalizations.of(context)!
                    .horoscopes_button_generate_horoscope_for_my_zodiac(
                        appState.userDocument.sunZodiac.toModel().icon)),
            onPressed: () async {
              if (rewardedAd.rewardedAd != null) {
                rewardedAd.rewardedAd?.show(
                  onUserEarnedReward: (_, reward) async {
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
                        areAllHoroscopesGenerated: false,
                        isPersonalizedHoroscopeGenerated: false,
                        numberOfDreams: appState.userStatus?.numberOfDreams ?? 0));
                    setState(() {
                      _isLoading = false;
                    });
                  },
                );
              }
            }));
  }

  Widget allHoroscopesButton(ApplicationState appState) {
    return Container(
        margin: const EdgeInsets.only(top: 24, bottom: 24),
        child: CupertinoButton.filled(
            child: Text(
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                AppLocalizations.of(context)!
                    .horoscopes_button_generate_other_horoscopes),
            onPressed: () async {
              if (rewardedAd.rewardedAd != null) {
                rewardedAd.rewardedAd?.show(
                  onUserEarnedReward: (_, reward) async {
                    setState(() {
                      _isLoading = true;
                    });
                    await appState.updateHoroscopes();
                    appState.upsertUserStatus(UserStatus(
                        id: appState.userStatus?.id,
                        updatedAt: DateTime.now().millisecondsSinceEpoch,
                        isSingleHoroscopeGenerated: true,
                        areAllHoroscopesGenerated: true,
                        isPersonalizedHoroscopeGenerated: false,
                        numberOfDreams: appState.userStatus?.numberOfDreams ?? 0));
                    setState(() {
                      _isLoading = false;
                    });
                  },
                );
              }
            }));
  }

  Widget personalizedHoroscopesButton(ApplicationState appState) {
    return Container(
        margin: const EdgeInsets.only(top: 24, bottom: 24),
        child: CupertinoButton.filled(
            child: Text(
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                AppLocalizations.of(context)!
                    .horoscopes_button_generate_personalized_horoscope),
            onPressed: () async {
              if (rewardedAd.rewardedAd != null) {
                rewardedAd.rewardedAd?.show(
                  onUserEarnedReward: (_, reward) async {
                    setState(() {
                      _isLoading = true;
                    });
                    await personalizedHoroscope(
                        AppLocalizations.of(context)!.language,
                        FirebaseAuth.instance.currentUser!.uid,
                        appState.userDocument.birthdayTimestampUTC,
                        appState.userDocument.birthCity);
                    appState.updateHoroscopes();
                    appState.updatePersonalizedHoroscope();
                    appState.upsertUserStatus(UserStatus(
                        id: appState.userStatus?.id,
                        updatedAt: DateTime.now().millisecondsSinceEpoch,
                        isSingleHoroscopeGenerated: true,
                        areAllHoroscopesGenerated: true,
                        isPersonalizedHoroscopeGenerated: true,
                        numberOfDreams:
                            appState.userStatus?.numberOfDreams ?? 0));
                    setState(() {
                      _isLoading = false;
                    });
                  },
                );
              }
            }));
  }

  Widget horoscopeList(ApplicationState appState) {
    final resHoroscopes = sortedListOfHoroscopes(appState).map((h) {
      return HoroscopeListRow(
          header: '${h.zodiac.icon} ${_capitalize(h.zodiac.name.name)}',
          language: h.language,
          date: h.date,
          value: h.value);
    }).toList();
    if (appState.personalizedHoroscopeDocument != null) {
      resHoroscopes.insert(
          0,
          HoroscopeListRow(
              header: AppLocalizations.of(context)!.personalized_horoscope,
              language: appState.personalizedHoroscopeDocument?.language ?? '',
              date: appState.personalizedHoroscopeDocument?.date ?? '',
              value: appState.personalizedHoroscopeDocument?.horoscope ?? ''));
    }
    return Expanded(
        child: appState.horoscopesSet &&
                appState.horoscopes.isNotEmpty &&
                appState.userStatus?.isSingleHoroscopeGenerated == true &&
                _compareDates(appState)
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
            : Text(AppLocalizations.of(context)!.generate_horoscopes));
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

  String _capitalize(String name) {
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }

  bool _compareDates(ApplicationState appState) {
    final date1 = DateTime.fromMillisecondsSinceEpoch(
        appState.userStatus?.updatedAt ?? 0);
    var result = _todayDate.year == date1.year &&
        _todayDate.month == date1.month &&
        _todayDate.day == date1.day;
    if (!result) {
      appState.upsertUserStatus(UserStatus(
          id: appState.userStatus?.id,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
          isSingleHoroscopeGenerated: false,
          areAllHoroscopesGenerated: false,
          isPersonalizedHoroscopeGenerated: false,
          numberOfDreams: appState.userStatus?.numberOfDreams ?? 0));
    }
    return result;
  }
}
