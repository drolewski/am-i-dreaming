import 'package:am_i_dreaming/src/model/moon_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String translateMoonPhase(BuildContext context, MoonPhaseEnum moonPhase) {
  switch (moonPhase) {
    case MoonPhaseEnum.lastQuarter:
      return AppLocalizations.of(context)!.moon_last_quarter;
    case MoonPhaseEnum.firstQuarter:
      return AppLocalizations.of(context)!.moon_first_quarter;
    case MoonPhaseEnum.fullMoon:
      return AppLocalizations.of(context)!.moon_full;
    case MoonPhaseEnum.newMoon:
      return AppLocalizations.of(context)!.moon_new;
    default:
      return AppLocalizations.of(context)!.moon_new;
  }
}