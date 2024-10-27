import 'package:flutter/material.dart';
import 'package:bat_species/src/app/pages.dart' as app;
import 'package:bat_species/src/core/core.dart' as core;

void main() async {
  // Load data.
  WidgetsFlutterBinding.ensureInitialized();
  core.loadData();
  // Start app.
  app.startApp();
}
