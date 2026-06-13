import 'package:flutter/material.dart';
import 'package:laperbang/Pages/profile.dart';
import 'package:provider/provider.dart';
import 'package:laperbang/Pages/favorit.dart';
import 'package:laperbang/Pages/home.dart';
import 'package:laperbang/Pages/jajan.dart';
import '../Services/jajan_provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JajanProvider>();

    final List<Widget> pages = [
      const Home(),
      const MapJajan(),
      const FavoriteVendors(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: pages[provider.mainTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey.shade50,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Jajan'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: provider.mainTabIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) => context.read<JajanProvider>().changeTab(index),
      ),
    );
  }
}
