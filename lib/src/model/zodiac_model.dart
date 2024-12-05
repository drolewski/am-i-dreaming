class ZodiacModel {
  ZodiacModel({required this.name, required this.icon});

  final ZodiacEnum name;
  final String icon;
}

enum ZodiacEnum {
  aries,
  taurus,
  gemini,
  cancer,
  leo,
  virgo,
  libra,
  scorpio,
  sagittarius,
  capricorn,
  aquarius,
  pisces,
  unknown;

  static ZodiacEnum fromString(String str) =>
      ZodiacEnum.values.firstWhere((value) => value.name == str);

  ZodiacModel toModel() {
    Map<ZodiacEnum, String> icons = {
      ZodiacEnum.aries: "♈️",
      ZodiacEnum.leo: "♌️",
      ZodiacEnum.sagittarius: "♐️️️",
      ZodiacEnum.taurus: "♉️️",
      ZodiacEnum.virgo: "♍️",
      ZodiacEnum.capricorn: "♑️️️️",
      ZodiacEnum.gemini: "♊️️️",
      ZodiacEnum.libra: "♎️️",
      ZodiacEnum.aquarius: "♒️️️️️",
      ZodiacEnum.cancer: "♋️",
      ZodiacEnum.scorpio: "︎♏️️️",
      ZodiacEnum.pisces: "♓️️️️️️"
    };

    return ZodiacModel(name: this, icon: icons[this] ?? "X");
  }
}

enum ZodiacElementEnum {
  fire,
  earth,
  air,
  water,
  unknown;

  static ZodiacElementEnum fromString(String str) =>
      ZodiacElementEnum.values.firstWhere((value) => value.name == str);
}

enum ZodiacQualityEnum {
  cardinal,
  fixed,
  mutable,
  unknown;

  static ZodiacQualityEnum fromString(String str) =>
      ZodiacQualityEnum.values.firstWhere((value) => value.name == str);
}
