import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      actions: [
        ForgotPasswordAction(((context, email) {
          final uri = Uri(
            path: '/login/forgot-password',
            queryParameters: <String, String?>{
              'email': email,
            },
          );
          context.push(uri.toString());
        })),
        AuthStateChangeAction<SignedIn>((context, state) {
          if (!state.user!.emailVerified) {
            context.pushReplacement('/login');
          } else {
            context.pushReplacement('/');
          }
        }),
        AuthStateChangeAction(((context, state) async {
          final user = switch (state) {
            SignedIn state => state.user,
            UserCreated state => state.credential.user,
            _ => null
          };
          if (user == null) {
            return;
          }
          if (state is UserCreated) {
            user.updateDisplayName(user.email!.split('@')[0]);
            context.pushReplacement('/');
          }
        })),
      ],
      providers: [
        EmailAuthProvider(),
        GoogleProvider(
            clientId:
                "341744325210-ldbgkg14bk1gbjerfkknkthpifrp0jin.apps.googleusercontent.com")
      ],
      headerBuilder: (context, constraints, shrinkOffset) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset('assets/img.png'),
          ),
        );
      },
    );
  }
}
