import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  var auth = FirebaseAuth.instance;

  void login(String email, String password) async {
    emit(LoginLoadingState());
    try {
      var user = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (user.user == null) {
        print("Login Error");
        emit(LoginErrorState());
      } else {
        print("Login Success");
        emit(LoginSuccessState());
      }
    } catch (e) {
      print(e.toString());
      emit(LoginErrorState());
    }
  }

  bool checkLogin() {
    // auth.signOut();
    return auth.currentUser != null;
  }
}
