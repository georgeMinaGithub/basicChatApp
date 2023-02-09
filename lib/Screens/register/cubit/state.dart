

abstract class RegisterState {}

class RegisterInitialState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterSuccessState extends RegisterState {}

class RegisterErrorState extends RegisterState {
  final String error;

  RegisterErrorState( this.error);
}


class RegisterCreateUsersSuccessState extends RegisterState {}

class RegisterCreateUsersErrorState extends RegisterState {
  final String error;

  RegisterCreateUsersErrorState(this.error);
}

class ChangePasswordRegisterState extends RegisterState {}
