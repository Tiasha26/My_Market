
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_market/home_page.dart';
import 'package:my_market/screens/login_screen.dart';
import 'package:my_market/screens/mobscreen_layout.dart';
import 'package:my_market/screens/responsive_layout.dart';
import 'package:my_market/screens/signup_screen.dart';
import 'package:my_market/screens/webscreen_layout.dart';
import 'package:my_market/users_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(),),],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Market',
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.white,
        ),
        home:  StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.active){
              if (snapshot.hasData){
                return const ResponsiveLayout(
                    mobScreenLayout: MobScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child:  CircularProgressIndicator(),
              );
            } else {
              return const LoginScreen();
            }

          },
        ),
      ),
    );

     /* MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: LoginScreen.id,
          routes: {
            LoginScreen.id: (context) => LoginScreen(),
            SignUP.id: (context) => SignUP(),
            HomePage.id: (context) => HomePage(),
          }
      );*/
  }
}




