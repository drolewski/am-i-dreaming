import 'package:flutter/cupertino.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../model/zodiac_model.dart';

String translateElement(BuildContext context, ZodiacElementEnum element) {
  switch (element) {
    case ZodiacElementEnum.air:
      return AppLocalizations.of(context)!.air;
    case ZodiacElementEnum.water:
      return AppLocalizations.of(context)!.water;
    case ZodiacElementEnum.earth:
      return AppLocalizations.of(context)!.earth;
    case ZodiacElementEnum.fire:
      return AppLocalizations.of(context)!.fire;
    default:
      return AppLocalizations.of(context)!.unknown_element;
  }
}
