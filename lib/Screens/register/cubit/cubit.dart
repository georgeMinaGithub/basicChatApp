
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_final/Screens/register/cubit/state.dart';
import 'package:social_app_final/model/social_app/social_user_model.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitialState());
  static RegisterCubit get(context) => BlocProvider.of(context);

  // late SocialUsersModel model ;

  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,

  }) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
    ).then((value)
    {
      if (kDebugMode)
      {
        print(value.user!.email);
        print(value.user!.uid);
      }
      createUser(
          email: email,
          name: name,
          phone: phone,
          uId: value.user!.uid,
      );
    }).catchError((error)
    {
      emit(RegisterErrorState(error.toString()));
      if (kDebugMode)
      {
        print(error.toString());
      }
    });
  }

  void createUser(
  {
    required String email,
    required String name,
    required String phone,
    required String uId,
})
  {
     SocialUserModel model = SocialUserModel(
        name: name,
        email: email,
        phone: phone,
        uId: uId,
        bio: 'write Your Bio',
        image:'https://image.freepik.com/free-photo/photo-attractive-bearded-young-man-with-cherful-expression-makes-okay-gesture-with-both-hands-likes-something-dressed-red-casual-t-shirt-poses-against-white-wall-gestures-indoor_273609-16239.jpg' ,
        cover: 'https://image.freepik.com/free-photo/photo-attractive-bearded-young-man-with-cherful-expression-makes-okay-gesture-with-both-hands-likes-something-dressed-red-casual-t-shirt-poses-against-white-wall-gestures-indoor_273609-16239.jpg',
      isEmailVerified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
    .set
      (
        model.toMap()!
      )
        .then((value)
    {
      emit(RegisterCreateUsersSuccessState());
    }).catchError((error)
    {
      emit(RegisterCreateUsersErrorState(error));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePassword() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ChangePasswordRegisterState());
  }
}
