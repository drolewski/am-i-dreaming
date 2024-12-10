import 'package:flutter/cupertino.dart';
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
                  child: DreamsList(dreamDocuments: appState.dreamDocuments, isDreamSet: appState.dreamDocumentSet,)),
            )),
        Consumer<ApplicationState>(
            builder: (context, appState, _) => Center(
                  child: DreamInput(
                      addDream: (dream, prompt) => appState.addNewDream(dream, prompt)),
                ))
      ],
    )));
  }
}
