import 'package:am_i_dreaming/src/view/users/user_details_view.dart';
import 'package:am_i_dreaming/src/view/users/user_empty_details_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, appState, _) =>
            appState.userDocument == null && appState.userDocumentSet
                ? const UserEmptyDetailsView()
                : const UserDetailsView());
  }
}
