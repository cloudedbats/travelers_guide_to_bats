import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelers_guide_to_bats/src/app/pages/countries_page/countries_page.dart';
import 'package:travelers_guide_to_bats/src/app/pages/species_page/species_page.dart';
import 'package:travelers_guide_to_bats/src/app/pages/home_page/cubit/theme_cubit.dart'
    as theme_cubit;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Widget userSelectedPage;
    switch (selectedIndex) {
      case 0:
        userSelectedPage = const SpeciesListView();
        break;
      case 1:
        userSelectedPage = const CountryListView();
        break;
      case 2:
        userSelectedPage = const Placeholder();
        break;
      default:
        throw UnimplementedError('No widget for index: $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth <= 600) {
        return scaffoldForNarrowSreens(
            isDarkMode, context, constraints, userSelectedPage);
      } else {
        return scaffoldForWideSreens(
            isDarkMode, context, constraints, userSelectedPage);
      }
    });
  }

  Scaffold scaffoldForNarrowSreens(bool isDarkMode, BuildContext context,
      BoxConstraints constraints, Widget userSelectedPage) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
            child: Text('Traveler\'s Guide to Bats'),
          ),
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
          actions: [
            const Text('Night  '),
            SizedBox(
              width: 40,
              height: 28,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Switch(
                  value: isDarkMode,
                  onChanged: (bool value) {
                    setState(() {
                      context
                          .read<theme_cubit.ThemeCubit>()
                          .toggleTheme(!isDarkMode);
                    });
                  },
                ),
              ),
            ),
            const Text('  ')
          ]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue.shade200,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'Countries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'Settings',
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: Container(
              child: userSelectedPage,
            ),
          ),
        ],
      ),
    );
  }

  Scaffold scaffoldForWideSreens(bool isDarkMode, BuildContext context,
      BoxConstraints constraints, Widget userSelectedPage) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
            child: Text('Traveler\'s Guide to Bats'),
          ),
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
          actions: [
            const Text('Night  '),
            SizedBox(
              width: 40,
              height: 28,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Switch(
                  value: isDarkMode,
                  onChanged: (bool value) {
                    setState(() {
                      context
                          .read<theme_cubit.ThemeCubit>()
                          .toggleTheme(!isDarkMode);
                    });
                  },
                ),
              ),
            ),
            const Text('  ')
          ]),
      body: Row(
        children: [
          NavigationRail(
            extended: constraints.maxWidth >= 1000,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.public),
                label: Text('Countries'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.tune),
                label: Text('Settings'),
              ),
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
          ),
          Expanded(
            child: Container(
              child: userSelectedPage,
            ),
          ),
        ],
      ),
    );
  }
}
