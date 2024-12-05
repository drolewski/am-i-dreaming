import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String formatTimestampToDate(BuildContext context, int timestamp) {
  return AppLocalizations.of(context)!
      .formattedDate(DateTime.fromMillisecondsSinceEpoch(timestamp));
}

String formatTimestampToTime(BuildContext context, int timestamp) {
  return AppLocalizations.of(context)!
      .formattedTime(DateTime.fromMillisecondsSinceEpoch(timestamp));
}
