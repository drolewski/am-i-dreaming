import 'dart:math';

import '../../model/planet_return.dart';
import '../julian_day/julian_day.dart';

double calculateSunPosition(double julianDay) {
  double D = julianDay - 2451545.0;

  double L = (280.460 + 0.9856474 * D) % 360;

  double g = (357.528 + 0.9856003 * D) % 360;

  double lambda = L + 1.915 * sin(g * pi / 180) + 0.020 * sin(2 * g * pi / 180);

  return lambda % 360;
}

double calculateMoonLongitude(double julianDay) {
  double T = (julianDay - 2451545.0) / 36525.0;

  double L0 = (218.31617 + 481267.88134 * T + 0.000001003 * pow(T, 2)) % 360;
  double M = (134.96341 + 477198.86756 * T + 0.000000005 * pow(T, 2)) % 360;
  double M_prime =
      (93.27209 + 483202.01753 * T + 0.000000003 * pow(T, 2)) % 360;
  double F = (0.0000003 * T) % 360;

  double C = 1.914602 * sin(M * pi / 180) + 0.019993 * sin(2 * M * pi / 180);
  double trueLongitude = (L0 + C + M_prime + F) % 360;

  return trueLongitude;
}

PlanetReturnModel calculatePlanetReturn(int timestamp) {
  final birthDateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  double birthJulianDay = calculateJulianDay(birthDateTime);
  double sunBirthPosition = calculateSunPosition(birthJulianDay);
  double moonBirthPosition = calculateMoonLongitude(birthJulianDay);

  DateTime today = DateTime.now();
  double candidateJulianDay = calculateJulianDay(today);

  bool hasSunPosition = false;
  bool hasMoonPosition = false;
  DateTime sunDay = DateTime.now();
  DateTime moonDay = DateTime.now();
  while (!hasSunPosition || !hasMoonPosition) {
    double currentSunPosition = calculateSunPosition(candidateJulianDay);
    double currentMoonPosition = calculateMoonLongitude(candidateJulianDay);

    if (!hasSunPosition &&
        (currentSunPosition - sunBirthPosition).abs() < 0.01) {
      hasSunPosition = true;
      sunDay = today;
    }

    if (!hasMoonPosition &&
        (currentMoonPosition - moonBirthPosition).abs() < 0.001) {
      hasMoonPosition = true;
      moonDay = today;
    }

    today = today.add(const Duration(minutes: 1));
    candidateJulianDay = calculateJulianDay(today);
  }

  return PlanetReturnModel(moonReturnDate: moonDay, sunReturnDate: sunDay);
}
