import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';

Future<void> callingFunction(
  BuildContext context,
) async {
  HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
    'helloWorld',
    options: HttpsCallableOptions(
      timeout: const Duration(seconds: 5),
    ),
  );
  print(callable.toString());
  try {
    final result = await callable();
    print(result);
  } catch (e) {
    print('ERROR: $e');
  }
}
