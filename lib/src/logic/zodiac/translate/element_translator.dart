import 'package:flutter/cupertino.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../model/zodiac_model.dart';

String translateElement(BuildContext context, ElementEnum element) {
  switch (element) {
    case ElementEnum.air:
      return AppLocalizations.of(context)!.air;
    case ElementEnum.water:
      return AppLocalizations.of(context)!.water;
    case ElementEnum.earth:
      return AppLocalizations.of(context)!.earth;
    case ElementEnum.fire:
      return AppLocalizations.of(context)!.fire;
    default:
      return AppLocalizations.of(context)!.unknown_element;
  }
}
