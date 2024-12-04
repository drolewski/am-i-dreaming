import 'package:am_i_dreaming/src/model/zodiac_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String translateZodiac(BuildContext context, ZodiacEnum zodiac) {
  switch (zodiac) {
    case ZodiacEnum.aries:
      return AppLocalizations.of(context)!.aries;
    case ZodiacEnum.taurus:
      return AppLocalizations.of(context)!.taurus;
    case ZodiacEnum.gemini:
      return AppLocalizations.of(context)!.gemini;
    case ZodiacEnum.cancer:
      return AppLocalizations.of(context)!.cancer;
    case ZodiacEnum.leo:
      return AppLocalizations.of(context)!.leo;
    case ZodiacEnum.virgo:
      return AppLocalizations.of(context)!.virgo;
    case ZodiacEnum.libra:
      return AppLocalizations.of(context)!.libra;
    case ZodiacEnum.scorpio:
      return AppLocalizations.of(context)!.scorpio;
    case ZodiacEnum.sagittarius:
      return AppLocalizations.of(context)!.sagittarius;
    case ZodiacEnum.capricorn:
      return AppLocalizations.of(context)!.capricorn;
    case ZodiacEnum.aquarius:
      return AppLocalizations.of(context)!.aquarius;
    case ZodiacEnum.pisces:
      return AppLocalizations.of(context)!.pisces;
    default:
      return AppLocalizations.of(context)!.unknown_zodiac;
  }
}