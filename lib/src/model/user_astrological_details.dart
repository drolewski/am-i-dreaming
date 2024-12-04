import 'package:am_i_dreaming/src/model/moon_model.dart';
import 'package:am_i_dreaming/src/model/planet_return.dart';
import 'package:am_i_dreaming/src/model/zodiac_model.dart';

class UserAstrologicalDetails {
  UserAstrologicalDetails(
      {required this.sunZodiac,
      required this.lunarZodiac,
      required this.zodiacElement,
      required this.zodiacQuality,
      required this.moonPhase,
      required this.houses,
      required this.planetReturn,
      required this.ascendant});

  final ZodiacEnum sunZodiac;
  final ZodiacEnum lunarZodiac;
  final ZodiacElementEnum zodiacElement;
  final ZodiacQualityEnum zodiacQuality;
  final MoonPhaseEnum moonPhase;
  final List<ZodiacEnum> houses;
  final ZodiacEnum ascendant;
  final PlanetReturnModel planetReturn;
}
