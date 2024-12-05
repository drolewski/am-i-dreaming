import 'package:am_i_dreaming/src/logic/astrological_house/astrological_house_calculator.dart';
import 'package:am_i_dreaming/src/logic/moon_phase/moon_phase_calculator.dart';
import 'package:am_i_dreaming/src/logic/zodiac/zodiac_calculator.dart';
import 'package:am_i_dreaming/src/model/user_astrological_details.dart';

import '../logic/julian_day/julian_day.dart';
import '../logic/planet_return/planet_return_calculator.dart';

class UserAstrologicalDetailsCalculator {
  UserAstrologicalDetailsCalculator() {
    julianDayCalculator = JulianDayCalculator();
    zodiacCalculator = ZodiacCalculator();
    moonPhaseCalculator = MoonPhaseCalculator();
    astrologicalHouseCalculator = AstrologicalHouseCalculator();
    planetReturnCalculator =
        PlanetReturnCalculator(julianDayCalculator: julianDayCalculator);
  }

  late final ZodiacCalculator zodiacCalculator;
  late final MoonPhaseCalculator moonPhaseCalculator;
  late final AstrologicalHouseCalculator astrologicalHouseCalculator;
  late final JulianDayCalculator julianDayCalculator;
  late final PlanetReturnCalculator planetReturnCalculator;

  UserAstrologicalDetails userAstrologicalDetails(int birthDateTimestampUTC) {
    final julianDay =
        julianDayCalculator.calculateJulianDay(birthDateTimestampUTC);
    final sunZodiacValue = zodiacCalculator.sunZodiac(birthDateTimestampUTC);
    final zodiacElement = zodiacCalculator.element(sunZodiacValue);
    final zodiacQuality = zodiacCalculator.quality(sunZodiacValue);
    final lunarZodiacValue = zodiacCalculator.lunarZodiac(julianDay);
    final moonPhaseValue = moonPhaseCalculator.moonPhase(julianDay);
    final astrologicalHouseList =
        astrologicalHouseCalculator.astrologicalHouses(julianDay);
    final ascendantZodiac = astrologicalHouseCalculator.ascendant(julianDay);
    final planetReturn =
        planetReturnCalculator.calculatePlanetReturn(birthDateTimestampUTC);
    return UserAstrologicalDetails(
        sunZodiac: sunZodiacValue,
        lunarZodiac: lunarZodiacValue,
        zodiacElement: zodiacElement,
        zodiacQuality: zodiacQuality,
        moonPhase: moonPhaseValue,
        houses: astrologicalHouseList,
        ascendant: ascendantZodiac,
        planetReturn: planetReturn);
  }
}
