import 'package:am_i_dreaming/src/model/zodiac_model.dart';

ZodiacModel zodiac(int timestamp) {
  final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final month = dateTime.month;
  final day = dateTime.day;

  if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
    return ZodiacModel(name: ZodiacEnum.aries, icon: "♈️");
  } else if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
    return ZodiacModel(name: ZodiacEnum.taurus, icon: "♉️️");
  } else if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
    return ZodiacModel(name: ZodiacEnum.gemini, icon: "♊️️️");
  } else if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
    return ZodiacModel(name: ZodiacEnum.cancer, icon: "♋️");
  } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
    return ZodiacModel(name: ZodiacEnum.leo, icon: "♌️");
  } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
    return ZodiacModel(name: ZodiacEnum.virgo, icon: "♍️");
  } else if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
    return ZodiacModel(name: ZodiacEnum.libra, icon: "♎️️");
  } else if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
    return ZodiacModel(name: ZodiacEnum.scorpio, icon: "︎♏️️️");
  } else if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
    return ZodiacModel(name: ZodiacEnum.sagittarius, icon: "♐️️️");
  } else if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
    return ZodiacModel(name: ZodiacEnum.capricorn, icon: "♑️️️️");
  } else if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
    return ZodiacModel(name: ZodiacEnum.aquarius, icon: "♒️️️️️");
  } else if ((month == 2 && day >= 19) || (month == 3 && day <= 20)) {
    return ZodiacModel(name: ZodiacEnum.pisces, icon: "♓️️️️️️");
  }
  return ZodiacModel(name: ZodiacEnum.unknown, icon: "X️");
}

ElementEnum element(ZodiacEnum zodiac) {
  Map<ZodiacEnum, ElementEnum> elements = {
    ZodiacEnum.aries: ElementEnum.fire,
    ZodiacEnum.leo: ElementEnum.fire,
    ZodiacEnum.sagittarius: ElementEnum.fire,
    ZodiacEnum.taurus: ElementEnum.earth,
    ZodiacEnum.virgo: ElementEnum.earth,
    ZodiacEnum.capricorn: ElementEnum.earth,
    ZodiacEnum.gemini: ElementEnum.air,
    ZodiacEnum.libra: ElementEnum.air,
    ZodiacEnum.aquarius: ElementEnum.air,
    ZodiacEnum.cancer: ElementEnum.water,
    ZodiacEnum.scorpio: ElementEnum.water,
    ZodiacEnum.pisces: ElementEnum.water
  };

  return elements[zodiac] ?? ElementEnum.unknown;
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
