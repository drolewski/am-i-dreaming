import 'package:flutter/cupertino.dart';

import '../../../model/zodiac_model.dart';
import '../../sun_zodiac/translate/zodiac_translator.dart';

List<String> translateAstrologicalHouses(
    BuildContext context, List<ZodiacModel> assignedHouses) {
  final result = [
    "I. ${translateZodiac(context, assignedHouses[0].name)} ${assignedHouses[0].icon}",
    "II. ${translateZodiac(context, assignedHouses[1].name)} ${assignedHouses[1].icon}",
    "III. ${translateZodiac(context, assignedHouses[2].name)} ${assignedHouses[2].icon}",
    "IV. ${translateZodiac(context, assignedHouses[3].name)} ${assignedHouses[3].icon}",
    "V. ${translateZodiac(context, assignedHouses[4].name)} ${assignedHouses[4].icon}",
    "VI. ${translateZodiac(context, assignedHouses[5].name)} ${assignedHouses[5].icon}",
    "VII. ${translateZodiac(context, assignedHouses[6].name)} ${assignedHouses[6].icon}",
    "VIII. ${translateZodiac(context, assignedHouses[7].name)} ${assignedHouses[7].icon}",
    "IX. ${translateZodiac(context, assignedHouses[8].name)} ${assignedHouses[8].icon}",
    "X. ${translateZodiac(context, assignedHouses[9].name)} ${assignedHouses[9].icon}",
    "XI. ${translateZodiac(context, assignedHouses[10].name)} ${assignedHouses[10].icon}",
    "XII. ${translateZodiac(context, assignedHouses[11].name)} ${assignedHouses[11].icon}",
  ];
  return result;
}
