import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    return StreamBuilder(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return HomeScreen();
        } else {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Container(
              width: widthScreen,
              height: heightScreen,
              child: Column(
                children: [
                  SizedBox(
                      height: heightScreen * 0.8,
                      width: widthScreen,
                      child: Image.asset('assets/Images/Pattern.png')),
                  Container(
                    margin: EdgeInsets.all(widthScreen*0.028),
                    child: TextButton(
                      onPressed: () async {
                        UserCredential userCredential = await signInWithGoogle();
                        User? user = userCredential.user;

                        if (user != null) {
                          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                            'userId': user.uid,
                            'name': user.displayName,
                            'photo': user.photoURL,
                          });
                        }
                      },
                      child: ListTile(
                        title: Text(
                          'Login with Google',
                          style: TextStyle(color: Color(0xffB2B3B2)),
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              '@Hassanashraf',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width:widthScreen*0.01),
                            Image.asset('assets/Images/Verified.png'),
                          ],
                        ),
                        trailing: Image.asset('assets/Images/Group.png'),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xff191919),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: BorderSide(
                            color: Color(0xff393939),
                            width: widthScreen*0.004,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: heightScreen*0.015),
                  Text(
                    'Switch accounts',
                    style: TextStyle(color: Color(0xff999999)),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
