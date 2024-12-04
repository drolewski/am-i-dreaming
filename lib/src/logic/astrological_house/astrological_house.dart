import 'dart:math';

import 'package:am_i_dreaming/src/logic/sun_zodiac/translate/zodiac_translator.dart';
import 'package:flutter/cupertino.dart';

import '../../model/zodiac_model.dart';

double _calculateJulianDay(int timestamp) {
  final birthDateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  int year = birthDateTime.year;
  int month = birthDateTime.month;
  int day = birthDateTime.day;

  if (month <= 2) {
    year -= 1;
    month += 12;
  }

  int A = (year / 100).floor();
  int B = 2 - A + (A / 4).floor();

  return (365.25 * (year + 4716)).floor() +
      (30.6001 * (month + 1)).floor() +
      day +
      B -
      1524.5 +
      (birthDateTime.hour / 24) +
      (birthDateTime.minute / 1440);
}

double _calculateAscendant(int timestamp) {
  double JD = _calculateJulianDay(timestamp);
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


List<String> astroHouses(BuildContext context, int timestamp) {
  final assignedHouses = _assignSignsToHouses(timestamp);
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

List<ZodiacModel> _assignSignsToHouses(
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
