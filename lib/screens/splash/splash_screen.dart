// import 'package:flutter/material.dart';
//
// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         alignment: Alignment.center,
//
//         child: Image.asset('assets/images/app_splash_logo.png',   height: 200,  width: 200,),
//
//
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:studyapp/configs/configs.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(gradient: mainGradient(context)),
        child: Image.asset('assets/images/app_splash_logo.png',   height: 200,  width: 200,),
      ),
    );
  }
}