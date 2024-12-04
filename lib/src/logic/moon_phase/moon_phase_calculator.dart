import 'package:am_i_dreaming/src/model/moon_model.dart';

class MoonPhaseCalculator {
  MoonPhaseCalculator({required this.julianDay});

  final double julianDay;

  MoonPhaseEnum moonPhase() {
    const double knownNewMoonJD = 2451550.1;
    const double lunarCycle = 29.53;

    double daysSinceNewMoon = julianDay - knownNewMoonJD;
    double phase = daysSinceNewMoon % lunarCycle;

    if (phase < 1.0) {
      return MoonPhaseEnum.newMoon;
    }
    if (phase < 7.4) {
      return MoonPhaseEnum.firstQuarter;
    }
    if (phase < 14.8) {
      return MoonPhaseEnum.fullMoon;
    }
    if (phase < 22.1) {
      return MoonPhaseEnum.lastQuarter;
    }
    return MoonPhaseEnum.newMoon;
  }
}
