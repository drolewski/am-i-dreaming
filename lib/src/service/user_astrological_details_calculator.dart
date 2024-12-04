import 'package:am_i_dreaming/src/logic/astrological_house/astrological_house_calculator.dart';
import 'package:am_i_dreaming/src/logic/moon_phase/moon_phase_calculator.dart';
import 'package:am_i_dreaming/src/logic/zodiac/zodiac_calculator.dart';
import 'package:am_i_dreaming/src/model/user_astrological_details.dart';

import '../logic/julian_day/julian_day.dart';
import '../logic/planet_return/planet_return_calculator.dart';

class UserAstrologicalDetailsCalculator {
  UserAstrologicalDetailsCalculator({required this.birthdayTimestamp}) {
    julianDayCalculator =
        JulianDayCalculator(birthDayTimestamp: birthdayTimestamp);
    julianDay = julianDayCalculator.calculateJulianDay();
    zodiacCalculator = ZodiacCalculator(
        birthdayTimestamp: birthdayTimestamp, julianDay: julianDay);
    moonPhaseCalculator = MoonPhaseCalculator(julianDay: julianDay);
    astrologicalHouseCalculator =
        AstrologicalHouseCalculator(julianDay: julianDay);
    planetReturnCalculator =
        PlanetReturnCalculator(julianDayCalculator: julianDayCalculator);
  }

  final int birthdayTimestamp;
  late final double julianDay;
  late final ZodiacCalculator zodiacCalculator;
  late final MoonPhaseCalculator moonPhaseCalculator;
  late final AstrologicalHouseCalculator astrologicalHouseCalculator;
  late final JulianDayCalculator julianDayCalculator;
  late final PlanetReturnCalculator planetReturnCalculator;

  UserAstrologicalDetails userAstrologicalDetails() {
    final sunZodiacValue = zodiacCalculator.sunZodiac();
    final zodiacElement = zodiacCalculator.element(sunZodiacValue);
    final zodiacQuality = zodiacCalculator.quality(sunZodiacValue);
    final lunarZodiacValue = zodiacCalculator.lunarZodiac();
    final moonPhaseValue = moonPhaseCalculator.moonPhase();
    final astrologicalHouseList =
        astrologicalHouseCalculator.astrologicalHouses();
    final ascendantZodiac = astrologicalHouseCalculator.ascendant();
    final planetReturn = planetReturnCalculator.calculatePlanetReturn();
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
