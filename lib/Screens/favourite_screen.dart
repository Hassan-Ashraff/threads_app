import 'package:flutter/material.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: Text('No posts',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),),
    );
  }
}
