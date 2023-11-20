import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_school_firebase/cubits/Auth/auth_cubit.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final codeController = TextEditingController();

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(controller: emailController),
            TextFormField(controller: passwordController),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                if (state is LoginLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is LoginSuccessState) {
                  return const Center(
                    child: Icon(Icons.check, color: Colors.green, size: 50),
                  );
                } else {
                  return ElevatedButton(
                      onPressed: () async {
                        AuthCubit.get(context).login(
                            emailController.text, passwordController.text);
                      },
                      child: const Text("Login"));
                }
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    var user = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );

                    print(user.user!.uid);
                  } catch (e) {
                    print(e.toString());
                  }
                },
                child: Text("Create Account")),
            TextFormField(controller: phoneController),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.verifyPhoneNumber(
                  timeout: const Duration(seconds: 60),
                  phoneNumber: phoneController.text,
                  verificationCompleted: (phoneAuthCredential) {
                    FirebaseAuth.instance
                        .signInWithCredential(phoneAuthCredential);
                  },
                  verificationFailed: (error) {
                    print(error);
                  },
                  codeSent: (verificationId, forceResendingToken) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: Column(
                            children: [
                              TextFormField(controller: codeController),
                              ElevatedButton(
                                onPressed: () async {
                                  var credential = PhoneAuthProvider.credential(
                                    verificationId: verificationId,
                                    smsCode: codeController.text,
                                  );

                                  var user = await FirebaseAuth.instance
                                      .signInWithCredential(credential);

                                  if (user.user != null) {
                                    print("Login Success");
                                  }
                                },
                                child: const Text("Verify Code"),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                  codeAutoRetrievalTimeout: (verificationId) {
                    print("resend Code");
                  },
                );
              },
              child: Text("Login With Phone"),
            ),
            ElevatedButton(
                onPressed: () {
                  signInWithGoogle();
                },
                child: const Text("Sign in with google"))
          ],
        ),
      ),
    );
  }
}
