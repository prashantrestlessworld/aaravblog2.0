import 'package:aaravblog/views/create_post_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CreatePostScreen(),
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
