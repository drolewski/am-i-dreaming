import 'dart:async';

import 'package:am_i_dreaming/src/component/detail_list_record.dart';
import 'package:am_i_dreaming/src/component/premium_button.dart';
import 'package:am_i_dreaming/src/model/user_document.dart';
import 'package:am_i_dreaming/src/service/country_provider.dart';
import 'package:am_i_dreaming/src/view/users/user_details_records.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../component/detail_record.dart';
import '../../logic/zodiac/translate/element_translator.dart';
import '../../logic/zodiac/translate/quality_translator.dart';
import '../../model/sex_enum.dart';
import '../../util/date_formater.dart';

class UserView extends StatefulWidget {
  UserView(
      {super.key,
      required this.userDocument,
      required this.updateUserDetails}) {
    countryProvider = CountryProvider();
  }

  final UserDocument? userDocument;

  late final CountryProvider countryProvider;
  final Future<void> Function(String id, int timestamp) updateUserDetails;

  @override
  State<StatefulWidget> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  bool _isReloading = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          trailing: GestureDetector(
              onTap: () {
                performAction();
              },
              child: !_isReloading
                  ? const Icon(CupertinoIcons.arrow_2_circlepath_circle_fill)
                  : null),
          middle: Text(AppLocalizations.of(context)!.user),
        ),
        child: SafeArea(
            child: Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                child: _isReloading || widget.userDocument == null
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : SingleChildScrollView(child: _displayUser()))));
  }

  Column _displayUser() {
    // reload view screen on click
    // Tooltips on user details to describe specific details (Maybe whole screen to describe it?)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PremiumButton(),
        Text(
          widget.userDocument!.name,
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
        ),
        DetailsRecord(
          label: AppLocalizations.of(context)!.birth_date,
          value: formatTimestampToDateTime(
              context, widget.userDocument!.birthdayTimestampUTC),
        ),
        DetailsRecord(
          label: AppLocalizations.of(context)!.birth_place,
          value:
              "${widget.userDocument!.birthCity}, ${widget.countryProvider.getCountryName(context, widget.userDocument!.birthCountryCode)}",
        ),
        DetailsRecord(
          label: AppLocalizations.of(context)!.sex,
          value: SexEnum.translate(context, widget.userDocument!.sex),
        ),
        DetailsRecord(
          label: AppLocalizations.of(context)!.sun_zodiac,
          value: toZodiacRecord(context, widget.userDocument!.sunZodiac),
        ),
        DetailsRecord(
          label: AppLocalizations.of(context)!.lunar_zodiac,
          value: toZodiacRecord(context, widget.userDocument!.lunarZodiac),
        ),
        DetailsRecord(
          label: AppLocalizations.of(context)!.ascendant,
          value: toZodiacRecord(context, widget.userDocument!.ascendant),
        ),
        DetailsRecord(
          label: AppLocalizations.of(context)!.zodiac_element,
          value: translateElement(context, widget.userDocument!.zodiacElement),
        ),
        DetailsRecord(
          label: AppLocalizations.of(context)!.zodiac_quality,
          value: translateQuality(context, widget.userDocument!.zodiacQuality),
        ),
        DetailsRecord(
          label: AppLocalizations.of(context)!.moon_phase,
          value: toMoonPhaseRecord(context, widget.userDocument!.moonPhase),
        ),
        DetailListRecord(
            label: AppLocalizations.of(context)!.astrological_house,
            values: toHousesRecords(context, widget.userDocument!.houses)),
        DetailsRecord(
          label: AppLocalizations.of(context)!.next_sun_return,
          value: formatTimestampToDateTime(
              context, widget.userDocument!.sunReturnDate),
        ),
        DetailsRecord(
            label: AppLocalizations.of(context)!.next_moon_return,
            value: formatTimestampToDateTime(
                context, widget.userDocument!.moonReturnDate)),
        Container(
            margin: const EdgeInsets.only(top: 10),
            child: Center(
                child: SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                        child: Text(
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                            AppLocalizations.of(context)!.logout),
                        onPressed: () => FirebaseAuth.instance.signOut())))),
        Center(
            child: SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                    child: Text(
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                        AppLocalizations.of(context)!.delete_account),
                    onPressed: () =>
                        Navigator.of(context).restorablePush(_modalBuilder))))
      ],
    );
  }

  Future<void> performAction() async {
    setState(() {
      _isReloading = true;
    });
    try {
      await Future.delayed(Duration(seconds: 1));
      widget.updateUserDetails(
          widget.userDocument!.id, widget.userDocument!.birthdayTimestampUTC);
      await Future.delayed(Duration(seconds: 1));
    } finally {
      setState(() {
        _isReloading = false;
      });
    }
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
