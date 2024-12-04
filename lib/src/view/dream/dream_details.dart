import 'package:am_i_dreaming/app_state.dart';
import 'package:am_i_dreaming/src/util/date_formater.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class DreamDetails extends StatelessWidget {
  const DreamDetails({super.key, required this.dreamIndex});

  final int dreamIndex;

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(formatTimestamp(
                context, appState.dreamDocuments[dreamIndex].timestamp)),
          ),
          child: Padding(
              padding: const EdgeInsets.only(top: 120, left: 20.0, right: 20.0),
              child: Column(children: [
                SizedBox(
                    width: double.infinity,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: CupertinoButton(
                            child: Text(AppLocalizations.of(context)!
                                .generate_dream_picture_button),
                            onPressed: () => print("generuj")))),
                SizedBox(
                    width: double.infinity,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: CupertinoButton.filled(
                            child: Text(AppLocalizations.of(context)!
                                .buy_premium_button),
                            onPressed: () => print("premium")))),
                Text(appState.dreamDocuments[dreamIndex].text),
              ])));
    });
  }
}
