import 'dart:convert';

import 'package:docs_clone/constants.dart';
import 'package:docs_clone/models/error_model.dart';
import 'package:docs_clone/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    googleSignIn: GoogleSignIn(
      scopes: [
    'email',
    'profile',
    'https://www.googleapis.com/auth/userinfo.profile',
  ],

    ),
    
    client: Client(),
  ),
);
final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final Client _client;
  final GoogleSignIn _googleSignIn;

  AuthRepository({required GoogleSignIn googleSignIn, required Client client})
      : _googleSignIn = googleSignIn,
        _client = client;
  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error =
        ErrorModel(error: 'Some unexpected error occured ', data: null);
    try {
      print('Signing out any existing session...');
      await _googleSignIn.signOut(); //
      print('trying to sign in ');
      final user = await _googleSignIn.signIn();
      
      if (user != null) {
        print('User info: ${user.toString()}');

        print('URL!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${user.photoUrl}');
        final userAcc = UserModel(

            email: user.email,
            name: user.displayName!,
            profilePic: user.photoUrl??'https://cdn.pixabay.com/photo/2021/07/02/04/48/user-6380868_1280.png',
            uid: '',
            token: '');

        var res = await _client.post(Uri.parse('$host/api/signup'),
            body: jsonEncode(userAcc.toJson()), 
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            });
        switch (res.statusCode) {
          case 200:
            final newUser = userAcc.copyWith(
              uid: jsonDecode(res.body)['user']['_id'],
            );
            error = ErrorModel(error: null, data: newUser);
            break;
        }
      }
    } catch (e) {
      print('!!!!!!!!!!! Error !!!!!!!!!');
      print(e);
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
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
