import 'package:flutter/material.dart';
import 'package:travelers_guide_to_bats/src/app/pages.dart' as app;
import 'package:travelers_guide_to_bats/src/core/core.dart' as core;

void main() async {
  // Load data.
  WidgetsFlutterBinding.ensureInitialized();
  core.loadData();
  // Start app.
  app.startApp();
}
