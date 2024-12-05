class JulianDayCalculator {
  JulianDayCalculator();

  double calculateJulianDay(int parameterizedTimestamp) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(parameterizedTimestamp);
    int year = dateTime.year;
    int month = dateTime.month;
    int day = dateTime.day;

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
        (dateTime.hour / 24) +
        (dateTime.minute / 1440) +
        (dateTime.second / 86400);
  }
}
