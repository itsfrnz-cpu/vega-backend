import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
runApp(const VegaApp());
}

class VegaApp extends StatelessWidget {
const VegaApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
title: 'Vega',
home: const HomeScreen(),
);
}
}