import 'package:travelers_guide_to_bats/src/app/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelers_guide_to_bats/src/app/pages/main_page/cubit/theme_cubit.dart';
import 'package:travelers_guide_to_bats/src/app/pages/main_page/cubit/data_cubit.dart';
import 'package:travelers_guide_to_bats/src/app/pages/countries_page/cubit/countries_cubit.dart';
import 'package:travelers_guide_to_bats/src/app/pages/by_country_page/cubit/by_country_cubit.dart';

void startApp() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ThemeCubit>(
        lazy: false,
        create: (context) => ThemeCubit()..loadInitialTheme(),
      ),
      BlocProvider<ByCountryCubit>(
        lazy: false,
        create: (context) => ByCountryCubit()..loadInitialByCountry(),
      ),
      BlocProvider<CountriesCubit>(
        lazy: false,
        create: (context) => CountriesCubit()..loadInitialCountry(),
      ),
      BlocProvider<DataCubit>(
        lazy: true,
        create: (context) => DataCubit()..loadData(),
      ),
    ],
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
