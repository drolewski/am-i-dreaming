import 'dart:math';

class AstroHouse {
  final int timestamp;
  final double latitude;
  final double longitude;

  AstroHouse(this.timestamp, this.latitude, this.longitude);

  double calculateSiderealTime() {
    final birthDateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    int year = birthDateTime.year;
    int month = birthDateTime.month;
    int day = birthDateTime.day;

    if (month < 3) {
      year -= 1;
      month += 12;
    }

    // JD
    int A = (year / 100).floor();
    int B = 2 - A + (A / 4).floor();
    double JD = (365.25 * (year + 4716)).floor() +
        (30.6001 * (month + 1)).floor() +
        day +
        B -
        1524.5;

    // Star time Greenwich
    double T = (JD - 2451545.0) / 36525.0;
    double GMST = 280.46061837 +
        360.98564736629 * (JD - 2451545.0) +
        0.000387933 * pow(T, 2) -
        pow(T, 3) / 38710000.0;

    // 360 degree normalization
    return GMST % 360;
  }

  double calculateAscendant() {
    double siderealTime = calculateSiderealTime();
    double ascendant = siderealTime + longitude;

    return ascendant % 360;
  }

  Map<int, double> calculateHouses() {
    double ascendant = calculateAscendant();
    Map<int, double> houses = {};

    // 30 degree houses
    for (int i = 1; i <= 12; i++) {
      houses[i] = (ascendant + (i - 1) * 30) % 360;
    }

    return houses;
  }
}