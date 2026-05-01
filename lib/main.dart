import 'package:commonground/core/map/presentation/map_shell_binding.dart';
import 'package:flutter/material.dart';

/// Entry point — composition and DI live in [MapShellBinding] (SA-004).
void main() {
  runApp(const MapShellBinding());
}

