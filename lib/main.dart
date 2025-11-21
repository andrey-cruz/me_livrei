import 'package:flutter/material.dart';
import 'package:me_livrei/screens/loading_screen.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Me Livrei',
      home: const LoadingScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
