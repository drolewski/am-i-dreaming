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
}

enum ElementEnum {
  fire,
  earth,
  air,
  water,
  unknown;
}

enum ZodiacQualityEnum {
  cardinal,
  fixed,
  mutable,
  unknown;
}
