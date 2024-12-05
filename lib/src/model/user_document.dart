import 'package:am_i_dreaming/src/model/zodiac_model.dart';

import 'moon_model.dart';

class UserDocument {
  UserDocument(
      {required this.name,
      required this.birthCity,
      required this.birthdayTimestampUTC,
      required this.birthCountryCode,
      required this.sunZodiac,
      required this.lunarZodiac,
      required this.zodiacElement,
      required this.zodiacQuality,
      required this.moonPhase,
      required this.houses,
      required this.sunReturnDate,
      required this.moonReturnDate,
      required this.ascendant,
      required this.timestamp,
      required this.userId});

  final String name;
  final String birthCity;
  final int birthdayTimestampUTC;
  final String birthCountryCode;
  final ZodiacEnum sunZodiac;
  final ZodiacEnum lunarZodiac;
  final ZodiacElementEnum zodiacElement;
  final ZodiacQualityEnum zodiacQuality;
  final MoonPhaseEnum moonPhase;
  final List<ZodiacEnum> houses;
  final int sunReturnDate;
  final int moonReturnDate;
  final ZodiacEnum ascendant;
  final int timestamp;
  final String userId;
}
