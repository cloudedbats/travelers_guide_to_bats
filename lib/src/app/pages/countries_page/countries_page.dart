import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelers_guide_to_bats/src/app/pages/main_page/cubit/data_cubit.dart';
import 'package:travelers_guide_to_bats/src/app/pages/countries_page/cubit/countries_cubit.dart';

class CountryListView extends StatefulWidget {
  const CountryListView({
    super.key,
  });

  @override
  State<CountryListView> createState() => _CountryListViewState();
}

class _CountryListViewState extends State<CountryListView> {
  String? filterString;

  @override
  void initState() {
    super.initState();
    filterString = CountriesCubit.getLastUsedFilterString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: BlocConsumer<DataCubit, DataState>(
        listenWhen: (previous, current) {
          return true;
        },
        listener: (context, state) {
          // String enumAsString = state.dataResultData.status.name;
          // print('ByCountry status 2: $enumAsString');

          if (state.dataResultData.status == DataStatus.loading) {
            // TODO: Use widget instead.
            // print('Loading Data - Countries');
          }
          if (state.dataResultData.status == DataStatus.failure) {
            // TODO: Use widget instead.
            print('Exception Data 2: ${DataCubit.getLastException()}');
          }
          if (state.dataResultData.status == DataStatus.success) {
            String? value = CountriesCubit.getLastUsedFilterString();
            context.read<CountriesCubit>().filterCountryByString(value ?? '');
          }
        },
        buildWhen: (previous, current) {
          if (current.dataResultData.status == DataStatus.loading) {
            return false;
          }
          if (current.dataResultData.status == DataStatus.success) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 50, 5),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Country name/code filter',
                  ),
                  // initialValue: CountriesCubit.getLastUsedFilterString(),
                  initialValue: filterString,
                  onChanged: (String? value) {
                    setState(() {
                      filterString = value;
                    });
                    context
                        .read<CountriesCubit>()
                        .filterCountryByString(value ?? '');
                  },
                ),
              ),
              Expanded(
                child: BlocConsumer<CountriesCubit, CountriesState>(
                  listenWhen: (previous, current) {
                    return true;
                  },
                  listener: (context, state) {
                    if (state.countriesResultData.status ==
                        CountriesStatus.initial) {
                      context
                          .read<CountriesCubit>()
                          .filterCountryByString(filterString ?? '');
                    }
                  },
                  buildWhen: (previous, current) {
                    return true;
                  },
                  builder: (context, state) {
                    if (state.countriesResultData.status ==
                        CountriesStatus.success) {
                      var countryList =
                          state.countriesResultData.filteredCountries;
                      return ListView.builder(
                        itemCount: countryList.length,
                        itemBuilder: (context, index) => Card(
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
          );
        },
      ),
    );
  }
}
