import 'package:bat_species/src/app/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bat_species/src/app/pages/home_page/cubit/theme_cubit.dart';

void startApp() {
  runApp(BlocProvider<ThemeCubit>(
    create: (context) => ThemeCubit()..setInitialTheme(),
    child: _MainApp(),
  ));
}

class _MainApp extends StatelessWidget {
  // const _MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
            theme: state.themeData,
            debugShowCheckedModeBanner: false,
            home: const HomePage());
      },
    );
  }
}

