import 'package:cloud_functions/cloud_functions.dart';

class AstrologicalData {
  AstrologicalData(
      {required this.sunZodiac,
      required this.lunarZodiac,
      required this.zodiacElement,
      required this.zodiacQuality,
      required this.moonPhase,
      required this.ascendantZodiac,
      required this.astrologicalHouses,
      required this.planetReturns});

  final String sunZodiac;
  final String lunarZodiac;
  final String zodiacElement;
  final String zodiacQuality;
  final String moonPhase;
  final String ascendantZodiac;
  final List<String> astrologicalHouses;
  final PlanetReturns planetReturns;

  static fromJson(Map<dynamic, dynamic> json) => AstrologicalData(
      sunZodiac: json['sunZodiac'] as String,
      lunarZodiac: json['lunarZodiac'] as String,
      zodiacElement: json['zodiacElement'] as String,
      zodiacQuality: json['zodiacQuality'] as String,
      moonPhase: json['moonPhase'] as String,
      ascendantZodiac: json['ascendantZodiac'] as String,
      astrologicalHouses: (json['astrologicalHouses'] as List<dynamic>)
          .map((element) => element.toString())
          .toList(),
      planetReturns: PlanetReturns.fromJson(
          json['planetReturns'] as Map<dynamic, dynamic>));
}

class PlanetReturns {
  PlanetReturns({required this.moonReturnDate, required this.sunReturnDate});

  final int moonReturnDate;
  final int sunReturnDate;

  static fromJson(Map<dynamic, dynamic> json) => PlanetReturns(
        moonReturnDate: json['moonReturnDate'] as int,
        sunReturnDate: json['sunReturnDate'] as int,
      );
}

Future<AstrologicalData?> astrologicalCalculator(int birthdayTimestamp) async {
  final result = await FirebaseFunctions.instanceFor(region: "europe-west1")
      .httpsCallable('astrologicalCalculator')
      .call({"birthdayTimestamp": birthdayTimestamp});
  return AstrologicalData.fromJson(result.data);
}
