import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../app_state.dart';
import 'dream_input.dart';
import 'dreams_list.dart';

class DreamView extends StatelessWidget {
  const DreamView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 60.0),
        ),
        Expanded(
            flex: 3,
            child: Consumer<ApplicationState>(
              builder: (context, appState, _) => Center(
                  child: DreamsList(dreamDocuments: appState.dreamDocuments)),
            )),
        Container(
            padding: const EdgeInsets.only(bottom: 80),
            // margin: EdgeInsets.all(100),
            child: Consumer<ApplicationState>(
                builder: (context, appState, _) => Center(
                      child: DreamInput(
                          addDream: (dream) => appState.addNewDream(dream)),
                    )))
      ],
    );
  }
}
