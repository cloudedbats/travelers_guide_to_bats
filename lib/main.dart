import 'package:flutter/material.dart';
import 'package:travelers_guide_to_bats/src/app/pages.dart' as app;
import 'package:travelers_guide_to_bats/src/core/core.dart' as core;

void main() async {
  // Load data.
  WidgetsFlutterBinding.ensureInitialized();
  core.loadData();
  await Future.delayed(const Duration(seconds: 3)); // TODO Remove this later.
  // Start app.
  app.startApp();
}
