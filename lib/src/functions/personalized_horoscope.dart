import 'package:cloud_functions/cloud_functions.dart';

class PersonalizedHoroscopeResponse {
  PersonalizedHoroscopeResponse({required this.language, required this.date, required this.horoscope});

  final String language;
  final String date;
  final String horoscope;

  static fromJson(Map<dynamic, dynamic> json) => PersonalizedHoroscopeResponse(
      language: json['language'] as String,
      date: json['date'] as String,
      horoscope: json['horoscope'] as String
  );
}

Future<PersonalizedHoroscopeResponse> personalizedHoroscope(String language, String userId, int birthdateTimestamp, String birthplace) async {
  final horoscopeResponseJson =
  await FirebaseFunctions.instanceFor(region: "europe-west1")
      .httpsCallable('personalizedHoroscope')
      .call({
    "language": language,
    "userId": userId,
    "birthdate": birthdateTimestamp,
    "birthplace": birthplace,
    "timestamp": DateTime.now().millisecondsSinceEpoch
  });
  return PersonalizedHoroscopeResponse.fromJson(horoscopeResponseJson.data);
}
