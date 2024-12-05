import 'dart:math';

import '../../model/zodiac_model.dart';

class AstrologicalHouseCalculator {
  final List<ZodiacEnum> signs = [
    ZodiacEnum.aries,
    ZodiacEnum.taurus,
    ZodiacEnum.gemini,
    ZodiacEnum.cancer,
    ZodiacEnum.leo,
    ZodiacEnum.virgo,
    ZodiacEnum.libra,
    ZodiacEnum.scorpio,
    ZodiacEnum.sagittarius,
    ZodiacEnum.capricorn,
    ZodiacEnum.aquarius,
    ZodiacEnum.pisces,
  ];

  List<ZodiacEnum> astrologicalHouses(double julianDay) {
    List<double> houses = _calculateHouses(julianDay);

    return houses.map((degree) {
      int signIndex = (degree ~/ 30) % 12;
      return signs[signIndex];
    }).toList();
  }

  ZodiacEnum ascendant(double julianDay) {
    double ascendantValue = _calculateAscendant(julianDay);
    int signIndex = (ascendantValue ~/ 30) % 12;
    return signs[signIndex];
  }

  double _calculateAscendant(double julianDay) {
    double D = julianDay - 2451545.0;

    double L = (280.460 + 0.9856474 * D) % 360;

    double g = (357.528 + 0.9856003 * D) % 360;

    double lambda =
        L + 1.915 * sin(g * pi / 180) + 0.020 * sin(2 * g * pi / 180);

    double ascendant =
        atan2(sin(lambda * pi / 180), cos(lambda * pi / 180)) * 180 / pi;

    if (ascendant < 0) ascendant += 360;

    return ascendant;
  }

  List<double> _calculateHouses(double julianDay) {
    double ascendant = _calculateAscendant(julianDay);

    List<double> houses = [];
    for (int i = 0; i < 12; i++) {
      houses.add((ascendant + i * 30) % 360);
    }

    return houses;
  }
}
