import 'dart:math';

import 'package:am_i_dreaming/src/model/zodiac_model.dart';

class ZodiacCalculator {
  ZodiacEnum sunZodiac(int birthdayTimestampUTC) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(birthdayTimestampUTC);
    final month = dateTime.month;
    final day = dateTime.day;

    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
      return ZodiacEnum.aries;
    } else if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
      return ZodiacEnum.taurus;
    } else if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
      return ZodiacEnum.gemini;
    } else if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
      return ZodiacEnum.cancer;
    } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
      return ZodiacEnum.leo;
    } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
      return ZodiacEnum.virgo;
    } else if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
      return ZodiacEnum.libra;
    } else if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      return ZodiacEnum.scorpio;
    } else if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      return ZodiacEnum.sagittarius;
    } else if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      return ZodiacEnum.capricorn;
    } else if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      return ZodiacEnum.aquarius;
    } else if ((month == 2 && day >= 19) || (month == 3 && day <= 20)) {
      return ZodiacEnum.pisces;
    }
    return ZodiacEnum.unknown;
  }

  ZodiacElementEnum element(ZodiacEnum zodiac) {
    Map<ZodiacEnum, ZodiacElementEnum> elements = {
      ZodiacEnum.aries: ZodiacElementEnum.fire,
      ZodiacEnum.leo: ZodiacElementEnum.fire,
      ZodiacEnum.sagittarius: ZodiacElementEnum.fire,
      ZodiacEnum.taurus: ZodiacElementEnum.earth,
      ZodiacEnum.virgo: ZodiacElementEnum.earth,
      ZodiacEnum.capricorn: ZodiacElementEnum.earth,
      ZodiacEnum.gemini: ZodiacElementEnum.air,
      ZodiacEnum.libra: ZodiacElementEnum.air,
      ZodiacEnum.aquarius: ZodiacElementEnum.air,
      ZodiacEnum.cancer: ZodiacElementEnum.water,
      ZodiacEnum.scorpio: ZodiacElementEnum.water,
      ZodiacEnum.pisces: ZodiacElementEnum.water
    };

    return elements[zodiac] ?? ZodiacElementEnum.unknown;
  }

  ZodiacQualityEnum quality(ZodiacEnum zodiac) {
    Map<ZodiacEnum, ZodiacQualityEnum> elements = {
      ZodiacEnum.aries: ZodiacQualityEnum.cardinal,
      ZodiacEnum.leo: ZodiacQualityEnum.fixed,
      ZodiacEnum.sagittarius: ZodiacQualityEnum.mutable,
      ZodiacEnum.taurus: ZodiacQualityEnum.fixed,
      ZodiacEnum.virgo: ZodiacQualityEnum.mutable,
      ZodiacEnum.capricorn: ZodiacQualityEnum.cardinal,
      ZodiacEnum.gemini: ZodiacQualityEnum.mutable,
      ZodiacEnum.libra: ZodiacQualityEnum.cardinal,
      ZodiacEnum.aquarius: ZodiacQualityEnum.fixed,
      ZodiacEnum.cancer: ZodiacQualityEnum.cardinal,
      ZodiacEnum.scorpio: ZodiacQualityEnum.fixed,
      ZodiacEnum.pisces: ZodiacQualityEnum.mutable
    };

    return elements[zodiac] ?? ZodiacQualityEnum.unknown;
  }

  ZodiacEnum lunarZodiac(double julianDay) {
    double lunarPosition = _calculateLunarLongitude(julianDay);

    if (lunarPosition >= 0 && lunarPosition < 30) {
      return ZodiacEnum.aries;
    }
    if (lunarPosition >= 30 && lunarPosition < 60) {
      return ZodiacEnum.taurus;
    }
    if (lunarPosition >= 60 && lunarPosition < 90) {
      return ZodiacEnum.gemini;
    }
    if (lunarPosition >= 90 && lunarPosition < 120) {
      return ZodiacEnum.cancer;
    }
    if (lunarPosition >= 120 && lunarPosition < 150) {
      return ZodiacEnum.leo;
    }
    if (lunarPosition >= 150 && lunarPosition < 180) {
      return ZodiacEnum.virgo;
    }
    if (lunarPosition >= 180 && lunarPosition < 210) {
      return ZodiacEnum.libra;
    }
    if (lunarPosition >= 210 && lunarPosition < 240) {
      return ZodiacEnum.scorpio;
    }
    if (lunarPosition >= 240 && lunarPosition < 270) {
      return ZodiacEnum.sagittarius;
    }
    if (lunarPosition >= 270 && lunarPosition < 300) {
      return ZodiacEnum.capricorn;
    }
    if (lunarPosition >= 300 && lunarPosition < 330) {
      return ZodiacEnum.aquarius;
    }
    if (lunarPosition >= 330 && lunarPosition < 360) {
      return ZodiacEnum.pisces;
    }

    return ZodiacEnum.unknown;
  }

  double _calculateLunarLongitude(double julianDay) {
    double D = julianDay - 2451545.0;

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
}
