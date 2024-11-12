import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelers_guide_to_bats/src/data/model/model.dart' as model;
import 'package:travelers_guide_to_bats/src/app/pages/species_page/cubit/species_cubit.dart';

class SpeciesListView extends StatefulWidget {
  const SpeciesListView({
    super.key,
  });

  @override
  State<SpeciesListView> createState() => _SpeciesListViewState();
}

class _SpeciesListViewState extends State<SpeciesListView> {
  String? _dropDownValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton(
                  hint: const Text('Select country'),
                  items: model.countries.map((model.Country item) {
                    return DropdownMenuItem(
                        value: item.countryCode,
                        child: Text(item.countryName));
                  }).toList(),
                  value: _dropDownValue,
                  onChanged: (String? value) {
                    setState(() {
                      _dropDownValue = value;
                    });
                    context
                        .read<SpeciesCubit>()
                        .filterSpeciesByString(value ?? '');
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<SpeciesCubit, SpeciesState>(
              builder: (context, state) {
                // print(state.speciesResultData.status);
                if (state.speciesResultData.status == Status.success) {
                  var speciesList = state.speciesResultData.filteredSpecies;
                  return ListView.builder(
                    itemCount: speciesList.length,
                    itemBuilder: (context, index) => Card(
                      child: ListTile(
                        title: Text(speciesList[index].scientificName,
                            style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold)),
                        // subtitle: Text(speciesList[index].commonName),
                        subtitle: Text(
                            '${speciesList[index].taxonFamily}    ${speciesList[index].commonName}'),
                        trailing: Text(speciesList[index].redListCategory),
                      ),
                    ),
                  );
                } else {
                  return const Placeholder();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
