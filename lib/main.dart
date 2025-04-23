import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_market/screens/login_screen.dart';
import 'package:my_market/screens/mobscreen_layout.dart';
import 'package:my_market/screens/responsive_layout.dart';
import 'package:my_market/screens/webscreen_layout.dart';
import 'package:my_market/screens/notification_panel_screen.dart';
import 'package:my_market/users_provider.dart';
import 'package:provider/provider.dart';
import 'package:my_market/services/background_sync_service.dart';
import 'package:my_market/screens/admin_login_screen.dart';
import 'package:my_market/screens/admin_dashboard_screen.dart';
import 'package:my_market/services/admin_auth_service.dart';
import 'package:my_market/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await BackgroundSyncService.initialize();
  
  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Market',
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const AuthWrapper(),
        routes: {
          '/admin/login': (context) => const AdminLoginScreen(),
          '/admin/dashboard': (context) => const AdminDashboardScreen(),
          '/notifications': (context) => const NotificationPanelScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return FutureBuilder<bool>(
              future: AdminAuthService().isAdmin(),
              builder: (context, adminSnapshot) {
                if (adminSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (adminSnapshot.data == true) {
                  return const AdminDashboardScreen();
                }
                
                return const ResponsiveLayout(
                  mobScreenLayout: MobScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }
        }
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        return const LoginScreen();
      },
    );
  }
}




