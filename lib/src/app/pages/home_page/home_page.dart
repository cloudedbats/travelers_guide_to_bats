import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../by_country_page/by_country_page.dart';
import '../bats_page/bats_page.dart';
import '../countries_page/countries_page.dart';
import '../main_page/cubit/theme_cubit.dart' as theme_cubit;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;
  var version = '';

  @override
  Widget build(BuildContext context) {
    getVersion();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Widget userSelectedPage;
    switch (selectedIndex) {
      case 0:
        userSelectedPage = const ByCountryView();
        break;
      case 1:
        userSelectedPage = const BatListView();
        break;
      case 2:
        userSelectedPage = const CountryListView();
        break;
      // case 3:
      //   aboutDialog(context);
      //   break;
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
          forceMaterialTransparency: true,
          title: const Center(
            child: Text(
              'Traveler\'s Guide to Bats',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          actions: [
            const Text('Dark '),
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
        selectedItemColor: Colors.blueGrey.shade200,
        unselectedItemColor: Colors.blueGrey.shade100,
        showUnselectedLabels: true,
        onTap: (value) {
          if (value == 3) {
            aboutDialog(context);
          } else {
            setState(() {
              selectedIndex = value;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'By country',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cruelty_free),
            label: 'Bats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.language),
            label: 'Countries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
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
          forceMaterialTransparency: true,
          title: const Center(
            child: Text(
              'Traveler\'s Guide to Bats',
              // style: TextStyle(
              //   fontSize: 18,
              // ),
            ),
          ),
          // leading: IconButton(
          //   onPressed: () {
          //     aboutDialog(context);
          //   },
          //   icon: Image.asset(
          //     'assets/icons/cloudedbats_logo.png',
          //     scale: 2,
          //   ),
          // ),
          actions: [
            const Text('Dark '),
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
                  icon: Tooltip(
                    message: 'Bats by country',
                    child: Icon(Icons.home),
                  ),
                  label: Text('By country'),
                ),
                NavigationRailDestination(
                  icon: Tooltip(
                    message: 'Bats',
                    child: Icon(Icons.cruelty_free),
                  ),
                  label: Text('Bats'),
                ),
                NavigationRailDestination(
                  icon: Tooltip(
                    message: 'Countries',
                    child: Icon(Icons.language),
                  ),
                  label: Text('Countries'),
                ),
                NavigationRailDestination(
                  icon: Tooltip(
                    message: 'About',
                    child: Icon(Icons.info),
                  ),
                  label: Text('About'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                if (value == 3) {
                  aboutDialog(context);
                } else {
                  setState(() {
                    selectedIndex = value;
                  });
                }
              }),
          Expanded(
            child: Container(
              child: userSelectedPage,
            ),
          ),
        ],
      ),
    );
  }

  void aboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      // applicationIcon: const FlutterLogo(),
      applicationIcon: Image.asset(
        'assets/icons/cloudedbats_logo.png',
        scale: 2,
      ),
      applicationName: 'Traveler\'s Guide to Bats',
      // applicationVersion: '2024.1.0 - development',
      applicationVersion: version,
      applicationLegalese:
          'The MIT License (MIT). Copyright (c) 2024 Arnold Andreasson.',
      children: [
        RichText(
          text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: <TextSpan>[
                TextSpan(text: '\n'),
                TextSpan(text: 'Sometimes it is difficult to find species '),
                TextSpan(text: 'lists of bats for different countries, '),
                TextSpan(text: 'but IUCN Red List of Threatened Species '),
                TextSpan(text: 'maintains that type of data.\n'),
                TextSpan(text: 'The purpose of this app is to make it easier '),
                TextSpan(text: 'to know what to look for '),
                TextSpan(text: 'when traveling to various countries.'),
                TextSpan(text: '\n\n'),
                TextSpan(text: 'Citation text for data from IUCN:\n'),
                TextSpan(
                    text:
                        '"IUCN 2024. IUCN Red List of Threatened Species. Version 2024-2 <www.iucnredlist.org>".'),
                TextSpan(text: '\n\n'),
                TextSpan(text: 'Please note that the Red List\'s categories '),
                TextSpan(text: 'and species distributions are based '),
                TextSpan(text: 'on the global assessment. '),
                TextSpan(text: 'This may differ from the assessments '),
                TextSpan(text: 'that are based on regions.'),
                TextSpan(text: '\n\n'),
                TextSpan(text: 'For developers:\n'),
                TextSpan(text: 'I wrote this app because I wanted to learn '),
                TextSpan(text: 'the basics of Flutter and Dart.\n'),
                TextSpan(
                    text:
                        'The cute rabbit is a placeholder for a long-eared bat, '),
                TextSpan(
                    text: 'the best one available in the default icon lib.\n'),
                TextSpan(
                    text: 'You can read more about the system on GitHub:\n'),
                TextSpan(
                    text:
                        'https://github.com/cloudedbats/travelers_guide_to_bats'),
              ]),
        ),
      ],
    );
  }

  void getVersion() {
    // PackageInfo packageInfo = await PackageInfo.fromPlatform();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      version = packageInfo.version;
    });
  }
}
