import 'dart:async';

import 'package:am_i_dreaming/src/component/detail_list_record.dart';
import 'package:am_i_dreaming/src/functions/astrological_calculator.dart';
import 'package:am_i_dreaming/src/service/country_provider.dart';
import 'package:am_i_dreaming/src/state/app_state.dart';
import 'package:am_i_dreaming/src/view/users/user_details_records.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../ads/banner_ad_component.dart';
import '../../ads/rewarded_ad.dart';
import '../../component/detail_record.dart';
import '../../logic/zodiac/translate/element_translator.dart';
import '../../logic/zodiac/translate/quality_translator.dart';
import '../../model/sex_enum.dart';
import '../../util/date_formater.dart';

class UserDetailsView extends StatefulWidget {
  const UserDetailsView({super.key});

  @override
  State<StatefulWidget> createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends State<UserDetailsView> {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _rewardedRefresh = false;

  bool get rewardedRefresh => _rewardedRefresh;

  final CountryProvider countryProvider = CountryProvider();
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
        builder: (context, appState, child) => isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  trailing: GestureDetector(
                      onTap: () async {
                        if (rewardedAd.rewardedAd != null) {
                          rewardedAd.rewardedAd?.show(
                            onUserEarnedReward: (_, reward) async {
                              setState(() {
                                _isLoading = true;
                              });
                              try {
                                var userAstrologicalData =
                                    await astrologicalCalculator(appState
                                        .userDocument.birthdayTimestampUTC);
                                await appState
                                    .updateUserData(userAstrologicalData);
                              } finally {
                                setState(() {
                                  _isLoading = false;
                                  _rewardedRefresh = false;
                                });
                              }
                            },
                          );
                        }
                      },
                      child: !isLoading
                          ? const Icon(
                              CupertinoIcons.arrow_2_circlepath_circle_fill)
                          : null),
                  middle: Text(AppLocalizations.of(context)!.user),
                ),
                child: SafeArea(
                    child: Container(
                        margin:
                            const EdgeInsets.only(right: 20, left: 20, top: 20),
                        child: SingleChildScrollView(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BannerAdWidget(),
                            Text(
                              appState.userDocument.name,
                              style: const TextStyle(
                                  fontSize: 36, fontWeight: FontWeight.w600),
                            ),
                            DetailsRecord(
                              label: AppLocalizations.of(context)!.birth_date,
                              value: formatTimestampToDateTime(context,
                                  appState.userDocument.birthdayTimestampUTC),
                            ),
                            DetailsRecord(
                              label: AppLocalizations.of(context)!.birth_place,
                              value:
                                  "${appState.userDocument.birthCity}, ${countryProvider.getCountryName(context, appState.userDocument.birthCountryCode)}",
                            ),
                            DetailsRecord(
                              label: AppLocalizations.of(context)!.sex,
                              value: SexEnum.translate(
                                  context, appState.userDocument.sex),
                            ),
                            DetailsRecord(
                              label: AppLocalizations.of(context)!.sun_zodiac,
                              value: toZodiacRecord(
                                  context, appState.userDocument.sunZodiac),
                            ),
                            DetailsRecord(
                              label: AppLocalizations.of(context)!.lunar_zodiac,
                              value: toZodiacRecord(
                                  context, appState.userDocument.lunarZodiac),
                            ),
                            DetailsRecord(
                              label: AppLocalizations.of(context)!.ascendant,
                              value: toZodiacRecord(
                                  context, appState.userDocument.ascendant),
                            ),
                            DetailsRecord(
                              label:
                                  AppLocalizations.of(context)!.zodiac_element,
                              value: translateElement(
                                  context, appState.userDocument.zodiacElement),
                            ),
                            DetailsRecord(
                              label:
                                  AppLocalizations.of(context)!.zodiac_quality,
                              value: translateQuality(
                                  context, appState.userDocument.zodiacQuality),
                            ),
                            DetailsRecord(
                              label: AppLocalizations.of(context)!.moon_phase,
                              value: toMoonPhaseRecord(
                                  context, appState.userDocument.moonPhase),
                            ),
                            DetailListRecord(
                                label: AppLocalizations.of(context)!
                                    .astrological_house,
                                values: toHousesRecords(
                                    context, appState.userDocument.houses)),
                            DetailsRecord(
                              label:
                                  AppLocalizations.of(context)!.next_sun_return,
                              value: formatTimestampToDateTime(
                                  context, appState.userDocument.sunReturnDate),
                            ),
                            DetailsRecord(
                                label: AppLocalizations.of(context)!
                                    .next_moon_return,
                                value: formatTimestampToDateTime(context,
                                    appState.userDocument.moonReturnDate)),
                            Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Center(
                                    child: SizedBox(
                                        width: double.infinity,
                                        child: CupertinoButton(
                                            child: Text(
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                AppLocalizations.of(context)!
                                                    .logout),
                                            onPressed: () {
                                              _signOut(appState);
                                            })))),
                            Center(
                                child: SizedBox(
                                    width: double.infinity,
                                    child: CupertinoButton(
                                        child: Text(
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400),
                                            AppLocalizations.of(context)!
                                                .delete_account),
                                        onPressed: () => Navigator.of(context)
                                            .restorablePush(_modalBuilder))))
                          ],
                        ))))));
  }

  Future<void> _signOut(ApplicationState appState) async {
    context.pushReplacement("/login");
    await FirebaseAuth.instance.signOut();
    appState.destroy();
  }

  @pragma('vm:entry-point')
  static Route<void> _modalBuilder(BuildContext context, Object? arguments) {
    return CupertinoModalPopupRoute<void>(
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(AppLocalizations.of(context)!.delete_account),
          message:
              Text(AppLocalizations.of(context)!.delete_account_question_modal),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              child: Text(AppLocalizations.of(context)!.yes),
              onPressed: () {
                // logout -> logout should redirect also
                // remove account
                // redirect to login view
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: Text(AppLocalizations.of(context)!.no),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
