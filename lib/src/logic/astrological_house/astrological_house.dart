import 'dart:math';

import '../../model/zodiac_model.dart';
import '../julian_day/julian_day.dart';

double _calculateAscendant(int timestamp) {
  double JD = calculateJulianDay(DateTime.fromMillisecondsSinceEpoch(timestamp));
  double D = JD - 2451545.0;

  double L = (280.460 + 0.9856474 * D) % 360;

  double g = (357.528 + 0.9856003 * D) % 360;

  double lambda = L + 1.915 * sin(g * pi / 180) + 0.020 * sin(2 * g * pi / 180);

  double ascendant =
      atan2(sin(lambda * pi / 180), cos(lambda * pi / 180)) * 180 / pi;

  if (ascendant < 0) ascendant += 360;

  return ascendant;
}

List<double> _calculateHouses(int timestamp) {
  double ascendant = _calculateAscendant(timestamp);

  List<double> houses = [];
  for (int i = 0; i < 12; i++) {
    houses.add((ascendant + i * 30) % 360);
  }

  return houses;
}

List<ZodiacModel> astrologicalHouses(
    int timestamp) {
  List<double> houses = _calculateHouses(timestamp);
  List<ZodiacModel> signs = [
    ZodiacModel(name: ZodiacEnum.aries, icon: "♈️"),
    ZodiacModel(name: ZodiacEnum.taurus, icon: "♉️️"),
    ZodiacModel(name: ZodiacEnum.gemini, icon: "♊️️️"),
    ZodiacModel(name: ZodiacEnum.cancer, icon: "♋️"),
    ZodiacModel(name: ZodiacEnum.leo, icon: "♌️"),
    ZodiacModel(name: ZodiacEnum.virgo, icon: "♍️"),
    ZodiacModel(name: ZodiacEnum.libra, icon: "♎️️"),
    ZodiacModel(name: ZodiacEnum.scorpio, icon: "︎♏️️️"),
    ZodiacModel(name: ZodiacEnum.sagittarius, icon: "♐️️️"),
    ZodiacModel(name: ZodiacEnum.capricorn, icon: "♑️️️️"),
    ZodiacModel(name: ZodiacEnum.aquarius, icon: "♒️️️️️"),
    ZodiacModel(name: ZodiacEnum.pisces, icon: "♓️️️️️️")
  ];

  return houses.map((degree) {
    int signIndex = (degree ~/ 30) % 12;
    return signs[signIndex];
  }).toList();
}
