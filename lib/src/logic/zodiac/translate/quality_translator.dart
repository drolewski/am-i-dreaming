import 'package:am_i_dreaming/src/model/zodiac_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String translateQuality(BuildContext context, ZodiacQualityEnum quality) {
  switch (quality) {
    case ZodiacQualityEnum.Fixed:
      return AppLocalizations.of(context)!.fixed;
    case ZodiacQualityEnum.Mutable:
      return AppLocalizations.of(context)!.mutable;
    case ZodiacQualityEnum.Cardinal:
      return AppLocalizations.of(context)!.cardinal;
    default:
      return AppLocalizations.of(context)!.unknown_quality;
  }
}
