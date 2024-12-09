import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';

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
}

class PlanetReturns {
  PlanetReturns({required this.moonReturnDate, required this.sunReturnDate});

  final String moonReturnDate;
  final String sunReturnDate;
}

Future<AstrologicalData?> astrologicalCalculator(
    BuildContext context, int birthdayTimestamp) async {
  try {
    final result = await FirebaseFunctions.instanceFor(region: "europe-west1")
        .httpsCallable('astrologicalCalculator')
        .call({"birthdayTimestamp": birthdayTimestamp});
    return result.data;
  } catch (e) {
    return null;
  }
}
