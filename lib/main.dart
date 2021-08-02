import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/constants/constants.dart';
import 'package:untitled1/model/userModel.dart';
import 'package:untitled1/screens/home_screen/DashBord.dart';
import 'package:untitled1/services/auth.dart';
import 'screens/login_screen/loginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider<UserModel>(
          create: (context) => UserModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Attendance',
        theme: ThemeData.light(),
        home: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthProvider auth = Provider.of<AuthProvider>(context);
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;
          return signedIn ? Dash(): LoginScreen();
        }
        return Center(
          child: loadingIndicator,
        );
      },
    );
  }
}
