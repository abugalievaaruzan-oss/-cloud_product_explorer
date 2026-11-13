
import 'package:flutter/material.dart';

import 'screens/product_list_screen.dart';

void main() {
  runApp(const CloudProductExplorer());
}

class CloudProductExplorer extends StatelessWidget {
  const CloudProductExplorer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cloud Product Explorer',

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),

      home: const ProductListScreen(),
    );
  }
}
