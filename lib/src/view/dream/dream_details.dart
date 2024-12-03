import 'package:am_i_dreaming/app_state.dart';
import 'package:am_i_dreaming/src/util/date_formater.dart';
import 'package:flutter/cupertino.dart';
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0),
              child: Text(appState.dreamDocuments[dreamIndex].text),
            ),
          ));
    });
  }
}
