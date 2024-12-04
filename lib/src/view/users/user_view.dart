import 'package:am_i_dreaming/src/component/premium_button.dart';
import 'package:am_i_dreaming/src/logic/lunar_zodiac/lunar_zodiac.dart';
import 'package:am_i_dreaming/src/logic/moon/moon_phase.dart';
import 'package:am_i_dreaming/src/logic/sun_zodiac/translate/element_translator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../component/detail_record.dart';
import '../../logic/astrological_house/astrological_house.dart';
import '../../logic/moon/translate/moon_phase_translator.dart';
import '../../logic/sun_zodiac/translate/quality_translator.dart';
import '../../logic/sun_zodiac/translate/zodiac_translator.dart';
import '../../logic/sun_zodiac/sun_zodiac.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<StatefulWidget> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  var _isEditModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          trailing: GestureDetector(
              onTap: () =>
                  setState(() => _isEditModeEnabled = !_isEditModeEnabled),
              child: _isEditModeEnabled
                  ? const Icon(
                  CupertinoIcons.check_mark_circled_solid) // floppy_disk
                  : const Icon(CupertinoIcons.pencil)),
          middle: Text(AppLocalizations.of(context)!.user),
        ),
        child: Padding(
            padding: const EdgeInsets.only(
                top: 120.0, left: 20.0, right: 20.0, bottom: 80),
            child: SingleChildScrollView(
                child: _isEditModeEnabled ? _editUser() : _displayUser())));
  }

  Column _displayUser() {
    final date = 892100939000;//Monika: 903518153000; Dominik: 892100939000
    final longitude = 52.40981729368307;// Strzelno: 52.62711116548577, 18.17401839176394
    final latitude = 16.894916280501686; // Poznań: 52.40981729368307 16.894916280501686
    final sunZodiacValue = sunZodiac(date);
    final lunarZodiacValue = lunarZodiac(date, latitude, longitude);
    final zodiacElement = element(sunZodiacValue.name);
    final zodiacQuality = quality(sunZodiacValue.name);
    final moonPhaseValue = moonPhase(date);
    final astroHouse = AstroHouse(date, latitude, longitude);
    final ascendant = astroHouse.calculateAscendant();
    final houses = astroHouse.calculateHouses();
    print(houses);
    print(ascendant);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          value: "${translateMoonPhase(
              context, moonPhaseValue.name)} ${moonPhaseValue.icon}",
        ),
        DetailsRecord(
          label: AppLocalizations.of(context)!.astrological_house,
          value: "x",
        ),
        DetailsRecord(
          label: AppLocalizations.of(context)!.planetary_returns,
          value: "x",
        ),
        DetailsRecord(
          label: AppLocalizations.of(context)!.planets_system,
          value: "x",
        ),
        DetailsRecord(
          label: AppLocalizations.of(context)!.planetary_aspects,
          value: "x",
        ),
        const PremiumButton(),
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
                        onPressed: () =>
                            Navigator.of(context)
                                .restorablePush(_modalBuilder)))))
      ],
    );
  }

  Column _editUser() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Edit"),
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
}
