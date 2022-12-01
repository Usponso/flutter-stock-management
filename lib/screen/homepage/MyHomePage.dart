import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stock_management/screen/connectionPage/SignInScreen.dart';

import '../customerPage/CustomersPage.dart';
import '../productPage/ProductPage.dart';
import '../../utils/authentication.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.user});

  final String title;
  final User user;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool _isSigningOut = false;
  @override
  Widget build(BuildContext context) {

    List<Widget> _widgetOptions = <Widget>[
      ProductPage(user: widget.user),
      CustomersPage(),
    ];

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
        backgroundColor: Colors.deepPurple[400],
        leading: widget.user.photoURL != null
            ? Padding(
          child: ClipOval(
            child: Image.network(
              widget.user.photoURL!,
              fit: BoxFit.fitHeight,
            ),
          ),
          padding: EdgeInsets.all(10),
        )
            : ClipOval(
          child: Material(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        actions: [

          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () async {
              setState(() {
                _isSigningOut = true;
              });
              await Authentication.signOut(context: context);
              setState(() {
                _isSigningOut = false;
              });
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(
                builder: (context) => SignInScreen()
                ),
              );
            },
          )
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.devices),
            label: "Produits",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: "Répertoire",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple[400],
        onTap: _onItemTapped,
      ),
    );
  }
}