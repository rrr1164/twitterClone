import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavigationCubit extends Cubit<int> {

  BottomNavigationCubit() : super(0);

  void pressedState(int statePressed) {
    emit(statePressed);
  }
}
