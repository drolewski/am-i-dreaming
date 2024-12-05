import 'package:am_i_dreaming/src/home/auth/auth.dart';
import 'package:am_i_dreaming/src/view/users/user_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';
import 'navigation/navigation.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, appState, _) => !appState.loggedIn
            ? const AuthGate()
            : appState.userDocumentSet && appState.userDocument == null
                ? Consumer<ApplicationState>(
                    builder: (context, appState, _) => UserForm(
                          addUser: (user) => appState.addUser(user),
                        ))
                : const Navigation());
  }
}
