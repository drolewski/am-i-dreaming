import 'package:am_i_dreaming/src/model/moon_model.dart';

MoonPhaseModel moonPhase(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  // Known new moon: 6 stycznia 2000 (JD = 2451550.1)
  const double knownNewMoonJD = 2451550.1;
  const double lunarCycle = 29.53; // mean cykle time

  double julianDate(DateTime date) {
    int year = date.year;
    int month = date.month;
    if (month <= 2) {
      year -= 1;
      month += 12;
    }
    int day = date.day;
    double A = (year / 100).floorToDouble();
    double B = 2 - A + (A / 4).floorToDouble();
    return (365.25 * (year + 4716)).floorToDouble() +
        (30.6001 * (month + 1)).floorToDouble() +
        day +
        B -
        1524.5;
  }

  double currentJD = julianDate(date);
  double daysSinceNewMoon = currentJD - knownNewMoonJD;
  double phase = daysSinceNewMoon % lunarCycle;

  if (phase < 1.0) return MoonPhaseModel(name: MoonPhaseEnum.newMoon, icon: "🌑");
  if (phase < 7.4) return MoonPhaseModel(name: MoonPhaseEnum.firstQuarter, icon: "🌓");
  if (phase < 14.8) return MoonPhaseModel(name: MoonPhaseEnum.fullMoon, icon: "🌕");
  if (phase < 22.1) return MoonPhaseModel(name: MoonPhaseEnum.lastQuarter, icon: "🌗");
  return MoonPhaseModel(name: MoonPhaseEnum.newMoon, icon: "🌑");
}
