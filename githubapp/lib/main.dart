import 'package:flutter/material.dart';
import 'package:githubapp/Providers/LoginProviders/LoginProviders.dart';
import 'package:githubapp/Providers/OrganizationProvider/OrganizationProviders.dart';
import 'package:githubapp/Providers/HomeProviders/homepageProviders.dart';
import 'package:githubapp/Providers/RepositoryProvider.dart/repositoryProviders.dart';
import 'package:githubapp/Screens/Hompage/HomePage.dart';
import 'package:githubapp/Screens/LoginPage/LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:githubapp/Styles/appColors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => HomeProviders()),
        ChangeNotifierProvider(create: (_) => OrganizationProviders()),
        ChangeNotifierProvider(create: (_) => RepositoryProviders()),
      ],
      child: MaterialApp(
          routes: {
            Homepage.routeName: ((context) => Homepage()),
            LoginPage.routeName: ((context) => LoginPage()),
          },
          title: 'Flutter Demo',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: AppColors.themeColor,
            appBarTheme: AppBarTheme(color: AppColors.themeColor),
          ),
          home: const LoginPage()),
    );
  }
}
