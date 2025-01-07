import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import 'dream_input.dart';
import 'dreams_list.dart';

class DreamView extends StatelessWidget {
  const DreamView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: SafeArea(
            child: Column(
      children: [
        Expanded(
            flex: 3,
            child: Consumer<ApplicationState>(
              builder: (context, appState, _) => Center(
                  child: DreamsList(
                dreamDocuments: appState.dreamDocuments,
                isDreamSet: appState.dreamDocumentSet,
              )),
            )),
        Consumer<ApplicationState>(
            builder: (context, appState, _) => Center(
                  child: (appState.userStatus?.numberOfDreams ?? 0) < 1
                      ? DreamInput(
                          addDream: (dream, prompt) =>
                              appState.addNewDream(dream, prompt))
                      : Container(
                          padding: const EdgeInsets.only(top: 24, bottom: 24),
                          child: Text(
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              AppLocalizations.of(context)!
                                  .already_saved_dream),
                        ),
                ))
      ],
    )));
  }
}
