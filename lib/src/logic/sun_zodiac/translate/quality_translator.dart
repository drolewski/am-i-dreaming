import 'package:am_i_dreaming/src/model/zodiac_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String translateQuality(BuildContext context, ZodiacQualityEnum quality) {
  switch (quality) {
    case ZodiacQualityEnum.fixed:
      return AppLocalizations.of(context)!.fixed;
    case ZodiacQualityEnum.mutable:
      return AppLocalizations.of(context)!.mutable;
    case ZodiacQualityEnum.cardinal:
      return AppLocalizations.of(context)!.cardinal;
    default:
      return AppLocalizations.of(context)!.unknown_quality;
  }
}
