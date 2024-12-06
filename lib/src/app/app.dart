import 'package:am_i_dreaming/src/home/auth/auth.dart';
import 'package:am_i_dreaming/src/view/users/user_form.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import '../home/navigation/navigation.dart';
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
        FirebaseUILocalizations.delegate,
        CountryLocalizations.delegate,
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

final _router = GoRouter(
    initialLocation: "/",
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null && state.uri.toString() != '/login') {
        return '/login';
      }
      return null;
    },
    routes: [
      GoRoute(path: "/", builder: (context, state) => const Navigation()),
      GoRoute(
          path: "/dreams/:index",
          builder: (context, state) {
            final index = state.pathParameters["index"]!;
            return DreamDetails(dreamIndex: int.parse(index));
          }),
      GoRoute(
        path: "/login",
        builder: (context, state) => const AuthGate(),
        routes: [
          GoRoute(
            path: 'forgot-password',
            builder: (context, state) {
              final arguments = state.uri.queryParameters;
              return ForgotPasswordScreen(
                email: arguments['email'],
                headerMaxExtent: 200,
              );
            },
          ),
        ],
      ),
      GoRoute(path: "/user/form", builder: (context, state) => UserForm()),
    ]);
