import 'package:docs_clone/colors.dart';
import 'package:docs_clone/repository/auth_repository.dart';
import 'package:docs_clone/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});
  void signInWithGoogle(WidgetRef ref, BuildContext context) async{
    final sMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final errorModel = await ref.read(authRepositoryProvider).signInWithGoogle();
    if(errorModel.error == null){
      ref.read(userProvider.notifier).update((state)=>
      errorModel.data);
      navigator.push(MaterialPageRoute(builder: (ctx)=> HomeScreen()),);
    }else{
      sMessenger.showSnackBar(
        SnackBar(content: Text(errorModel.error!)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
          child: ElevatedButton.icon(
        onPressed: () => signInWithGoogle(ref,context),
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
