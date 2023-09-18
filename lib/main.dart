import 'package:flutter/material.dart';

import 'login_screen.dart';

void main() {
  runApp(const AnimatedLoginExample());
}

class AnimatedLoginExample extends StatelessWidget {
  const AnimatedLoginExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const LoginExample(),
    );
  }
}
