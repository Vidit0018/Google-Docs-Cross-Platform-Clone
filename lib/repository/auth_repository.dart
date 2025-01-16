import 'dart:convert';

import 'package:docs_clone/constants.dart';
import 'package:docs_clone/helper_funcitons/pretty_response.dart';
import 'package:docs_clone/models/error_model.dart';
import 'package:docs_clone/models/user_model.dart';
import 'package:docs_clone/repository/local_storage_repository.dart';
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
    localStorageRepository: LocalStorageRepository(),
  ),
);
final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final Client _client;
  final GoogleSignIn _googleSignIn;
  final LocalStorageRepository _localStorageRepository;

  AuthRepository({required GoogleSignIn googleSignIn, required Client client , required LocalStorageRepository localStorageRepository })
      : _googleSignIn = googleSignIn,
        _client = client,_localStorageRepository= localStorageRepository;
  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error =
        ErrorModel(error: 'Some unexpected error occured ', data: null);
    try {
      print('Signing out any existing session...');
      await _googleSignIn.signOut(); //
      print('trying to sign in ');
      final user = await _googleSignIn.signIn();
      
      if (user != null) {

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
              token : jsonDecode(res.body)['token'],
            );
            error = ErrorModel(error: null, data: newUser);
            _localStorageRepository.setToken(newUser.token);
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
  Future<ErrorModel> getUserData() async {
    ErrorModel error =
        ErrorModel(error: 'Some unexpected error occured ', data: null);
    try {
        print('inside get user data');
        String? token = await _localStorageRepository.gettoken();
        print(token);
        if(token!= null){

        var res = await _client.get(Uri.parse('$host/'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token':token,
            });

           printPrettyResponse(res.body);
        switch (res.statusCode) {
          case 200:final newUser = UserModel.fromJson(
              jsonEncode(
                jsonDecode(res.body)['user'],
              ),
            ).copyWith(token: token);

            error = ErrorModel(error: null, data: newUser);
            _localStorageRepository.setToken(newUser.token);
            break;
      }
        }
    } catch (e) {
      // print('!!!!!!!!!!! Error !!!!!!!!!');
      print(e);
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }
}
