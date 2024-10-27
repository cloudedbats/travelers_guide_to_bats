import 'package:flutter/material.dart';
import 'package:bat_species/src/data/model/model.dart' as model;

class CountryListView extends StatelessWidget {
  const CountryListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Filter...'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: model.countries.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  title: Text(model.countries[index].countryName),
                  trailing: Text(model.countries[index].countryCode),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
