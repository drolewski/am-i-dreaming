import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum SexEnum {
  female,
  male,
  nonBinary,
  preferNotToAnswer,
  other;

  static SexEnum fromString(String str) =>
      SexEnum.values.firstWhere((element) => element.name == str);

  static String translate(BuildContext context, SexEnum sex) {
    switch (sex) {
      case SexEnum.male:
        return AppLocalizations.of(context)!.male;
      case SexEnum.female:
        return AppLocalizations.of(context)!.female;
      case SexEnum.nonBinary:
        return AppLocalizations.of(context)!.nonBinary;
      case SexEnum.preferNotToAnswer:
        return AppLocalizations.of(context)!.preferNotToAnswer;
      case SexEnum.other:
        return AppLocalizations.of(context)!.other;
    }
  }
}
