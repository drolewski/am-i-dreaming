import 'dart:math';

import 'package:am_i_dreaming/src/model/zodiac_model.dart';

import '../julian_day/julian_day.dart';

ZodiacModel lunarZodiac(int timestamp) {
  double lunarPosition = _calculateLunarLongitude(timestamp);

  if (lunarPosition >= 0 && lunarPosition < 30) {
    return ZodiacModel(name: ZodiacEnum.aries, icon: "♈️");
  }
  if (lunarPosition >= 30 && lunarPosition < 60) {
    return ZodiacModel(name: ZodiacEnum.taurus, icon: "♉️️");
  }
  if (lunarPosition >= 60 && lunarPosition < 90) {
    return ZodiacModel(name: ZodiacEnum.gemini, icon: "♊️️️");
  }
  if (lunarPosition >= 90 && lunarPosition < 120) {
    return ZodiacModel(name: ZodiacEnum.cancer, icon: "♋️");
  }
  if (lunarPosition >= 120 && lunarPosition < 150) {
    return ZodiacModel(name: ZodiacEnum.leo, icon: "♌️");
  }
  if (lunarPosition >= 150 && lunarPosition < 180) {
    return ZodiacModel(name: ZodiacEnum.virgo, icon: "♍️");
  }
  if (lunarPosition >= 180 && lunarPosition < 210) {
    return ZodiacModel(name: ZodiacEnum.libra, icon: "♎️️");
  }
  if (lunarPosition >= 210 && lunarPosition < 240) {
    return ZodiacModel(name: ZodiacEnum.scorpio, icon: "︎♏️️️");
  }
  if (lunarPosition >= 240 && lunarPosition < 270) {
    return ZodiacModel(name: ZodiacEnum.sagittarius, icon: "♐️️️");
  }
  if (lunarPosition >= 270 && lunarPosition < 300) {
    return ZodiacModel(name: ZodiacEnum.capricorn, icon: "♑️️️️");
  }
  if (lunarPosition >= 300 && lunarPosition < 330) {
    return ZodiacModel(name: ZodiacEnum.aquarius, icon: "♒️️️️️");
  }
  if (lunarPosition >= 330 && lunarPosition < 360) {
    return ZodiacModel(name: ZodiacEnum.pisces, icon: "♓️️️️️️");
  }

  return ZodiacModel(name: ZodiacEnum.unknown, icon: "X️");
}

double _calculateLunarLongitude(int timestamps) {
  double JD = calculateJulianDay(DateTime.fromMillisecondsSinceEpoch(timestamps));
  double D = JD - 2451545.0;

  double meanLongitude = (218.316 + 13.176396 * D) % 360;

  double meanAnomaly = (134.963 + 13.064993 * D) % 360;

  double elongation = (297.850 + 12.190749 * D) % 360;

  double longitude = meanLongitude +
      6.289 * sin(meanAnomaly * pi / 180) -
      1.274 * sin((2 * elongation - meanAnomaly) * pi / 180) +
      0.658 * sin(2 * elongation * pi / 180) +
      0.214 * sin(2 * meanAnomaly * pi / 180) -
      0.186 * sin(meanLongitude * pi / 180);

  return longitude % 360;
}
