import 'package:am_i_dreaming/src/component/detail_list_record.dart';
import 'package:am_i_dreaming/src/component/premium_button.dart';
import 'package:am_i_dreaming/src/view/users/user_details_records.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../component/detail_record.dart';
import '../../logic/zodiac/translate/element_translator.dart';
import '../../logic/zodiac/translate/quality_translator.dart';
import '../../service/user_astrological_details_calculator.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<StatefulWidget> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  var _isReloading = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          trailing: GestureDetector(
              onTap: () {
                _isReloading != _isReloading;
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
    // implement data input screen view :)
    // Store it into DB
    // reload view screen on click
    // Tooltips on user details to describe specific details (Maybe whole screen to describe it?)
    UserAstrologicalDetailsCalculator userAstrologicalDetailsCalculator =
        UserAstrologicalDetailsCalculator(birthdayTimestamp: 903518153000);
    final details = userAstrologicalDetailsCalculator.userAstrologicalDetails();
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
          value: toZodiacRecord(context, details.sunZodiac),
        ),
        DetailsRecord(
          label: AppLocalizations.of(context)!.lunar_zodiac,
          value: toZodiacRecord(context, details.lunarZodiac),
        ),
        DetailsRecord(
          label: AppLocalizations.of(context)!.ascendant,
          value: toZodiacRecord(context, details.ascendant),
        ),
        DetailsRecord(
          label: AppLocalizations.of(context)!.zodiac_element,
          value: translateElement(context, details.zodiacElement),
        ),
        DetailsRecord(
          label: AppLocalizations.of(context)!.zodiac_quality,
          value: translateQuality(context, details.zodiacQuality),
        ),
        DetailsRecord(
          label: AppLocalizations.of(context)!.moon_phase,
          value: toMoonPhaseRecord(context, details.moonPhase),
        ),
        DetailListRecord(
            label: AppLocalizations.of(context)!.astrological_house,
            values: toHousesRecords(context, details.houses)),
        DetailsRecord(
          label: AppLocalizations.of(context)!.next_sun_return,
          value: AppLocalizations.of(context)!.formattedDateTime(
              details.planetReturn.sunReturnDate,
              details.planetReturn.sunReturnDate),
        ),
        DetailsRecord(
            label: AppLocalizations.of(context)!.next_moon_return,
            value: AppLocalizations.of(context)!.formattedDateTime(
                details.planetReturn.moonReturnDate,
                details.planetReturn.moonReturnDate)),
        Container(
            margin: EdgeInsets.only(top: 10),
            child: Center(
                child: SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                        child: Text(AppLocalizations.of(context)!.logout),
                        onPressed: () => FirebaseAuth.instance.signOut())))),
        Container(
            margin: const EdgeInsets.only(top: 10, bottom: 20),
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
}
