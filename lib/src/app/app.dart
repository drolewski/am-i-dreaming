import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import '../home/home.dart';
import '../view/dreams/dream/dream_details.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      title: 'Am I Dreaming?',
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FirebaseUILocalizations.delegate
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: const CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: CupertinoColors.systemTeal,
      ),
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(routes: [
  GoRoute(path: "/", builder: (context, state) => const Home(), routes: [
    GoRoute(
        path: "/dream/:index",
        builder: (context, state) {
          final index = state.pathParameters["index"]!;
          return DreamDetails(dreamIndex: int.parse(index));
        })
  ])
]);
