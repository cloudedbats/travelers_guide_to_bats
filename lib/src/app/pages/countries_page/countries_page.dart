import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelers_guide_to_bats/src/app/pages/countries_page/cubit/countries_cubit.dart';

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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 50, 5),
            // child: Text('Filter...'),
            child: TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Country name/code filter',
              ),
              onChanged: (value) =>
                  context.read<CountriesCubit>().filterCountryByString(value),
            ),
          ),
          Expanded(
            child: BlocBuilder<CountriesCubit, CountriesState>(
              builder: (context, state) {
                if (state.countriesResultData.status == Status.success) {
                  var countryList = state.countriesResultData.filteredCountries;
                  return ListView.builder(
                    itemCount: countryList.length,
                    itemBuilder: (context, index) => Card(
                      // child: ExpansionTile(
                      //   title: Text(countryList[index].countryName),
                      //   trailing: Text(countryList[index].countryCode),
                      //   // children: const <Widget>[
                      //   //   Text('111'),
                      //   //   Text('222'),
                      //   // ],
                      // ),
                      child: ListTile(
                        title: Text(countryList[index].countryName),
                        trailing: Text(countryList[index].countryCode),
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
