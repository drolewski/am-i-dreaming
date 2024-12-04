import 'package:am_i_dreaming/src/model/moon_model.dart';
import 'package:am_i_dreaming/src/model/zodiac_model.dart';
import 'package:flutter/cupertino.dart';

import '../../logic/astrological_house/translate/astrological_house_translate.dart';
import '../../logic/moon_phase/translate/moon_phase_translator.dart';
import '../../logic/zodiac/translate/zodiac_translator.dart';

String toZodiacRecord(BuildContext context, ZodiacEnum zodiac) {
  var zodiacModel = zodiac.toModel();
  return "${translateZodiac(context, zodiacModel.name)} ${zodiacModel.icon}";
}

String toMoonPhaseRecord(BuildContext context, MoonPhaseEnum moonPhase) {
  var moonPhaseModel = moonPhase.toModel();
  return "${translateMoonPhase(context, moonPhaseModel.name)} ${moonPhaseModel.icon}";
}

List<String> toHousesRecords(
    BuildContext context, List<ZodiacEnum> zodiacEnums) {
  var housesModels = zodiacEnums.map((z) => z.toModel()).toList();
  return translateAstrologicalHouses(context, housesModels);
}
