import 'package:coba_sertif/screens/login.dart';
import 'package:coba_sertif/screens/profile.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedTabIndex = 0;

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _listPage = <Widget>[
      const Text('Selamat Datang'),
      const Profile(),
      const Text('Lokasi'),
    ];

    final _bottomNavBarItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.location_on), label: 'Lokasi'),
    ];

    final _bottomNavBar = BottomNavigationBar(
      items: _bottomNavBarItems,
      currentIndex: _selectedTabIndex,
      selectedItemColor: Colors.amber,
      unselectedItemColor: Colors.grey,
      onTap: _onNavBarTapped,
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Sertifikasi',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => const Login()),
                        (Route route) => route == null);
                  },
                  child: const Icon(
                    Icons.logout,
                    size: 26.0,
                    color: Colors.black,
                  ),
                )),
          ],
          backgroundColor: Colors.amber,
        ),
        body: Center(child: _listPage[_selectedTabIndex]),
        bottomNavigationBar: _bottomNavBar,
      ),
    );
  }
}
