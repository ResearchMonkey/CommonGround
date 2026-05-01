import 'package:flutter/material.dart';

void main() {
  runApp(const CommonGroundApp());
}

/// Application root.
///
/// This is the only place where concrete implementations are wired into
/// domain contracts (SA-004). Constructor-inject every dependency from here
/// down — no service locator, no globals.
class CommonGroundApp extends StatelessWidget {
  const CommonGroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'CommonGround',
      home: Scaffold(
        body: Center(
          child: Text('CommonGround'),
        ),
      ),
    );
  }
}
