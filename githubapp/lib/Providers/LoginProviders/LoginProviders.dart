import 'package:flutter/material.dart';
import 'package:githubapp/Models/userModels.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:github_sign_in/github_sign_in.dart';

class LoginProvider with ChangeNotifier {
  late UserModel a;
  getUserData() {
    return a;
  }

  signinusinggithub(context) async {
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: 'de5236d159995891e55c',
        clientSecret: '698aa4c1cf07630b07fb37f916b11be0d64d4521',
        redirectUrl: 'https://githubapp-ceeb1.firebaseapp.com/__/auth/handler');

    var result = await gitHubSignIn.signIn(context);
    if (result.status.toString().contains("ok")) {
      final githubCredentials = GithubAuthProvider.credential(result.token!);
      var token =
          await FirebaseAuth.instance.signInWithCredential(githubCredentials);
      var userinfo1 = token.additionalUserInfo!.profile;
      var userinfo2 = token.user!;

      a = UserModel(userinfo1!["login"], userinfo2.displayName, userinfo2.email,
          userinfo2.photoURL, userinfo2.phoneNumber);
      return true;
    } else {
      return false;
    }
  }
}
