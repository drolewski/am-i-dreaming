import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';

Future<void> dream(BuildContext context, String dreamId) async {
  await FirebaseFunctions.instanceFor(region: "europe-west1")
      .httpsCallable('dream')
      .call({"dreamId": dreamId});
}
