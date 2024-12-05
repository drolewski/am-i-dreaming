import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String formatTimestampToDate(BuildContext context, int timestamp) {
  return AppLocalizations.of(context)!.formattedDate(
      DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true).toLocal());
}

String formatTimestampToTime(BuildContext context, int timestamp) {
  return AppLocalizations.of(context)!.formattedTime(
      DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true).toLocal());
}

String formatTimestampToDateTime(BuildContext context, int timestamp) {
  var date =
      DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true).toLocal();
  return AppLocalizations.of(context)!.formattedDateTime(date, date);
}
