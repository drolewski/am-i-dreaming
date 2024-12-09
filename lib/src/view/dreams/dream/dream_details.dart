import 'package:am_i_dreaming/src/component/premium_button.dart';
import 'package:am_i_dreaming/src/state/app_state.dart';
import 'package:am_i_dreaming/src/util/date_formater.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class DreamDetails extends StatefulWidget {
  const DreamDetails({super.key, required this.dreamIndex});

  final int dreamIndex;

  @override
  State<DreamDetails> createState() => _DreamDetailsState();
}

class _DreamDetailsState extends State<DreamDetails> {

  List fruit = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(formatTimestampToDate(
                context, appState.dreamDocuments[widget.dreamIndex].timestamp)),
          ),
          child: SafeArea(
              child: Padding(
                  padding:
                      const EdgeInsets.only(top: 20, left: 20.0, right: 20.0),
                  child: Column(children: [
                    SizedBox(
                        width: double.infinity,
                        child: CupertinoButton(
                            child: Text(AppLocalizations.of(context)!
                                .generate_dream_picture_button),
                            onPressed: () async {
                              print("generuj");
                            })),
                    const PremiumButton(),
                    Text(appState.dreamDocuments[widget.dreamIndex].text),
                  ]))));
    });
  }
}
