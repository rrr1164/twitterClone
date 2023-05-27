import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitterclone/cubit/signup/signup_state.dart';
import 'package:twitterclone/data/models/user_model.dart';
import 'package:twitterclone/data/repo/user_repo.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  final UserRepo _repo = UserRepo();

  Future<void> registerUser(
      String email, String password, String username) async {
    emit(SignUpLoading());
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel userModel = UserModel.twoValues(
          userName: username,
          firebaseId: FirebaseAuth.instance.currentUser!.uid);
      await _repo.insertUser(userModel);
      emit(SignUpSuccess());
    } catch (e) {
      emit(SignUpFailure());
    }
  }
}
