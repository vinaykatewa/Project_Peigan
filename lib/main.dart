import 'package:flutter/material.dart';
import 'package:hey/screen/authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:hey/providers/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hey/screen/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapShot) {
            if(snapShot.connectionState == ConnectionState.waiting){
              return const CircularProgressIndicator();
            }
            else{
              if(snapShot.hasData){
                return const Home();
              }
              else{
                return const Auth();
              }
            }
          },
        ));
  }
}
