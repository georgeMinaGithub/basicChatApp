import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_final/layout/home_screen.dart';
import 'package:social_app_final/network/cach_helper.dart';
import 'package:social_app_final/network/dio_helper.dart';
import 'package:social_app_final/shared/bloc_observer.dart';
import 'package:social_app_final/shared/componnetns/components.dart';
import 'package:social_app_final/shared/componnetns/constants.dart';
import 'package:social_app_final/shared/mode_cubit/cubit.dart';
import 'package:social_app_final/shared/mode_cubit/state.dart';
import 'package:social_app_final/shared/styles/themes.dart';
import 'Screens/login/login_screen.dart';


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async
{
  if (kDebugMode)
  {
    print("on Message Background ");
    print(message.data.toString());
  }
  showToast(text: 'on Message Background ', state: ToastStates.success);
}

void main() async {


  WidgetsFlutterBinding.ensureInitialized();

  // BlocObserver: MyBlocObserver() ;
  BlocOverrides.runZoned(
        ()
    {

    },
    blocObserver: MyBlocObserver() ,
  );
  DioHelper.init();
  await CacheHelper.init();

  await Firebase.initializeApp();

  var token = FirebaseMessaging.instance.getToken();
  if (kDebugMode)
  {
    print(token);
  }

  // fore ground fcm
  FirebaseMessaging.onMessage.listen((event)
  {
    if (kDebugMode)
    {
      print("on Message");
      print(event.data.toString());
    }
    showToast(text: 'on Message', state: ToastStates.success);
  });

  // when click on notification open app
  FirebaseMessaging.onMessageOpenedApp.listen((event)
  {
    if (kDebugMode)
    {
      print("on Message Opened App");
      print(event.data.toString());
    }
    showToast(text: 'on Message Opened App', state: ToastStates.success);
  });

  // back ground fcm
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  late bool? isDark = CacheHelper.getBoolean(key: 'isDark');

   Widget widget;

 // late  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
 //
 //   token = CacheHelper.getData(key: 'token');

   uId = CacheHelper.getData(key: 'uId');


  if(uId != null )
    {

      widget =  const HomeScreen();
    }
  else
    {
      widget =  const LoginScreen();
    }


  // if(onBoarding != null)
  // {
  //   if(token != null)
  //   {
  //     widget = LoginScreen() ;
  //   }
  //   else
  //   {
  //     widget = LoginScreen();
  //   }
  // }
  // else
  // {
  //   widget =  LoginScreen() ;
  // }

  runApp(Myapp(
    startWidget: widget ,
    isDark: isDark,
  ));
}

class Myapp extends StatelessWidget {
  final  bool? isDark;
  final Widget startWidget;

  const Myapp({Key? key, required this.startWidget, required this.isDark}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [

        BlocProvider(
          create: (context) => ModeCubit()
            ..changeAppMode(
              fromShared: isDark,
            ),
        ) ,

      ],
      child: BlocConsumer<ModeCubit, ModeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ModeCubit.get(context).isDark
                ? ThemeMode.dark
                : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home:startWidget,
          );
        },
      ),
    );
  }
}
