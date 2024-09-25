import 'package:flutter/material.dart';
import 'package:threads/Screens/favourite_screen.dart';
import 'package:threads/Screens/post_screen.dart';
import 'package:threads/Screens/profile_screen.dart';
import 'package:threads/Screens/search_screen.dart';
import 'package:threads/Screens/timeline_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  final List<Widget> listOfScreens = [
    TimelineScreen(),
    SearchScreen(),
    PostScreen(),
    FavouriteScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: listOfScreens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.black,
            currentIndex: currentIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Color(0xffB8B8B8),
            onTap: (index) {
              if (index == 2) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PostScreen()));
              } else {
                setState(() {
                  currentIndex = index;
                });
              }
            },
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                label: '',
                icon: ImageIcon(
                  AssetImage('assets/Images/Home.png'),
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: ImageIcon(
                  AssetImage('assets/Images/Search.png'),
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: ImageIcon(
                  AssetImage('assets/Images/Write.png'),
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: ImageIcon(
                  AssetImage('assets/Images/Activity.png'),
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: ImageIcon(
                  AssetImage('assets/Images/Person.png'),
                ),
              ),
            ]));
  }
}
