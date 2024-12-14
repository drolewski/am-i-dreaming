import 'package:cloud_functions/cloud_functions.dart';

Future<void> dream(String dreamId) async {
  await FirebaseFunctions.instanceFor(region: "europe-west1")
      .httpsCallable('dream')
      .call({"dreamId": dreamId});
}
