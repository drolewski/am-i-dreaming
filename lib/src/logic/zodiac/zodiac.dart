import 'package:am_i_dreaming/src/model/zodiac_model.dart';

ZodiacModel zodiac(int timestamp) {
  final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final month = dateTime.month;
  final day = dateTime.day;

  if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
    return ZodiacModel(name: ZodiacEnum.Aries, icon: "♈️");
  } else if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
    return ZodiacModel(name: ZodiacEnum.Taurus, icon: "♉️️");
  } else if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
    return ZodiacModel(name: ZodiacEnum.Gemini, icon: "♊️️️");
  } else if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
    return ZodiacModel(name: ZodiacEnum.Cancer, icon: "♋️");
  } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
    return ZodiacModel(name: ZodiacEnum.Leo, icon: "♌️");
  } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
    return ZodiacModel(name: ZodiacEnum.Virgo, icon: "♍️");
  } else if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
    return ZodiacModel(name: ZodiacEnum.Libra, icon: "♎️️");
  } else if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
    return ZodiacModel(name: ZodiacEnum.Scorpio, icon: "︎♏️️️");
  } else if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
    return ZodiacModel(name: ZodiacEnum.Sagittarius, icon: "♐️️️");
  } else if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
    return ZodiacModel(name: ZodiacEnum.Capricorn, icon: "♑️️️️");
  } else if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
    return ZodiacModel(name: ZodiacEnum.Aquarius, icon: "♒️️️️️");
  } else if ((month == 2 && day >= 19) || (month == 3 && day <= 20)) {
    return ZodiacModel(name: ZodiacEnum.Pisces, icon: "♓️️️️️️");
  }
  return ZodiacModel(name: ZodiacEnum.Unknown, icon: "X️");
}

ElementEnum element(ZodiacEnum zodiac) {
  Map<ZodiacEnum, ElementEnum> elements = {
    ZodiacEnum.Aries: ElementEnum.Fire,
    ZodiacEnum.Leo: ElementEnum.Fire,
    ZodiacEnum.Sagittarius: ElementEnum.Fire,
    ZodiacEnum.Taurus: ElementEnum.Earth,
    ZodiacEnum.Virgo: ElementEnum.Earth,
    ZodiacEnum.Capricorn: ElementEnum.Earth,
    ZodiacEnum.Gemini: ElementEnum.Air,
    ZodiacEnum.Libra: ElementEnum.Air,
    ZodiacEnum.Aquarius: ElementEnum.Air,
    ZodiacEnum.Cancer: ElementEnum.Water,
    ZodiacEnum.Scorpio: ElementEnum.Water,
    ZodiacEnum.Pisces: ElementEnum.Water
  };

  return elements[zodiac] ?? ElementEnum.Unknown;
}

ZodiacQualityEnum quality(ZodiacEnum zodiac) {
  Map<ZodiacEnum, ZodiacQualityEnum> elements = {
    ZodiacEnum.Aries: ZodiacQualityEnum.Cardinal,
    ZodiacEnum.Leo: ZodiacQualityEnum.Fixed,
    ZodiacEnum.Sagittarius: ZodiacQualityEnum.Mutable,
    ZodiacEnum.Taurus: ZodiacQualityEnum.Fixed,
    ZodiacEnum.Virgo: ZodiacQualityEnum.Mutable,
    ZodiacEnum.Capricorn: ZodiacQualityEnum.Cardinal,
    ZodiacEnum.Gemini: ZodiacQualityEnum.Mutable,
    ZodiacEnum.Libra: ZodiacQualityEnum.Cardinal,
    ZodiacEnum.Aquarius: ZodiacQualityEnum.Fixed,
    ZodiacEnum.Cancer: ZodiacQualityEnum.Cardinal,
    ZodiacEnum.Scorpio: ZodiacQualityEnum.Fixed,
    ZodiacEnum.Pisces: ZodiacQualityEnum.Mutable
  };

  return elements[zodiac] ?? ZodiacQualityEnum.Unknown;
}
