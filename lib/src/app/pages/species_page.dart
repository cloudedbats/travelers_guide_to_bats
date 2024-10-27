import 'package:bat_species/src/data/model/model.dart' as model;
import 'package:flutter/material.dart';

class SpeciesListView extends StatelessWidget {
  const SpeciesListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),  
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Select country   '),
                DropdownButton(
                  items: const [
                    DropdownMenuItem(value: 'Aaaa', child: Text('Aaaa')),
                    DropdownMenuItem(value: 'Bbbb', child: Text('Bbbb')),
                    DropdownMenuItem(value: 'Cccc', child: Text('Cccc')),
                  ],
                  onChanged: (value) {},
                  value: 'Bbbb',
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: model.taxaInfo.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  title: Text(model.taxaInfo[index].scientificName,
                      style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold)),
                  subtitle: Text(model.taxaInfo[index].commonName),
                  trailing: Text(model.taxaInfo[index].redListCategory),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
