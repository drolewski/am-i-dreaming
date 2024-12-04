class ZodiacModel {
  ZodiacModel({required this.name, required this.icon});

  final ZodiacEnum name;
  final String icon;
}

enum ZodiacEnum {
  Aries,
  Taurus,
  Gemini,
  Cancer,
  Leo,
  Virgo,
  Libra,
  Scorpio,
  Sagittarius,
  Capricorn,
  Aquarius,
  Pisces,
  Unknown;
}

enum ElementEnum {
  Fire,
  Earth,
  Air,
  Water,
  Unknown;
}

enum ZodiacQualityEnum {
  Cardinal,
  Fixed,
  Mutable,
  Unknown;
}
