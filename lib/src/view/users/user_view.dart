import 'package:am_i_dreaming/src/component/detail_list_record.dart';
import 'package:am_i_dreaming/src/component/premium_button.dart';
import 'package:am_i_dreaming/src/logic/astrological_house/translate/astrological_house_translate.dart';
import 'package:am_i_dreaming/src/logic/lunar_zodiac/lunar_zodiac.dart';
import 'package:am_i_dreaming/src/logic/moon/moon_phase.dart';
import 'package:am_i_dreaming/src/logic/sun_zodiac/translate/element_translator.dart';
import 'package:am_i_dreaming/src/model/planet_return.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../component/detail_record.dart';
import '../../logic/astrological_house/astrological_house.dart';
import '../../logic/moon/translate/moon_phase_translator.dart';
import '../../logic/planet_return/planet_return.dart';
import '../../logic/sun_zodiac/sun_zodiac.dart';
import '../../logic/sun_zodiac/translate/quality_translator.dart';
import '../../logic/sun_zodiac/translate/zodiac_translator.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<StatefulWidget> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  var _isReloading = false;
  var _planetReturns = PlanetReturnModel(
      sunReturnDate: DateTime.now(), moonReturnDate: DateTime.now());

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          trailing: GestureDetector(
              onTap: () {
                _reloadReturns(903518153000);
              },
              child: !_isReloading
                  ? const Icon(CupertinoIcons.arrow_2_circlepath_circle_fill)
                  : null),
          middle: Text(AppLocalizations.of(context)!.user),
        ),
        child: Padding(
            padding: const EdgeInsets.only(
                top: 120.0, left: 20.0, right: 20.0, bottom: 80),
            child: SingleChildScrollView(
                child: _isReloading ? _reloading() : _displayUser())));
  }

  Column _displayUser() {
    final date = 903518153000; //Monika: 903518153000; Dominik: 892100939000
    final sunZodiacValue = sunZodiac(date);
    final lunarZodiacValue = lunarZodiac(date);
    final zodiacElement = element(sunZodiacValue.name);
    final zodiacQuality = quality(sunZodiacValue.name);
    final moonPhaseValue = moonPhase(date);
    final astrologicalHouseList = astrologicalHouses(date);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PremiumButton(),
        const Padding(
            padding: EdgeInsets.only(top: 6, bottom: 12),
            child: Text(
              "Dominik",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
            )),
        DetailsRecord(
          label: AppLocalizations.of(context)!.birth_date,
          value: "05:48 09.04.1998",
        ),
        DetailsRecord(
          label: AppLocalizations.of(context)!.birth_place,
          value: "Poznańxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx, Polska",
        ),
        DetailsRecord(
          label: AppLocalizations.of(context)!.sex,
          value: "Mężczyzna",
        ),
        DetailsRecord(
          label: AppLocalizations.of(context)!.sun_zodiac,
          value:
              "${translateZodiac(context, sunZodiacValue.name)} ${sunZodiacValue.icon}",
        ),
        DetailsRecord(
          label: AppLocalizations.of(context)!.lunar_zodiac,
          value:
              "${translateZodiac(context, lunarZodiacValue.name)} ${lunarZodiacValue.icon}",
        ),
        DetailsRecord(
          label: AppLocalizations.of(context)!.zodiac_element,
          value: translateElement(context, zodiacElement),
        ),
        DetailsRecord(
          label: AppLocalizations.of(context)!.zodiac_quality,
          value: translateQuality(context, zodiacQuality),
        ),
        DetailsRecord(
          label: AppLocalizations.of(context)!.moon_phase,
          value:
              "${translateMoonPhase(context, moonPhaseValue.name)} ${moonPhaseValue.icon}",
        ),
        DetailListRecord(
            label: AppLocalizations.of(context)!.astrological_house,
            values:
                translateAstrologicalHouses(context, astrologicalHouseList)),
        DetailsRecord(
          label: AppLocalizations.of(context)!.next_sun_return,
          value: AppLocalizations.of(context)!.formattedDateTime(
              _planetReturns.sunReturnDate, _planetReturns.sunReturnDate),
        ),
        DetailsRecord(
            label: AppLocalizations.of(context)!.next_moon_return,
            value: AppLocalizations.of(context)!.formattedDateTime(
                _planetReturns.moonReturnDate, _planetReturns.moonReturnDate)),
        Container(
            margin: EdgeInsets.only(top: 10),
            child: Center(
                child: SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                        child: Text(AppLocalizations.of(context)!.logout),
                        onPressed: () => FirebaseAuth.instance.signOut())))),
        Container(
            margin: const EdgeInsets.only(top: 10),
            child: Center(
                child: SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                        child:
                            Text(AppLocalizations.of(context)!.delete_account),
                        onPressed: () => Navigator.of(context)
                            .restorablePush(_modalBuilder)))))
      ],
    );
  }

  Column _reloading() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator.adaptive(),
      ],
    );
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

  void _reloadReturns(int timestamp) {
    setState(() {
      _isReloading = true;
    });
    setState(() {
      _planetReturns = calculatePlanetReturn(timestamp);;
    });
    setState(() {

      _isReloading = false;
    });
    print(_planetReturns.moonReturnDate);
  }
}
