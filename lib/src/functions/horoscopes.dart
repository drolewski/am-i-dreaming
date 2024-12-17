import 'package:am_i_dreaming/src/model/zodiac_model.dart';
import 'package:cloud_functions/cloud_functions.dart';

class HoroscopeResponse {
  HoroscopeResponse(
      {required this.zodiac,
      required this.language,
      required this.date,
      required this.value});

  final ZodiacModel zodiac;
  final String language;
  final String date;
  final String value;

  static fromJson(Map<dynamic, dynamic> json) => HoroscopeResponse(
      zodiac: ZodiacEnum.fromString(json['zodiac'] as String).toModel(),
      language: json['language'] as String,
      date: json['date'] as String,
      value: json['value'] as String);
}

Future<HoroscopeResponse> horoscope(String language, ZodiacEnum zodiac) async {
  final horoscopeResponseJson =
      await FirebaseFunctions.instanceFor(region: "europe-west1")
          .httpsCallable('horoscope')
          .call({
    "language": language,
    "zodiac": zodiac.name,
    "timestamp": DateTime.now().millisecondsSinceEpoch
  });
  return HoroscopeResponse.fromJson(horoscopeResponseJson.data);
}
