import 'package:docs_clone/colors.dart';
import 'package:docs_clone/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});
  void signInWithGoogle(WidgetRef ref) {
    ref.read(authRepositoryProvider).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
          child: ElevatedButton.icon(
        onPressed: () => signInWithGoogle(ref),
        label: Text(
          'Sign In with Google',
          style: TextStyle(color: kBlackColor),
        ),
        icon: Image.asset(
          'assets/icons/google.png',
          height: 24,
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(16),
          backgroundColor: kWhiteColor,
          minimumSize: Size(150, 50),
        ),
      )),
    );
  }
}
