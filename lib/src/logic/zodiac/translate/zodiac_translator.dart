import 'package:am_i_dreaming/src/model/zodiac_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String translateZodiac(BuildContext context, ZodiacEnum zodiac) {
  switch (zodiac) {
    case ZodiacEnum.Aries:
      return AppLocalizations.of(context)!.aries;
    case ZodiacEnum.Taurus:
      return AppLocalizations.of(context)!.taurus;
    case ZodiacEnum.Gemini:
      return AppLocalizations.of(context)!.gemini;
    case ZodiacEnum.Cancer:
      return AppLocalizations.of(context)!.cancer;
    case ZodiacEnum.Leo:
      return AppLocalizations.of(context)!.leo;
    case ZodiacEnum.Virgo:
      return AppLocalizations.of(context)!.virgo;
    case ZodiacEnum.Libra:
      return AppLocalizations.of(context)!.libra;
    case ZodiacEnum.Scorpio:
      return AppLocalizations.of(context)!.scorpio;
    case ZodiacEnum.Sagittarius:
      return AppLocalizations.of(context)!.sagittarius;
    case ZodiacEnum.Capricorn:
      return AppLocalizations.of(context)!.capricorn;
    case ZodiacEnum.Aquarius:
      return AppLocalizations.of(context)!.aquarius;
    case ZodiacEnum.Pisces:
      return AppLocalizations.of(context)!.pisces;
    default:
      return AppLocalizations.of(context)!.unknown_zodiac;
  }
}