import 'package:am_i_dreaming/src/model/moon_model.dart';

import '../julian_day/julian_day.dart';

MoonPhaseModel moonPhase(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  const double knownNewMoonJD = 2451550.1;
  const double lunarCycle = 29.53;

  double currentJD = calculateJulianDay(date);
  double daysSinceNewMoon = currentJD - knownNewMoonJD;
  double phase = daysSinceNewMoon % lunarCycle;

  if (phase < 1.0) return MoonPhaseModel(name: MoonPhaseEnum.newMoon, icon: "🌑");
  if (phase < 7.4) return MoonPhaseModel(name: MoonPhaseEnum.firstQuarter, icon: "🌓");
  if (phase < 14.8) return MoonPhaseModel(name: MoonPhaseEnum.fullMoon, icon: "🌕");
  if (phase < 22.1) return MoonPhaseModel(name: MoonPhaseEnum.lastQuarter, icon: "🌗");
  return MoonPhaseModel(name: MoonPhaseEnum.newMoon, icon: "🌑");
}
