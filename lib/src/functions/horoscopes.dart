import 'package:am_i_dreaming/src/model/zodiac_model.dart';
import 'package:cloud_functions/cloud_functions.dart';

Future<void> horoscopes(String language, ZodiacEnum zodiac) async {
  await FirebaseFunctions.instanceFor(region: "europe-west1")
      .httpsCallable('horoscopes')
      .call({"language": language, "zodiac": zodiac.name, "timestamp": DateTime.now().millisecondsSinceEpoch});
}
