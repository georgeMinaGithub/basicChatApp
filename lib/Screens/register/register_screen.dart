
import 'dart:io';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app_final/Screens/register/cubit/cubit.dart';
import 'package:social_app_final/Screens/register/cubit/state.dart';
import 'package:social_app_final/layout/home_screen.dart';
import 'package:social_app_final/shared/componnetns/components.dart';

class RegisterScreen extends StatelessWidget {
 late  var formKey = GlobalKey<FormState>();

 late var emailController = TextEditingController();

 late var passwordController = TextEditingController();

 late  var nameController = TextEditingController();

  late var phoneController = TextEditingController();

  late var imageController = TextEditingController();

 late File? profileImage;
 late  var pickerController = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
         if(state is RegisterCreateUsersSuccessState)
           {
             navigateAndFinish(context, const HomeScreen());
           }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                    [
                      Text(
                        "Register",
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 28),
                      ),

                      const SizedBox(height: 10,),

                      Text(
                          "Register Now to communicate with Friends!",
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.grey)
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultTextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        prefix: Icons.person,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                        label: 'Name',
                        hint: 'Enter your name',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultTextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefix: Icons.email,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please enter email';
                          }
                          return null;
                        },
                        label: 'Email',
                        hint: 'Enter your email',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultTextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        prefix: Icons.phone,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please enter phone';
                          }
                          return null;
                        },
                        label: 'Phone',
                        hint: 'Enter your phone',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultTextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        prefix: Icons.key,
                        suffix: RegisterCubit.get(context).suffix,
                        isPassword: RegisterCubit.get(context).isPassword,
                        suffixPressed: () {
                          RegisterCubit.get(context).changePassword();
                        },
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                        label: 'Password',
                        hint: 'Enter your password',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ConditionalBuilder(
                        condition: state is! RegisterLoadingState,
                        builder: (context) => Center(
                          child: defaultMaterialButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                RegisterCubit.get(context).userRegister(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  // bio: 'write your bio ...',
                                  // image: 'https://play-lh.googleusercontent.com/ZtQUlSftsOmbVp6dLiFZWGdnqiMBlsNxfVW7hwWJjjvbTWR26ED4U45HwU8mzyF8Wuo=w240-h480-rw',
                                  // cover: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSus5wnvGfMT31RotRl7GKrSNeMITpS1R4ktQ&usqp=CAU',
                                );

                              }
                            },
                            text: 'Register',
                            radius: 20,
                          ),
                        ),
                        fallback: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                    ]),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ) ;
  }
}
