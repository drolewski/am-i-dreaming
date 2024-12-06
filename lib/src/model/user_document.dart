import 'package:am_i_dreaming/src/model/sex_enum.dart';
import 'package:am_i_dreaming/src/model/zodiac_model.dart';

import 'moon_model.dart';

class UserDocument {
  UserDocument(
      {required this.id,
      required this.name,
      required this.sex,
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

  final String id;
  final String name;
  final SexEnum sex;
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

  @override
  bool operator ==(Object other) {
    return other is UserDocument &&
        other.id == id &&
        other.userId == userId &&
        other.birthdayTimestampUTC == other.birthdayTimestampUTC &&
        other.timestamp == other.timestamp &&
        other.name == other.name;
  }

  static empty() {
    return UserDocument(
        id: "",
        name: "name",
        sex: SexEnum.other,
        birthCity: "",
        birthdayTimestampUTC: 0,
        birthCountryCode: "",
        sunZodiac: ZodiacEnum.unknown,
        lunarZodiac: ZodiacEnum.unknown,
        zodiacElement: ZodiacElementEnum.unknown,
        zodiacQuality: ZodiacQualityEnum.unknown,
        moonPhase: MoonPhaseEnum.fullMoon,
        houses: List.empty(),
        sunReturnDate: 0,
        moonReturnDate: 0,
        ascendant: ZodiacEnum.unknown,
        timestamp: 0,
        userId: "");
  }
}
