
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_final/Screens/login/cubit/cubit.dart';
import 'package:social_app_final/Screens/login/cubit/state.dart';
import 'package:social_app_final/Screens/register/register_screen.dart';
import 'package:social_app_final/layout/home_screen.dart';
import 'package:social_app_final/network/cach_helper.dart';
import 'package:social_app_final/shared/componnetns/components.dart';



class LoginScreen extends StatelessWidget {

  const LoginScreen({super.key});


  @override
  Widget build(BuildContext context) {


    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState >(
        listener: (context, state) {
          if (state is LoginErrorState) {
            showToast(
              text: state.error,
              state: ToastStates.error,
            );
          }
          if(state is LoginSuccessState)
            {
              CacheHelper.saveData(
                  key: 'uId',
                  value: state.uId,
              ).then((value)
              {
                navigateAndFinish(
                    context,
                    const HomeScreen()
                );
              });
            }
        },

        builder: (context, state) {
          var formKey = GlobalKey<FormState>();

          var emailController = TextEditingController();

          var passwordController = TextEditingController();

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,

            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Login",
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 28),
                        ),

                        const SizedBox(height: 10,),

                        Text(
                          "Login Now to communicate with Friends!",
                            style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.grey)
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
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          prefix: Icons.key,
                          suffix: LoginCubit.get(context).suffix,
                          isPassword: LoginCubit.get(context).isPassword,
                          suffixPressed: () {
                            LoginCubit.get(context).ChangePassword();
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
                        defaultTextButton(
                          function: () {},
                          text: "Forgotten password?",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          builder: (context) => Center(
                            child: defaultMaterialButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  LoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text);

                                }
                              },
                              text: 'Login',
                              radius: 20,
                            ),
                          ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              'Don\'t have an account?',
                                style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.grey),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            defaultTextButton(
                              function: () {
                                navigateTo(context, RegisterScreen());
                              },
                              text: 'Register Now!',
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
