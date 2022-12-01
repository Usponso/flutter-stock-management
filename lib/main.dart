import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_management/providers/TransactionProvider.dart';
import 'package:stock_management/screen/connectionPage/SignInScreen.dart';
import 'package:stock_management/providers/CustomersProvider.dart';
import 'package:stock_management/providers/devicesProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  /*runApp(const MyApp());*/
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => CustomerProvider(),),
      ChangeNotifierProvider(create: (context) => DevicesProvider(),),
      ChangeNotifierProvider(create: (context) => TransactionProvider(),),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stock Management',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: SignInScreen(),//const MyHomePage(title: 'Gestion de stock'),
    );
  }
}
