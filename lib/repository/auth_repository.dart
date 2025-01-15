import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
final authRepositoryProvider = Provider((ref)=>
AuthRepository(googleSignIn: GoogleSignIn(),),
);
class AuthRepository {
  final GoogleSignIn _googleSignIn;

  AuthRepository({required GoogleSignIn googleSignIn}) : _googleSignIn = googleSignIn;
  void signInWithGoogle()async{
    try{
      print('Signing out any existing session...');
    await _googleSignIn.signOut(); //
      print('trying to sign in ');
      final user = await _googleSignIn.signIn();
      if(user!=null){
        print(user.email);
        print(user.displayName);
        print(user.photoUrl);
      }
    }catch(e){
      print('!!!!!!!!!!! Error !!!!!!!!!');
      print(e);
    }
  }
  // Future<void> signInSilently() async {
  //   try {
  //     print('Attempting silent sign-in...');
  //     final user = await _googleSignIn.signInSilently();
  //     if (user != null) {
  //       print('Silent Sign-In Successful');
  //       print('Email: ${user.email}');
  //       print('Name: ${user.displayName}');
  //       print('Photo URL: ${user.photoUrl}');
  //     } else {
  //       print('No existing session found.');
  //     }
  //   } catch (e) {
  //     print('Silent sign-in error: $e');
  //   }
  // }

}