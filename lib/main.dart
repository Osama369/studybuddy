import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:studyapp/routes/app_routes.dart';

import 'bindings/initial_bindings.dart';
import 'controllers/common/theme_controller.dart';
import 'screens/data_uploadScreen.dart';
import 'firebase_options.dart';
import 'bindings/initial_bindings.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await initFireBase();

 // Initialize ThemeController
 Get.put(ThemeController());

 InitialBindings().dependencies();

 SystemChrome.setPreferredOrientations(
     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
  runApp(const MyApp());
 });
}

class MyApp extends StatelessWidget {
 const MyApp({Key? key}) : super(key: key);

 static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

 @override
 Widget build(BuildContext context) {
  return GetMaterialApp(
   navigatorKey: navigatorKey,
   title: 'Flutter Demo',
   theme: Get.find<ThemeController>().getLightheme(),
   darkTheme: Get.find<ThemeController>().getDarkTheme(),
   getPages: AppRoutes.pages(),
   debugShowCheckedModeBanner: false,
  );
 }
}

Future<void> initFireBase() async {
 await Firebase.initializeApp(
  name: 'quizzle-demo',
  options: DefaultFirebaseOptions.currentPlatform,
 );
}

//  void main() async{
//    WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//    options: DefaultFirebaseOptions.currentPlatform,
//  );
//   runApp(GetMaterialApp(home: DataUploadscreen(),));
// }

